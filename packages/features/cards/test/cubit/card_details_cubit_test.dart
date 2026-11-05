import 'package:cards/src/cards_feature_adapter.dart';
import 'package:cards/src/cubit/card_details/card_details_cubit.dart';
import 'package:character_data/character_data.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:navigation/navigation.dart';

class _MockLogger extends Mock implements Logger {}

class _MockAppNavigator extends Mock implements AppNavigator {}

class _MockCardsFeatureAdapter extends Mock implements CardsFeatureAdapter {}

class _MockAnalyticsService extends Mock implements AnalyticsService {}

class _MockCharacterRepository extends Mock implements CharacterRepository {}

class _FakeAnalyticsEvent extends Fake implements AnalyticsEvent {}

void main() {
  late _MockCardsFeatureAdapter featureAdapter;
  late _MockCharacterRepository characterRepository;
  late _MockAnalyticsService analyticsService;
  late CardDetailsCubit cubit;

  const character = CharacterModel(
    id: 'character-1',
    name: 'Anna',
    fullName: 'Anna',
    age: 25,
    gender: [CharacterGender.female],
    cyoc: false,
    photos: [],
    publicBio: 'Bio',
  );

  setUpAll(() {
    registerFallbackValue(_FakeAnalyticsEvent());
    registerFallbackValue(character);
  });

  setUp(() {
    featureAdapter = _MockCardsFeatureAdapter();
    characterRepository = _MockCharacterRepository();
    analyticsService = _MockAnalyticsService();
    when(() => analyticsService.trackEvent(any())).thenReturn(null);
    when(() => featureAdapter.onCharacterLiked(any())).thenAnswer((_) async {});
    cubit = CardDetailsCubit(
      _MockLogger(),
      _MockAppNavigator(),
      featureAdapter,
      analyticsService,
      characterRepository,
    );
  });

  tearDown(() => cubit.close());

  group('CardDetailsCubit', () {
    test('loads the character by id', () async {
      when(() => characterRepository.getCharacter(character.id)).thenAnswer((_) async => character);

      await cubit.onOpened(character.id);

      expect(cubit.state.character, character);
      expect(cubit.state.loadingInfo, isFalse);
    });

    test('stays empty when the character is not found', () async {
      when(() => characterRepository.getCharacter('missing')).thenAnswer((_) async => null);

      await cubit.onOpened('missing');

      expect(cubit.state.character, isNull);
      expect(cubit.state.loadingInfo, isFalse);
    });

    test('like marks the character liked and notifies the adapter', () async {
      when(() => characterRepository.getCharacter(character.id)).thenAnswer((_) async => character);
      when(() => characterRepository.likeFeedCharacter(character.id)).thenAnswer((_) async {});
      await cubit.onOpened(character.id);

      await cubit.onLike();

      expect(cubit.state.character?.hasFeedLike, isTrue);
      verify(() => featureAdapter.onCharacterLiked(any())).called(1);
    });

    test('like failure keeps like error toast until it is shown', () async {
      when(() => characterRepository.getCharacter(character.id)).thenAnswer((_) async => character);
      when(
        () => characterRepository.likeFeedCharacter(character.id),
      ).thenThrow(Exception('failed'));
      await cubit.onOpened(character.id);

      await cubit.onLike();

      expect(cubit.state.toastType, CardDetailsToastType.likeError);
      expect(cubit.state.processing, isFalse);
      expect(cubit.state.character?.hasFeedLike, isFalse);

      cubit.onToastShown();

      expect(cubit.state.toastType, CardDetailsToastType.none);
    });

    test('unlike failure emits like error toast', () async {
      final liked = character.copyWith(hasFeedLike: true);
      when(() => characterRepository.getCharacter(character.id)).thenAnswer((_) async => liked);
      when(
        () => characterRepository.unlikeFeedCharacter(character.id),
      ).thenThrow(Exception('failed'));
      await cubit.onOpened(character.id);

      await cubit.onUnlike();

      expect(cubit.state.toastType, CardDetailsToastType.likeError);
      expect(cubit.state.character?.hasFeedLike, isTrue);
    });
  });
}
