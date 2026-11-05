import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:collection/collection.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigation/navigation.dart';

import '../flow/flow_host.dart';
import '../handler/completion_handler_provider.dart';
import '../handler/event_handler_provider.dart';
import '../handler/survey_analytics_event_handler.dart';
import '../handler/survey_event_handler.dart';
import '../model/survey_flow_config.dart';
import '../model/survey_screen_model.dart';
import '../repository/survey_repository.dart';
import '../route/survey_navigator.dart';
import '../route/survey_paths.dart';

part 'root_bloc_event.dart';
part 'root_bloc_state.dart';

class BaseSurveyRootBloc<T extends SurveyScreenModel> extends Bloc<RootEvent, RootState>
    implements SurveyNavigator {
  BaseSurveyRootBloc(
    this._appNavigator,
    this._logger,
    this._configModel,
    this._flowController,
    this._surveyRepository,
    this._completionHandlerProvider,
    this._eventHandlerProvider,
  ) : super(const RootState.init()) {
    if (_configModel == null) {
      _logger.e('[BaseSurveyRootBloc] config is null, survey will not be displayed');
    }

    _screenKeySubscription = _flowController.screenKeyStream.listen((screenKey) {
      add(RootScreenKeyChangedEvent(screenKey: screenKey));
    });

    on<RootScreenKeyChangedEvent>(_onScreenKeyChanged);
    on<RootScreenBackPressedEvent>(_onBackPressed, transformer: sequential());
    on<RootScreenClosePressedEvent>(_onClosePressed, transformer: droppable());
    on<RootContinuePressedEvent>(_onContinuePressed, transformer: sequential());
  }

  final AppNavigator _appNavigator;
  final SurveyFlowConfig<T>? _configModel;
  final Logger _logger;
  final FlowHostController<T> _flowController;
  final CompletionHandlerProvider _completionHandlerProvider;
  final EventHandlerProvider _eventHandlerProvider;
  final SurveyRepository _surveyRepository;

  late final StreamSubscription<String> _screenKeySubscription;
  final List<String> _history = [];

  @override
  Future<void> close() async {
    await _screenKeySubscription.cancel();
    return super.close();
  }

  @override
  Future<void> goNext(SurveyScreenModel currentScreen, {Object? answer}) {
    _logNavigation('goNext from=${currentScreen.key} answerType=${_answerType(answer)}');
    if (_configModel == null || isClosed) {
      return Future<void>.value();
    }
    final continueEvent = RootContinuePressedEvent(currentScreen, answer: answer);
    add(continueEvent);
    return continueEvent.processed.future;
  }

  List<SurveyEventHandler> _getHandlersForScreen(String screenKey) {
    final configModel = _configModel;
    if (configModel == null) {
      return const [];
    }

    final configs = configModel.eventHandlerConfigs;
    if (configs.isEmpty) {
      final analytics = _eventHandlerProvider.getHandler(
        SurveyAnalyticsEventHandler.type,
        surveyId: configModel.surveyId,
      );
      return [?analytics];
    }

    final handlers = <SurveyEventHandler>[];
    for (final config in configs) {
      if (!config.shouldHandle(screenKey)) {
        continue;
      }

      final handler = _eventHandlerProvider.getHandler(config.type, surveyId: configModel.surveyId);
      if (handler != null) {
        handlers.add(handler);
      }
    }

    return handlers;
  }

  void _onScreenKeyChanged(RootScreenKeyChangedEvent event, Emitter<RootState> emit) {
    final configModel = _configModel;
    if (configModel == null || state.finished) {
      return;
    }
    final screenKey = event.screenKey;
    final index = configModel.screens.indexWhere((screen) => screen.key == screenKey);
    if (index == -1) {
      return;
    }
    final currScreenModel = configModel.screens[index];

    _logNavigation('screen=$screenKey index=${index + 1}/${configModel.screens.length}');
    _trackHistory(screenKey);

    for (final handler in _getHandlersForScreen(screenKey)) {
      handler.onScreenChanged(currScreenModel);
    }

    emit(
      state.copyWith(totalScreenNumber: configModel.screens.length, currentScreenNumber: index + 1),
    );
  }

  Future<void> _onBackPressed(RootScreenBackPressedEvent event, Emitter<RootState> emit) async {
    if (state.exit == SurveyExit.awaitingPop) {
      _popIfOnTop(emit);
      return;
    }
    if (state.finished || _flowController.currentKey != event.screenKey) {
      _logNavigation('back from ${event.screenKey} ignored: survey moved on');
      return;
    }
    final previousKey = _popPreviousKey();
    _logNavigation('back pressed previous=$previousKey');
    if (previousKey == null) {
      await _finish(emit, reason: 'back from first screen');
      return;
    }
    _flowController.goToKey(previousKey);
  }

  void _trackHistory(String screenKey) {
    if (_history.isEmpty || _history.last != screenKey) {
      _history.add(screenKey);
    }
  }

  String? _popPreviousKey() {
    if (_history.length <= 1) {
      return null;
    }
    _history.removeLast();
    return _history.last;
  }

  void _logNavigation(String message) {
    _logger.d('[SurveyFlow] : $message');
  }

  String _answerType(Object? answer) {
    if (answer == null) {
      return 'null';
    }
    if (answer is List) {
      return 'List(${answer.length})';
    }
    return answer.runtimeType.toString();
  }

  Future<void> _onClosePressed(RootScreenClosePressedEvent event, Emitter<RootState> emit) async {
    final closeHandler = _completionHandlerProvider.getCloseHandler(_configModel?.closeHandlerType);
    await _finish(
      emit,
      reason: 'closed',
      handler: closeHandler == null
          ? null
          : () => closeHandler.execute(_surveyId, _surveyRepository.answers),
    );
  }

  Future<void> _onContinuePressed(RootContinuePressedEvent event, Emitter<RootState> emit) async {
    try {
      await _continue(event, emit);
    } finally {
      event.processed.complete();
    }
  }

  Future<void> _continue(RootContinuePressedEvent event, Emitter<RootState> emit) async {
    final configModel = _configModel;
    final currentScreen = event.currentScreen;
    if (configModel == null || !_isActiveOn(currentScreen)) {
      _logNavigation('continue from ${currentScreen.key} ignored: survey moved on');
      return;
    }

    final outcome = await _runHandlers(event);
    if (!_isActiveOn(currentScreen)) {
      _logNavigation('continue from ${currentScreen.key} dropped: survey changed during handlers');
      return;
    }

    final answer = event.answer;
    if (answer != null) {
      _surveyRepository.setAnswer(screenKey: currentScreen.key, answer: answer);
    }

    final nextScreen = outcome == SurveyHandlerOutcome.finish
        ? null
        : _computeNextScreen(configModel, currentScreen, answer);
    if (nextScreen == null) {
      await _finish(emit, reason: 'completed at ${currentScreen.key}', handler: _runCompletion);
      return;
    }

    _logNavigation('${currentScreen.key} -> ${nextScreen.key}');
    _flowController.goToKey(nextScreen.key);
  }

  Future<SurveyHandlerOutcome> _runHandlers(RootContinuePressedEvent event) async {
    var outcome = SurveyHandlerOutcome.proceed;
    for (final handler in _getHandlersForScreen(event.currentScreen.key)) {
      try {
        final result = await handler.handle(event.currentScreen, event.answer);
        if (result == SurveyHandlerOutcome.finish) {
          outcome = SurveyHandlerOutcome.finish;
        }
      } catch (e, stackTrace) {
        _logger.e(
          '[BaseSurveyRootBloc] ${handler.runtimeType} failed on ${event.currentScreen.key}',
          error: e,
          stackTrace: stackTrace,
        );
      }
      if (!_isActiveOn(event.currentScreen)) {
        break;
      }
    }
    return outcome;
  }

  bool _isActiveOn(SurveyScreenModel screen) =>
      !isClosed && !state.finished && _flowController.currentKey == screen.key;

  Future<void> _runCompletion() async {
    await _completionHandlerProvider
        .getCompletionHandler(_configModel?.completionHandlerType)
        ?.execute(_surveyId, _surveyRepository.answers);
  }

  Future<void> _finish(
    Emitter<RootState> emit, {
    required String reason,
    Future<void> Function()? handler,
  }) async {
    if (isClosed) {
      return;
    }
    switch (state.exit) {
      case SurveyExit.inProgress:
        return;
      case SurveyExit.awaitingPop:
        _popIfOnTop(emit);
        return;
      case SurveyExit.none:
        break;
    }
    emit(state.copyWith(exit: SurveyExit.inProgress));
    _logNavigation('finish: $reason');
    try {
      await handler?.call();
    } catch (e, stackTrace) {
      _logger.e('[BaseSurveyRootBloc] finish handler failed', error: e, stackTrace: stackTrace);
    }
    _popIfOnTop(emit);
  }

  void _popIfOnTop(Emitter<RootState> emit) {
    if (isClosed) {
      return;
    }
    if (Uri.parse(_appNavigator.currentPath).path == SurveyPath.screen.path) {
      emit(state.copyWith(exit: SurveyExit.inProgress));
      _appNavigator.goBack();
      return;
    }
    _logNavigation('survey route is not on top, waiting for the next close or back');
    emit(state.copyWith(exit: SurveyExit.awaitingPop));
  }

  String get _surveyId => _configModel?.surveyId ?? 'unknown';

  @protected
  SurveyScreenModel? resolveNavigationRule(
    SurveyFlowConfig<T> configModel,
    SurveyScreenModel currentScreen,
    Object? answer,
  ) {
    final rules = currentScreen.navigation?.rules;
    if (rules == null || rules.isEmpty) {
      return null;
    }
    for (final rule in rules) {
      final nextKey = rule.evaluate(answer);
      if (nextKey == null) {
        continue;
      }
      final screen = configModel.screens.firstWhereOrNull((item) => item.key == nextKey);
      if (screen != null) {
        _logger.d('[SurveyFlow] : navigation rule -> ${currentScreen.key} -> $nextKey');
        return screen;
      }
    }
    return null;
  }

  T? _computeNextScreen(
    SurveyFlowConfig<T> configModel,
    SurveyScreenModel currentScreen,
    Object? answer,
  ) {
    final navigationTarget = resolveNavigationRule(configModel, currentScreen, answer);
    if (navigationTarget != null) {
      return navigationTarget as T?;
    }

    final indexOfCurrScreen = configModel.screens.indexWhere(
      (screen) => screen.key == currentScreen.key,
    );
    if (indexOfCurrScreen == -1 || indexOfCurrScreen == configModel.screens.length - 1) {
      return null;
    }
    return configModel.screens[indexOfCurrScreen + 1];
  }
}
