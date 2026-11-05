import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:character_data/character_data.dart';
import 'package:common_ui/common_ui.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:navigation/navigation.dart';

import '../../cyoc_feature_adapter.dart';
import '../../data/cyoc_suggestions_repository.dart';
import '../../flow/cyoc_flow_controller.dart';
import '../../models/builder_attributes.dart';
import '../../models/cyoc_character_choice.dart';
import '../../models/cyoc_generation_progress.dart';
import '../../models/cyoc_generation_result.dart';
import '../../models/cyoc_photo_style.dart';
import '../../models/cyoc_relationship_type.dart';
import '../../models/events/cyoc_creation_events.dart';
import '../../models/suggestion_type.dart';
import '../../route/cyoc_navigation_source.dart';
import '../../service/cyoc_assets_service.dart';
import '../../service/cyoc_generation_service.dart';
import '../../usecase/create_character_from_generation_use_case.dart';
import 'cyoc_creation_step.dart';

part 'cyoc_creation_state.dart';

class CyocCreationCubit extends Cubit<CyocCreationState> with SafeCubit<CyocCreationState> {
  CyocCreationCubit(
    this._generationService,
    this._assetsService,
    this._suggestionsRepository,
    this._createCharacter,
    this._adapter,
    this._navigator,
    this._analyticsService,
    this._logger,
    this._source,
  ) : super(CyocCreationState(choice: const CyocCharacterChoice().withBuilderDefaults())) {
    _flowSubscription = _flow.stream.listen(_onStepChanged);
    _analyticsService.trackEvent(CyocCreationOpenEvent(_source.analyticsName));
  }

  final CyocGenerationService _generationService;
  final CyocAssetsService _assetsService;
  final CyocSuggestionsRepository _suggestionsRepository;
  final CreateCharacterFromGenerationUseCase _createCharacter;
  final CyocFeatureAdapter _adapter;
  final AppNavigator _navigator;
  final AnalyticsService _analyticsService;
  final Logger _logger;
  final CyocNavigationSource _source;

  final CyocFlowController _flow = CyocFlowController(initialSteps: CyocCreationStep.values);
  StreamSubscription<CyocFlowState>? _flowSubscription;
  bool _leaving = false;

  Cubit<CyocFlowState> get flow => _flow;

  String assetUrl(String key) => _assetsService.getAsset(key);

  void updateGender(CharacterGender gender) => _updateChoice(state.choice.withGender(gender));

  void updateStyle(CyocPhotoStyle style) => _updateChoice(state.choice.copyWith(style: style));

  void updateAge(int age) => _updateChoice(state.choice.copyWith(age: age));

  void updateEthnicity(CyocEthnicity ethnicity) =>
      _updateChoice(state.choice.copyWith(ethnicity: ethnicity));

  void updateBodyType(CyocBodyType bodyType) =>
      _updateChoice(state.choice.copyWith(bodyType: bodyType));

  void updateHairStyle(CyocHairStyle hairStyle) =>
      _updateChoice(state.choice.copyWith(hairStyle: hairStyle));

  void updateHairColor(CyocHairColor hairColor) =>
      _updateChoice(state.choice.copyWith(hairColor: hairColor));

  void updateEyeColor(CyocEyeColor eyeColor) =>
      _updateChoice(state.choice.copyWith(eyeColor: eyeColor));

  void updateFacialHair(CyocFacialHair facialHair) =>
      _updateChoice(state.choice.copyWith(facialHair: facialHair));

  void updatePersonality(CyocPersonality personality) =>
      _updateChoice(state.choice.copyWith(personality: personality));

  void updateName(String name) => _updateChoice(state.choice.copyWith(name: name));

  Future<void> suggestName() async {
    _analyticsService.trackEvent(CyocCreationAutoSuggestTappedEvent.name());
    final suggestion = await _randomSuggestion(
      state.choice.gender == CharacterGender.male
          ? SuggestionType.maleName
          : SuggestionType.femaleName,
    );
    if (suggestion.isEmpty) {
      return;
    }
    _updateChoice(state.choice.copyWith(name: suggestion));
  }

  void updateRelationship(CyocRelationshipType relationship) =>
      safeEmit(state.copyWith(relationship: relationship));

  Future<void> generate() async {
    _analyticsService.trackEvent(CyocCreationGenerateTappedEvent(state.choice));
    await _startGeneration(isRegeneration: false);
  }

  Future<void> regenerate() async {
    _analyticsService.trackEvent(CyocCreationRegenerateTappedEvent());
    await _startGeneration(isRegeneration: true);
  }

  void onToastShown() => safeEmit(state.copyWith(toast: CyocCreationToast.none));

  void continueFromResult() => _flow.goTo(CyocCreationStep.nameRelationship);

  Future<void> back() async {
    final current = _flow.state.current;
    if (current == CyocCreationStep.photoPreview) {
      _backFromResult();
      return;
    }
    if (current == CyocCreationStep.generation) {
      await _backFromGeneration();
      return;
    }
    _flow.back();
  }

  void next() => _flow.next();

  Future<void> onExitRequested() async {
    if (state.processing || !_claimLeave()) {
      return;
    }
    if (state.generation.isRunning) {
      try {
        await _generationService.cancel();
      } on Object catch (e) {
        _logger.e('[CyocCreationCubit] generation cancel failed: $e');
      }
    }
    _analyticsService.trackEvent(CyocCreationAbortTappedEvent(_flow.state.current.key));
    _navigator.goBack();
  }

  Future<void> createCharacter() async {
    final result = state.result;
    if (state.processing) {
      return;
    }
    if (!state.canCreateCharacter || result == null) {
      _logger.e('[CyocCreationCubit] create character without name, start-as or generation');
      return;
    }
    safeEmit(state.copyWith(processing: true));
    try {
      await _createCharacter(choice: state.choice, result: result);
      if (!_claimLeave()) {
        return;
      }
      _navigator.goBack();
      _adapter.openCards();
    } on Object catch (e) {
      _logger.e('[CyocCreationCubit] character creation failed: $e');
      _analyticsService.trackEvent(CyocCreationFailedEvent('commonError'));
      safeEmit(state.copyWith(toast: CyocCreationToast.creationFailed));
    } finally {
      safeEmit(state.copyWith(processing: false), logger: _logger);
    }
  }

  @override
  Future<void> close() async {
    await _flowSubscription?.cancel();
    await _generationService.cancel();
    await _flow.close();
    return super.close();
  }

  bool _claimLeave() {
    if (_leaving || isClosed) {
      return false;
    }
    _leaving = true;
    return true;
  }

  void _updateChoice(CyocCharacterChoice choice) {
    safeEmit(state.copyWith(choice: choice.withBuilderDefaults()));
  }

  Future<String> _randomSuggestion(SuggestionType type) async {
    try {
      return await _suggestionsRepository.getRandomSuggestion(type);
    } on Object catch (e) {
      _logger.e('[CyocCreationCubit] suggestion failed: $e');
      return '';
    }
  }

  void _onStepChanged(CyocFlowState flowState) {
    _analyticsService.trackEvent(CyocCreationStepOpenedEvent(flowState.current.key));
  }

  Future<void> _startGeneration({required bool isRegeneration}) async {
    final generationId = state.result?.generationId;
    if (isRegeneration && generationId != null) {
      await _runGeneration(
        isRegeneration: true,
        produce: () => _generationService.regenerate(generationId),
      );
      return;
    }
    await _runGeneration(
      isRegeneration: isRegeneration,
      produce: () => _generationService.generate(state.choice),
    );
  }

  Future<void> _runGeneration({
    required bool isRegeneration,
    required Future<CyocGenerationResult> Function() produce,
  }) async {
    if (state.processing || state.generation.isRunning) {
      return;
    }
    safeEmit(
      state.copyWith(
        generation: isRegeneration
            ? state.generation.runningKeepingResult()
            : state.generation.runningClearingResult(),
      ),
    );
    _flow.goTo(CyocCreationStep.generation);
    try {
      final result = await produce();
      safeEmit(state.copyWith(generation: state.generation.completed(result)), logger: _logger);
      _flow.goTo(CyocCreationStep.photoPreview);
    } on CyocGenerationCancelledException {
      safeEmit(state.copyWith(generation: state.generation.cancelled()), logger: _logger);
    } on Object catch (e) {
      _logger.e('[CyocCreationCubit] generation failed: $e');
      safeEmit(
        state.copyWith(
          generation: state.generation.failed(),
          toast: CyocCreationToast.generationFailed,
        ),
        logger: _logger,
      );
      if (!isClosed) {
        _flow.goTo(
          state.generation.hasResult ? CyocCreationStep.photoPreview : CyocCreationStep.yourChoice,
        );
      }
    }
  }

  void _backFromResult() {
    safeEmit(state.copyWith(generation: const CyocGenerationProgress()), logger: _logger);
    _goToInputs();
  }

  Future<void> _backFromGeneration() async {
    if (state.generation.isRunning) {
      await _generationService.cancel();
    }
    _goToInputs();
  }

  void _goToInputs() => _flow.goTo(CyocCreationStep.yourChoice);
}
