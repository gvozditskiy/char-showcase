import 'dart:async';

import 'package:cards/src/cards_feature_adapter.dart';
import 'package:cards/src/cubit/cards_feed/cards_feed_cubit.dart';
import 'package:cards/src/model/event/feed_gate_events.dart';
import 'package:cards/src/route/cards_paths.dart';
import 'package:character_data/character_data.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:navigation/navigation.dart';

class _MockCharacterRepository extends Mock implements CharacterRepository {}

class _MockCardsFeatureAdapter extends Mock implements CardsFeatureAdapter {}

class _MockAppNavigator extends Mock implements AppNavigator {}

class _MockAnalyticsService extends Mock implements AnalyticsService {}

class _MockLogger extends Mock implements Logger {}

class _FakeAnalyticsEvent extends Fake implements AnalyticsEvent {}

void main() {
  late _MockCharacterRepository characterRepository;
  late _MockCardsFeatureAdapter featureAdapter;
  late _MockAppNavigator appNavigator;
  late _MockAnalyticsService analyticsService;
  late _MockLogger logger;
  late StreamController<List<CharacterModel>> allCharactersController;
  late CardsFeedCubit cubit;

  setUpAll(() {
    registerFallbackValue(_FakeAnalyticsEvent());
    registerFallbackValue(_character('fallback'));
  });

  setUp(() {
    characterRepository = _MockCharacterRepository();
    featureAdapter = _MockCardsFeatureAdapter();
    appNavigator = _MockAppNavigator();
    analyticsService = _MockAnalyticsService();
    logger = _MockLogger();
    allCharactersController = StreamController<List<CharacterModel>>.broadcast();

    when(
      () => characterRepository.observeAllCharacters(),
    ).thenAnswer((_) => allCharactersController.stream);
    when(() => analyticsService.trackEvent(any())).thenReturn(null);
    when(() => featureAdapter.onCharacterLiked(any())).thenAnswer((_) async {});

    cubit = CardsFeedCubit(
      characterRepository,
      featureAdapter,
      appNavigator,
      analyticsService,
      logger,
    );
  });

  tearDown(() async {
    await cubit.close();
    await allCharactersController.close();
  });

  group('CardsFeedCubit', () {
    test('starts with loader while initial feed setup is pending', () {
      expect(cubit.state.characters, isEmpty);
      expect(cubit.state.initialLoading, isTrue);
    });

    test('loads initial feed batch', () async {
      final character = _character('character-1');
      _stubFeedResponses(characterRepository, [
        CharacterFeedModel(characters: [character], nextCursor: null),
      ]);

      await cubit.onOpened();

      expect(cubit.state.characters, [character]);
      expect(cubit.state.initialLoading, isFalse);
      expect(cubit.state.endReached, isTrue);
      verify(() => characterRepository.fetchCharacterFeed(limit: 10)).called(1);
    });

    test('shows the empty-feed error state when the first load fails', () async {
      when(
        () => characterRepository.fetchCharacterFeed(limit: 10, cursor: any(named: 'cursor')),
      ).thenThrow(Exception('failed'));

      await cubit.onOpened();

      expect(cubit.state.characters, isEmpty);
      expect(cubit.state.initialLoading, isFalse);
      expect(cubit.state.loadFailed, isTrue);
    });

    test('syncs loaded cards with character state updates', () async {
      final character = _character('character-1');
      final updatedCharacter = _character('character-1', hasFeedLike: true);
      _stubFeedResponses(characterRepository, [
        CharacterFeedModel(characters: [character], nextCursor: null),
      ]);

      await cubit.onOpened();
      allCharactersController.add([updatedCharacter]);
      await pumpEventQueue();

      expect(cubit.state.characters, [updatedCharacter]);
      expect(cubit.state.isLiked(character.id), isTrue);
    });

    test('shows a character created from an empty feed', () async {
      final created = _character('created', cyoc: true);
      _stubFeedResponses(characterRepository, [
        const CharacterFeedModel(characters: [], nextCursor: null),
      ]);
      await cubit.onOpened();

      allCharactersController.add([created]);
      await pumpEventQueue();

      expect(cubit.state.characters, [created]);
      expect(cubit.state.toastType, CardsFeedToastType.characterJoined);
    });

    test('puts a character created in CYOC first in the feed', () async {
      final character = _character('character-1');
      final created = _character('created', cyoc: true);
      _stubFeedResponses(characterRepository, [
        CharacterFeedModel(characters: [character], nextCursor: null),
      ]);
      await cubit.onOpened();
      final advanceRequestId = cubit.state.advanceRequestId;

      allCharactersController.add([created, character]);
      await pumpEventQueue();

      expect(cubit.state.characters, [created, character]);
      expect(cubit.state.advanceToCharacterId, created.id);
      expect(cubit.state.advanceRequestId, advanceRequestId + 1);
      expect(cubit.state.toastType, CardsFeedToastType.characterJoined);
      expect(cubit.state.toastCharacterName, created.name);

      cubit.onToastShown();

      expect(cubit.state.toastType, CardsFeedToastType.none);
      expect(cubit.state.toastCharacterName, isEmpty);
    });

    test('loads next page near the end', () async {
      final firstCharacter = _character('character-1');
      final secondCharacter = _character('character-2');
      _stubFeedResponses(characterRepository, [
        CharacterFeedModel(characters: [firstCharacter], nextCursor: 'cursor-1'),
        CharacterFeedModel(characters: [secondCharacter], nextCursor: null),
      ]);
      await cubit.onOpened();

      cubit.onPageChanged(0);
      await pumpEventQueue();

      expect(cubit.state.characters, [firstCharacter, secondCharacter]);
      expect(cubit.state.endReached, isTrue);
      verify(() => characterRepository.fetchCharacterFeed(limit: 10, cursor: 'cursor-1')).called(1);
    });

    test('inserts create character promo without replacing character cards', () {
      final characters = List.generate(3, (index) => _character('character-$index'));
      final state = CardsFeedState(
        characters: characters,
        createCharacterPromoAfterCharacterId: characters[1].id,
      );

      expect(state.feedItems.length, 4);
      expect(state.feedItems[2], isA<CardsFeedCreateCharacterItem>());
      expect((state.feedItems[3] as CardsFeedCharacterItem).characterIndex, 2);
    });

    test('shows create character promo after five cards', () async {
      final characters = List.generate(8, (index) => _character('character-$index'));
      _stubFeedResponses(characterRepository, [
        CharacterFeedModel(characters: characters, nextCursor: null),
      ]);

      await cubit.onOpened();

      expect(cubit.state.createCharacterPromoAfterCharacterId, characters[4].id);
      expect(cubit.state.feedItems[5], isA<CardsFeedCreateCharacterItem>());
    });

    test('opens character creation from the feed promo card', () async {
      when(() => featureAdapter.createCharacter()).thenAnswer((_) async {});

      await cubit.onCreateCharacterPromoTap();

      verify(() => featureAdapter.createCharacter()).called(1);
      verify(
        () => analyticsService.trackEvent(any(that: isA<FeedCreateCharacterPromoTappedEvent>())),
      ).called(1);
    });

    test('like marks the card liked and notifies the adapter once', () async {
      final character = _character('character-1');
      _stubFeedResponses(characterRepository, [
        CharacterFeedModel(characters: [character], nextCursor: null),
      ]);
      when(() => characterRepository.likeFeedCharacter(character.id)).thenAnswer((_) async {});
      await cubit.onOpened();

      await cubit.onLike(character);

      expect(cubit.state.characterById(character.id)?.hasFeedLike, isTrue);
      verify(() => characterRepository.likeFeedCharacter(character.id)).called(1);
      final liked =
          verify(() => featureAdapter.onCharacterLiked(captureAny())).captured.single
              as CharacterModel;
      expect(liked.id, character.id);
      expect(liked.hasFeedLike, isTrue);
    });

    test('unlike does not notify the adapter', () async {
      final character = _character('character-1', hasFeedLike: true);
      _stubFeedResponses(characterRepository, [
        CharacterFeedModel(characters: [character], nextCursor: null),
      ]);
      when(() => characterRepository.unlikeFeedCharacter(character.id)).thenAnswer((_) async {});
      await cubit.onOpened();

      await cubit.onLike(character);

      expect(cubit.state.isLiked(character.id), isFalse);
      verify(() => characterRepository.unlikeFeedCharacter(character.id)).called(1);
      verifyNever(() => characterRepository.likeFeedCharacter(any()));
      verifyNever(() => featureAdapter.onCharacterLiked(any()));
    });

    test('guards duplicate like actions', () async {
      final character = _character('character-1');
      final likeCompleter = Completer<void>();
      _stubFeedResponses(characterRepository, [
        CharacterFeedModel(characters: [character], nextCursor: null),
      ]);
      when(
        () => characterRepository.likeFeedCharacter(character.id),
      ).thenAnswer((_) => likeCompleter.future);
      await cubit.onOpened();

      final firstLike = cubit.onLike(character);
      await pumpEventQueue();
      await cubit.onLike(character);
      likeCompleter.complete();
      await firstLike;

      verify(() => characterRepository.likeFeedCharacter(character.id)).called(1);
    });

    test('emits like error toast when like fails', () async {
      final character = _character('character-1');
      _stubFeedResponses(characterRepository, [
        CharacterFeedModel(characters: [character], nextCursor: null),
      ]);
      when(
        () => characterRepository.likeFeedCharacter(character.id),
      ).thenThrow(Exception('failed'));
      await cubit.onOpened();

      await cubit.onLike(character);

      expect(cubit.state.toastType, CardsFeedToastType.likeError);
      expect(cubit.state.isLikeProcessing(character.id), isFalse);
      verifyNever(() => featureAdapter.onCharacterLiked(any()));
    });

    test('opens card details by character id', () async {
      final character = _character('character-1');
      _stubFeedResponses(characterRepository, [
        CharacterFeedModel(characters: [character], nextCursor: null),
      ]);
      when(
        () => appNavigator.pushForResult<void>(
          CardsPath.cardDetails,
          queryParams: any(named: 'queryParams'),
        ),
      ).thenAnswer((_) async {});
      await cubit.onOpened();

      await cubit.onCharacterTap(character);

      final queryParams =
          verify(
                () => appNavigator.pushForResult<void>(
                  CardsPath.cardDetails,
                  queryParams: captureAny(named: 'queryParams'),
                ),
              ).captured.single
              as Map<String, dynamic>;
      expect(queryParams[CardsPath.characterIdParam], character.id);
    });
  });
}

CharacterModel _character(String id, {bool hasFeedLike = false, bool cyoc = false}) =>
    CharacterModel(
      id: id,
      name: 'Anna',
      fullName: 'Anna',
      age: 25,
      gender: const [CharacterGender.female],
      cyoc: cyoc,
      photos: const ['packages/character_data/assets/characters/photo.webp'],
      publicBio: 'Early bird and yoga enthusiast.',
      hasFeedLike: hasFeedLike,
    );

void _stubFeedResponses(
  _MockCharacterRepository characterRepository,
  List<CharacterFeedModel> responses,
) {
  var index = 0;
  when(
    () => characterRepository.fetchCharacterFeed(limit: 10, cursor: any(named: 'cursor')),
  ).thenAnswer((_) async => responses[index++]);
}
