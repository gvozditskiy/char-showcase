import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:navigation/navigation.dart';
import 'package:survey/survey.dart';

class _MockAppNavigator extends Mock implements AppNavigator {}

class _MockAnalyticsService extends Mock implements AnalyticsService {}

class _MockLogger extends Mock implements Logger {}

class _MockCompletionHandlerProvider extends Mock implements CompletionHandlerProvider {}

class _MockEventHandlerProvider extends Mock implements EventHandlerProvider {}

class _MockCompletionHandler extends Mock implements CompletionHandler {}

class _MockSurveyEventHandler extends Mock implements SurveyEventHandler {}

class _FakeSurveyScreenModel extends Fake implements SurveyScreenModel {}

const _positiveType = 'rate_app_positive';
const _negativeType = 'rate_app_negative_feedback';

void main() {
  setUpAll(() {
    registerFallbackValue(const AnalyticsEvent(name: 'fallback'));
    registerFallbackValue(_FakeSurveyScreenModel());
    registerFallbackValue(<String, dynamic>{});
  });

  late AppNavigator appNavigator;
  late AnalyticsService analyticsService;
  late CompletionHandlerProvider completionHandlerProvider;
  late EventHandlerProvider eventHandlerProvider;
  late CompletionHandler completionHandler;
  late CompletionHandler closeHandler;
  late SurveyEventHandler positiveHandler;
  late SurveyEventHandler negativeHandler;
  late FlowHostController<SurveyScreenModel> flowController;
  late SurveyFlowConfig<SurveyScreenModel> config;
  late BaseSurveyRootBloc<SurveyScreenModel> bloc;

  SurveyScreenModel screen(String key) => config.screens.singleWhere((s) => s.key == key);

  setUp(() async {
    appNavigator = _MockAppNavigator();
    analyticsService = _MockAnalyticsService();
    completionHandlerProvider = _MockCompletionHandlerProvider();
    eventHandlerProvider = _MockEventHandlerProvider();
    completionHandler = _MockCompletionHandler();
    closeHandler = _MockCompletionHandler();
    positiveHandler = _MockSurveyEventHandler();
    negativeHandler = _MockSurveyEventHandler();
    flowController = FlowHostController<SurveyScreenModel>();

    final json =
        jsonDecode(File('test/fixtures/feedback_rate_app.json').readAsStringSync())
            as Map<String, dynamic>;
    config = (await BaseSurveyConfigParserImpl(_MockLogger()).parse(json))!;

    when(() => appNavigator.currentPath).thenReturn(SurveyPath.screen.path);
    when(() => completionHandlerProvider.getCompletionHandler(any())).thenReturn(completionHandler);
    when(() => completionHandlerProvider.getCloseHandler(any())).thenReturn(closeHandler);
    when(() => completionHandler.execute(any(), any())).thenAnswer((_) async {});
    when(() => closeHandler.execute(any(), any())).thenAnswer((_) async {});
    when(
      () => eventHandlerProvider.getHandler(_positiveType, surveyId: any(named: 'surveyId')),
    ).thenReturn(positiveHandler);
    when(
      () => eventHandlerProvider.getHandler(_negativeType, surveyId: any(named: 'surveyId')),
    ).thenReturn(negativeHandler);
    when(
      () => eventHandlerProvider.getHandler(
        SurveyAnalyticsEventHandler.type,
        surveyId: any(named: 'surveyId'),
      ),
    ).thenAnswer(
      (invocation) => SurveyAnalyticsEventHandler(
        analyticsService,
        surveyId: invocation.namedArguments[#surveyId] as String?,
      ),
    );
    for (final handler in [positiveHandler, negativeHandler]) {
      when(
        () => handler.handle(any(), any()),
      ).thenAnswer((_) async => SurveyHandlerOutcome.proceed);
    }

    bloc = BaseSurveyRootBloc<SurveyScreenModel>(
      appNavigator,
      _MockLogger(),
      config,
      flowController,
      SurveyRepository(),
      completionHandlerProvider,
      eventHandlerProvider,
    );
    flowController.setInitialKey('rating');
    await pumpEventQueue();
  });

  tearDown(() async {
    await bloc.close();
    flowController.dispose();
  });

  test('rating screen is tracked by the analytics handler listed in the config', () {
    final events = verify(
      () => analyticsService.trackEvent(captureAny()),
    ).captured.cast<AnalyticsEvent>();

    expect(events.single.name, SurveyScreenOpenedEvent.defaultEventName);
    expect(events.single.params, {
      SurveyScreenOpenedEvent.screenKeyParam: 'rating',
      SurveyScreenOpenedEvent.surveyIdParam: 'rate_app',
    });
  });

  test('rating step is tracked once with the answer and the survey id', () async {
    clearInteractions(analyticsService);

    await bloc.goNext(screen('rating'), answer: 4);

    final steps = verify(
      () => analyticsService.trackEvent(captureAny()),
    ).captured.cast<AnalyticsEvent>().where((event) => event.name == SurveyStepEvent.eventName);
    expect(steps.single.params, {
      SurveyStepEvent.screenKey: 'rating',
      SurveyStepEvent.surveyId: 'rate_app',
      SurveyStepEvent.answer: 4,
    });
  });

  test('a config without handlers tracks analytics on every screen by default', () async {
    final json =
        jsonDecode(File('test/fixtures/feedback_rate_app.json').readAsStringSync())
              as Map<String, dynamic>
          ..remove('eventHandlers');
    final plainConfig = (await BaseSurveyConfigParserImpl(_MockLogger()).parse(json))!;
    final plainFlow = FlowHostController<SurveyScreenModel>();
    final plainBloc = BaseSurveyRootBloc<SurveyScreenModel>(
      appNavigator,
      _MockLogger(),
      plainConfig,
      plainFlow,
      SurveyRepository(),
      completionHandlerProvider,
      eventHandlerProvider,
    );
    plainFlow.setInitialKey('rating');
    await pumpEventQueue();

    await plainBloc.goNext(plainConfig.screens.first, answer: 5);
    await pumpEventQueue();

    final names = verify(
      () => analyticsService.trackEvent(captureAny()),
    ).captured.cast<AnalyticsEvent>().map((event) => event.name);
    expect(
      names.where((name) => name == SurveyScreenOpenedEvent.defaultEventName).length,
      greaterThanOrEqualTo(2),
    );
    expect(names, contains(SurveyStepEvent.eventName));
    await plainBloc.close();
    plainFlow.dispose();
  });

  test('negative rating goes to negative_feedback', () async {
    await bloc.goNext(screen('rating'), answer: 2);
    await pumpEventQueue();

    expect(flowController.currentKey, 'negative_feedback');
    expect(bloc.state.currentScreenNumber, 2);
    verify(() => negativeHandler.onScreenChanged(screen('negative_feedback'))).called(1);
    verifyNever(
      () => eventHandlerProvider.getHandler(_positiveType, surveyId: any(named: 'surveyId')),
    );
  });

  test('positive rating goes to store_rating', () async {
    await bloc.goNext(screen('rating'), answer: 5);
    await pumpEventQueue();

    expect(flowController.currentKey, 'store_rating');
    expect(bloc.state.currentScreenNumber, 3);
    verifyNever(
      () => eventHandlerProvider.getHandler(_negativeType, surveyId: any(named: 'surveyId')),
    );
  });

  test('rate_app_positive is resolved and called only on store_rating', () async {
    await bloc.goNext(screen('rating'), answer: 5);
    verifyNever(
      () => eventHandlerProvider.getHandler(_positiveType, surveyId: any(named: 'surveyId')),
    );

    await pumpEventQueue();
    verify(
      () => eventHandlerProvider.getHandler(_positiveType, surveyId: any(named: 'surveyId')),
    ).called(1);
    verify(() => positiveHandler.onScreenChanged(screen('store_rating'))).called(1);

    await bloc.goNext(screen('store_rating'));

    final handledScreens = verify(() => positiveHandler.handle(captureAny(), any())).captured;
    expect(handledScreens, [screen('store_rating')]);
    verifyNever(() => negativeHandler.handle(any(), any()));
  });

  test('completing the last screen executes completion handler and goes back', () async {
    await bloc.goNext(screen('rating'), answer: 5);
    await pumpEventQueue();

    await bloc.goNext(screen('store_rating'));

    verify(() => completionHandler.execute('rate_app', {'rating': 5})).called(1);
    verify(() => appNavigator.goBack()).called(1);
    expect(flowController.currentKey, 'store_rating');
  });

  test('handler returning finish completes the survey and closes the route once', () async {
    await bloc.goNext(screen('rating'), answer: 2);
    await pumpEventQueue();
    when(
      () => negativeHandler.handle(any(), any()),
    ).thenAnswer((_) async => SurveyHandlerOutcome.finish);

    await bloc.goNext(screen('negative_feedback'));
    await pumpEventQueue();

    expect(flowController.currentKey, 'negative_feedback');
    expect(bloc.state.finished, isTrue);
    verify(() => completionHandler.execute('rate_app', {'rating': 2})).called(1);
    verify(() => appNavigator.goBack()).called(1);
    verifyNever(
      () => eventHandlerProvider.getHandler(_positiveType, surveyId: any(named: 'surveyId')),
    );
  });

  test('double continue on the same screen runs its handlers once', () async {
    await bloc.goNext(screen('rating'), answer: 2);
    await pumpEventQueue();
    when(
      () => negativeHandler.handle(any(), any()),
    ).thenAnswer((_) async => SurveyHandlerOutcome.finish);

    await Future.wait([
      bloc.goNext(screen('negative_feedback')),
      bloc.goNext(screen('negative_feedback')),
    ]);

    verify(() => negativeHandler.handle(any(), any())).called(1);
    verify(() => completionHandler.execute(any(), any())).called(1);
    verify(() => appNavigator.goBack()).called(1);
  });

  test('close while a handler runs closes once and drops the pending continue', () async {
    await bloc.goNext(screen('rating'), answer: 2);
    await pumpEventQueue();
    final gate = Completer<SurveyHandlerOutcome>();
    when(() => negativeHandler.handle(any(), any())).thenAnswer((_) => gate.future);

    final continued = bloc.goNext(screen('negative_feedback'));
    await pumpEventQueue();
    bloc.add(const RootScreenClosePressedEvent());
    await pumpEventQueue();
    gate.complete(SurveyHandlerOutcome.finish);
    await continued;

    verify(() => closeHandler.execute('rate_app', {'rating': 2})).called(1);
    verifyNever(() => completionHandler.execute(any(), any()));
    verify(() => appNavigator.goBack()).called(1);
  });

  test('back while a handler runs drops the stale continue', () async {
    await bloc.goNext(screen('rating'), answer: 5);
    await pumpEventQueue();
    final gate = Completer<SurveyHandlerOutcome>();
    when(() => positiveHandler.handle(any(), any())).thenAnswer((_) => gate.future);

    final continued = bloc.goNext(screen('store_rating'));
    await pumpEventQueue();
    bloc.add(const RootScreenBackPressedEvent(screenKey: 'store_rating'));
    await pumpEventQueue();
    gate.complete(SurveyHandlerOutcome.proceed);
    await continued;

    expect(flowController.currentKey, 'rating');
    expect(bloc.state.finished, isFalse);
    verifyNever(() => completionHandler.execute(any(), any()));
    verifyNever(() => appNavigator.goBack());
  });

  test('a failing handler is logged and treated as proceed', () async {
    await bloc.goNext(screen('rating'), answer: 2);
    await pumpEventQueue();
    when(() => negativeHandler.handle(any(), any())).thenThrow(StateError('boom'));

    await bloc.goNext(screen('negative_feedback'));
    await pumpEventQueue();

    expect(flowController.currentKey, 'store_rating');
    verifyNever(() => completionHandler.execute(any(), any()));
    verifyNever(() => appNavigator.goBack());
  });

  test('a fast double back from the second screen lands on the first one', () async {
    await bloc.goNext(screen('rating'), answer: 2);
    await pumpEventQueue();

    bloc
      ..add(const RootScreenBackPressedEvent(screenKey: 'negative_feedback'))
      ..add(const RootScreenBackPressedEvent(screenKey: 'negative_feedback'));
    await pumpEventQueue();

    expect(flowController.currentKey, 'rating');
    expect(bloc.state.finished, isFalse);
    verifyNever(() => appNavigator.goBack());
  });

  test('back on the first screen closes the survey without the close handler', () async {
    bloc.add(const RootScreenBackPressedEvent(screenKey: 'rating'));
    await pumpEventQueue();

    verify(() => appNavigator.goBack()).called(1);
    verifyNever(() => closeHandler.execute(any(), any()));
  });

  test('does not pop when the survey route is no longer on top and stays closable', () async {
    when(() => appNavigator.currentPath).thenReturn('/cards');

    bloc.add(const RootScreenClosePressedEvent());
    await pumpEventQueue();

    verify(() => closeHandler.execute('rate_app', {})).called(1);
    verifyNever(() => appNavigator.goBack());
    expect(bloc.state.exit, SurveyExit.awaitingPop);

    when(() => appNavigator.currentPath).thenReturn(SurveyPath.screen.path);
    bloc.add(const RootScreenClosePressedEvent());
    await pumpEventQueue();

    verifyNever(() => closeHandler.execute(any(), any()));
    verify(() => appNavigator.goBack()).called(1);
  });

  test('completion while the survey is not on top runs once and pops later', () async {
    await bloc.goNext(screen('rating'), answer: 5);
    await pumpEventQueue();
    when(() => appNavigator.currentPath).thenReturn('/cards');

    await bloc.goNext(screen('store_rating'));
    when(() => appNavigator.currentPath).thenReturn(SurveyPath.screen.path);
    await bloc.goNext(screen('store_rating'));
    bloc.add(const RootScreenBackPressedEvent(screenKey: 'store_rating'));
    await pumpEventQueue();

    verify(() => positiveHandler.handle(any(), any())).called(1);
    verify(() => completionHandler.execute(any(), any())).called(1);
    verifyNever(() => closeHandler.execute(any(), any()));
    verify(() => appNavigator.goBack()).called(1);
  });

  test('close executes close handler and goes back', () async {
    bloc.add(const RootScreenClosePressedEvent());
    await pumpEventQueue();

    verify(() => closeHandler.execute('rate_app', {})).called(1);
    verify(() => appNavigator.goBack()).called(1);
    verifyNever(() => completionHandler.execute(any(), any()));
  });
}
