import 'dart:async';

import 'package:character_data/character_data.dart';
import 'package:core/core.dart';
import 'package:cyoc/src/cyoc_feature_adapter.dart';
import 'package:cyoc/src/data/cyoc_suggestions_repository.dart';
import 'package:cyoc/src/flows/creation/cyoc_creation_cubit.dart';
import 'package:cyoc/src/flows/creation/cyoc_creation_step.dart';
import 'package:cyoc/src/models/builder_attributes.dart';
import 'package:cyoc/src/models/cyoc_generation_progress.dart';
import 'package:cyoc/src/models/cyoc_relationship_type.dart';
import 'package:cyoc/src/models/suggestion_type.dart';
import 'package:cyoc/src/route/cyoc_navigation_source.dart';
import 'package:cyoc/src/service/fake_cyoc_assets_service.dart';
import 'package:cyoc/src/service/fake_cyoc_generation_service.dart';
import 'package:cyoc/src/usecase/create_character_from_generation_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:navigation/navigation.dart';

class _MockCharacterRepository extends Mock implements CharacterRepository {}

class _MockSuggestionsRepository extends Mock implements CyocSuggestionsRepository {}

class _MockCyocFeatureAdapter extends Mock implements CyocFeatureAdapter {}

class _MockAppNavigator extends Mock implements AppNavigator {}

class _MockLogger extends Mock implements Logger {}

class _MockAnalyticsService extends Mock implements AnalyticsService {}

class _FakeAnalyticsEvent extends Fake implements AnalyticsEvent {}

class _FakeCharacterModel extends Fake implements CharacterModel {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeAnalyticsEvent());
    registerFallbackValue(_FakeCharacterModel());
    registerFallbackValue(SuggestionType.femaleName);
  });

  late _MockCharacterRepository characterRepository;
  late _MockSuggestionsRepository suggestionsRepository;
  late _MockCyocFeatureAdapter adapter;
  late _MockAppNavigator navigator;
  late _MockLogger logger;
  late _MockAnalyticsService analyticsService;

  CyocCreationCubit buildCubit({Duration delay = Duration.zero}) => CyocCreationCubit(
    FakeCyocGenerationService(const FakeCyocAssetsService(), delay: delay),
    const FakeCyocAssetsService(),
    suggestionsRepository,
    CreateCharacterFromGenerationUseCase(characterRepository),
    adapter,
    navigator,
    analyticsService,
    logger,
    CyocNavigationSource.navBar,
  );

  setUp(() {
    characterRepository = _MockCharacterRepository();
    suggestionsRepository = _MockSuggestionsRepository();
    adapter = _MockCyocFeatureAdapter();
    navigator = _MockAppNavigator();
    logger = _MockLogger();
    analyticsService = _MockAnalyticsService();

    when(
      () => characterRepository.createCharacterFromGeneration(any()),
    ).thenAnswer((invocation) async => invocation.positionalArguments.first as CharacterModel);
  });

  group('step navigation', () {
    test('starts on genderStyleAge with builder defaults and the first progress segment', () async {
      final cubit = buildCubit();

      expect(cubit.flow.state.current, CyocCreationStep.genderStyleAge);
      expect(cubit.flow.state.progressIndex, 1);
      expect(cubit.flow.state.progressTotal, 5);
      expect(cubit.state.choice.personality, CyocPersonality.sweetheart);
      await cubit.close();
    });

    test('next walks the builder steps and back returns one step', () async {
      final cubit = buildCubit()
        ..next()
        ..next()
        ..next()
        ..next();
      expect(cubit.flow.state.current, CyocCreationStep.personality);
      expect(cubit.flow.state.progressIndex, 5);

      cubit.next();
      expect(cubit.flow.state.current, CyocCreationStep.yourChoice);
      expect(cubit.flow.state.hasProgress, isTrue);
      expect(cubit.flow.state.progressIndex, 5);

      await cubit.back();
      expect(cubit.flow.state.current, CyocCreationStep.personality);
      expect(cubit.flow.state.progressIndex, 5);

      await cubit.back();
      expect(cubit.flow.state.current, CyocCreationStep.hairEye);
      expect(cubit.flow.state.progressIndex, 4);
      await cubit.close();
    });

    test('back on the first step stays there', () async {
      final cubit = buildCubit();

      await cubit.back();

      expect(cubit.flow.state.current, CyocCreationStep.genderStyleAge);
      await cubit.close();
    });
  });

  group('gender change', () {
    test('keeps compatible choices and resets gender-dependent ones', () async {
      final cubit = buildCubit()
        ..updateEthnicity(CyocEthnicity.latina)
        ..updateBodyType(CyocBodyType.curvy)
        ..updateHairStyle(CyocHairStyle.ponytail)
        ..updateHairColor(CyocHairColor.red)
        ..updatePersonality(CyocPersonality.rebel)
        ..updateGender(CharacterGender.male);

      final male = cubit.state.choice;
      expect(male.gender, CharacterGender.male);
      expect(male.ethnicity, CyocEthnicity.latino);
      expect(male.bodyType, CyocBodyType.maleValues.first);
      expect(male.hairStyle, CyocHairStyle.maleValues.first);
      expect(male.facialHair, CyocFacialHair.values.first);
      expect(male.hairColor, CyocHairColor.red);
      expect(male.personality, CyocPersonality.rebel);

      cubit.updateGender(CharacterGender.female);

      expect(cubit.state.choice.ethnicity, CyocEthnicity.latina);
      expect(cubit.state.choice.facialHair, isNull);
      await cubit.close();
    });
  });

  group('generation', () {
    test('generate ends on photoPreview with the generated image', () async {
      final cubit = buildCubit()..updateGender(CharacterGender.male);

      await cubit.generate();

      expect(cubit.state.generation.status, CyocGenerationStatus.done);
      expect(
        cubit.state.result?.avatarUrl,
        'packages/cyoc/assets/options/pers_m_real_sweetheart.webp',
      );
      expect(cubit.flow.state.current, CyocCreationStep.photoPreview);
      await cubit.close();
    });

    test('regenerate replaces the result and returns to photoPreview', () async {
      final cubit = buildCubit();
      await cubit.generate();

      await cubit.regenerate();

      expect(cubit.state.generation.status, CyocGenerationStatus.done);
      expect(cubit.state.result?.avatarUrl, 'packages/cyoc/assets/options/pers_f_real_tease.webp');
      expect(cubit.flow.state.current, CyocCreationStep.photoPreview);
      await cubit.close();
    });

    test('back while generating cancels and returns to yourChoice', () async {
      final cubit = buildCubit(delay: const Duration(hours: 1));
      final generation = cubit.generate();
      expect(cubit.flow.state.current, CyocCreationStep.generation);

      await cubit.back();
      await generation;

      expect(cubit.flow.state.current, CyocCreationStep.yourChoice);
      expect(cubit.state.generation.isRunning, isFalse);
      expect(cubit.state.result, isNull);
      await cubit.close();
    });

    test('back from photoPreview drops the result and returns to yourChoice', () async {
      final cubit = buildCubit();
      await cubit.generate();

      await cubit.back();

      expect(cubit.state.result, isNull);
      expect(cubit.flow.state.current, CyocCreationStep.yourChoice);
      await cubit.close();
    });
  });

  group('createCharacter', () {
    test('saves a cyoc character with the generated avatar and opens cards', () async {
      final cubit = buildCubit();
      await cubit.generate();
      cubit
        ..continueFromResult()
        ..updateName('Ava')
        ..updateRelationship(CyocRelationshipType.dating);
      expect(cubit.flow.state.current, CyocCreationStep.nameRelationship);

      await cubit.createCharacter();

      final calls = verifyInOrder([
        () => characterRepository.createCharacterFromGeneration(captureAny()),
        () => navigator.goBack<Object?>(),
        () => adapter.openCards(),
      ]);
      final saved = calls.first.captured.single as CharacterModel;
      expect(saved.cyoc, isTrue);
      expect(saved.name, 'Ava');
      expect(saved.avatar, cubit.state.result?.avatar);
      expect(cubit.state.processing, isFalse);
      await cubit.close();
    });

    test('does nothing without a name', () async {
      final cubit = buildCubit();
      await cubit.generate();
      cubit.updateRelationship(CyocRelationshipType.friends);

      await cubit.createCharacter();

      verifyNever(() => characterRepository.createCharacterFromGeneration(any()));
      verifyNever(() => adapter.openCards());
      await cubit.close();
    });
  });

  test('suggestName fills the name from a gender-specific suggestion', () async {
    when(
      () => suggestionsRepository.getRandomSuggestion(SuggestionType.maleName),
    ).thenAnswer((_) async => 'Leo');
    final cubit = buildCubit()..updateGender(CharacterGender.male);

    await cubit.suggestName();

    expect(cubit.state.choice.name, 'Leo');
    await cubit.close();
  });

  test('a second exit request does nothing', () async {
    final cubit = buildCubit();

    await cubit.onExitRequested();
    await cubit.onExitRequested();

    verify(() => navigator.goBack<Object?>()).called(1);
    await cubit.close();
  });

  test('exit is ignored while the character is being saved', () async {
    final saving = Completer<CharacterModel>();
    when(
      () => characterRepository.createCharacterFromGeneration(any()),
    ).thenAnswer((_) => saving.future);
    final cubit = buildCubit();
    await cubit.generate();
    cubit
      ..continueFromResult()
      ..updateName('Ava')
      ..updateRelationship(CyocRelationshipType.dating);

    final creating = cubit.createCharacter();
    await cubit.onExitRequested();
    saving.complete(_FakeCharacterModel());
    await creating;

    verify(() => navigator.goBack<Object?>()).called(1);
    verify(() => adapter.openCards()).called(1);
    await cubit.close();
  });

  test('exit tracks abort and goes back', () async {
    final cubit = buildCubit();

    await cubit.onExitRequested();

    verify(() => navigator.goBack<Object?>()).called(1);
    await cubit.close();
  });
}
