import 'dart:async';

import 'package:character_data/character_data.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigation/navigation.dart';

import '../../cards_feature.dart';
import '../../cards_feature_adapter.dart';
import '../../model/event/card_events.dart';
import '../../model/event/feed_gate_events.dart';

part 'cards_feed_state.dart';

class CardsFeedCubit extends Cubit<CardsFeedState> {
  CardsFeedCubit(
    this._characterRepository,
    this._featureAdapter,
    this._appNavigator,
    this._analyticsService,
    this._logger,
  ) : super(CardsFeedState(initialLoading: true));

  static const _feedLimit = 10;
  static const _createCharacterPromoCardCount = 5;
  static const _loadMoreThreshold = 3;

  final CharacterRepository _characterRepository;
  final CardsFeatureAdapter _featureAdapter;
  final AppNavigator _appNavigator;
  final AnalyticsService _analyticsService;
  final Logger _logger;

  static const _promoImpressionKey = 'promo:create_character';

  StreamSubscription<List<CharacterModel>>? _charactersSubscription;
  int _loadGeneration = 0;
  bool _navigating = false;
  final Set<String> _impressions = {};

  Future<void> onOpened() async {
    if (_charactersSubscription != null) {
      return;
    }
    _charactersSubscription = _characterRepository.observeAllCharacters().listen(
      _onCharactersUpdated,
      onError: (Object e) => _logger.e('[CARDS_FEED] Character updates failed', error: e),
    );
    await _loadFirstPage();
  }

  Future<void> onRefresh() => _loadFirstPage();

  void onToastShown() {
    if (state.toastType == CardsFeedToastType.none) {
      return;
    }
    emit(state.copyWith(toastType: CardsFeedToastType.none, toastCharacterName: ''));
  }

  void onPageChanged(int pageIndex) {
    switch (state.feedItemAt(pageIndex)) {
      case CardsFeedCharacterItem(:final character, :final characterIndex):
        _onCardShown(character);
        _loadNextPageNearEnd(characterIndex);
      case CardsFeedCreateCharacterItem():
        _onCreateCharacterPromoShown();
      case CardsFeedLoadingItem():
      case null:
        break;
    }
  }

  Future<void> onCreateCharacterPromoTap() async {
    if (_navigating) {
      return;
    }
    _analyticsService.trackEvent(FeedCreateCharacterPromoTappedEvent());
    await _navigate(_featureAdapter.createCharacter, 'Create character promo failed to open');
  }

  Future<void> onLike(CharacterModel character) async {
    final currentCharacter = state.characterById(character.id) ?? character;
    if (state.isLikeProcessing(currentCharacter.id)) {
      return;
    }

    _setLikeProcessing(currentCharacter.id, processing: true);
    try {
      await _updateFeedLike(currentCharacter, liked: !state.isLiked(currentCharacter.id));
    } catch (e) {
      if (isClosed) {
        return;
      }
      _logger.e('[CARDS_FEED] Feed like toggle failed for ${currentCharacter.id}', error: e);
      emit(state.copyWith(toastType: CardsFeedToastType.likeError));
    } finally {
      _setLikeProcessing(currentCharacter.id, processing: false);
    }
  }

  Future<void> onCharacterTap(CharacterModel character) async {
    final currentCharacter = state.characterById(character.id) ?? character;
    if (_navigating || state.isLikeProcessing(currentCharacter.id)) {
      return;
    }
    await _navigate(
      () => CardsFeature.openDetails(_appNavigator, currentCharacter.id),
      'Card details failed for ${currentCharacter.id}',
    );
  }

  @override
  Future<void> close() async {
    await _charactersSubscription?.cancel();
    return super.close();
  }

  Future<void> _navigate(Future<void> Function() open, String failureMessage) async {
    _navigating = true;
    try {
      await open();
    } catch (e) {
      if (isClosed) {
        return;
      }
      _logger.e('[CARDS_FEED] $failureMessage', error: e);
      emit(state.copyWith(toastType: CardsFeedToastType.error));
    } finally {
      _navigating = false;
    }
  }

  void _onCreateCharacterPromoShown() {
    if (!_impressions.add(_promoImpressionKey)) {
      return;
    }
    _analyticsService.trackEvent(FeedCreateCharacterPromoShownEvent());
  }

  void _onCharactersUpdated(List<CharacterModel> dbCharacters) {
    final characters = state.characters;
    if (state.initialLoading || dbCharacters.isEmpty) {
      return;
    }

    final updatedById = {for (final character in dbCharacters) character.id: character};
    var changed = false;
    final updatedCharacters = <CharacterModel>[];
    for (final character in characters) {
      final updated = updatedById[character.id];
      if (updated != null && updated != character) {
        changed = true;
        updatedCharacters.add(updated);
      } else {
        updatedCharacters.add(character);
      }
    }

    final feedIds = characters.map((character) => character.id).toSet();
    final createdCharacters = dbCharacters
        .where((character) => character.cyoc && !feedIds.contains(character.id))
        .toList();
    if (createdCharacters.isNotEmpty) {
      final firstCharacter = createdCharacters.first;
      emit(
        state.copyWith(
          characters: [...createdCharacters, ...updatedCharacters],
          advanceToCharacterId: firstCharacter.id,
          advanceRequestId: state.advanceRequestId + 1,
          toastType: CardsFeedToastType.characterJoined,
          toastCharacterName: firstCharacter.name,
        ),
      );
      return;
    }
    if (!changed) {
      return;
    }

    emit(state.copyWith(characters: updatedCharacters));
  }

  Future<void> _loadFirstPage() async {
    _loadGeneration++;
    _impressions.clear();
    emit(CardsFeedState(initialLoading: true));
    await _loadPage(cursor: null);
  }

  Future<void> _loadNextPage() async {
    if (state.initialLoading || state.loadingNext || state.endReached) {
      return;
    }
    emit(state.copyWith(loadingNext: true, loadFailed: false, toastType: CardsFeedToastType.none));
    await _loadPage(cursor: state.nextCursor);
  }

  Future<void> _loadPage({required String? cursor}) async {
    final generation = _loadGeneration;
    final isFirstPage = cursor == null;
    try {
      final response = await _characterRepository.fetchCharacterFeed(
        limit: _feedLimit,
        cursor: cursor,
      );
      if (isClosed || generation != _loadGeneration) {
        return;
      }
      final previousCharacters = state.characters;
      final characters = isFirstPage || previousCharacters.isEmpty
          ? response.characters
          : [...previousCharacters, ..._newCharacters(previousCharacters, response.characters)];
      final endReached = response.nextCursor == null;

      emit(
        state.copyWith(
          characters: characters,
          nextCursor: response.nextCursor,
          initialLoading: false,
          loadingNext: false,
          endReached: endReached,
          loadFailed: false,
          createCharacterPromoAfterCharacterId: _resolveCreateCharacterPromoAfterCharacterId(
            characters,
            endReached: endReached,
          ),
        ),
      );
      if (characters.isNotEmpty && isFirstPage) {
        _onCardShown(characters.first);
      }
    } catch (e) {
      if (isClosed || generation != _loadGeneration) {
        return;
      }
      _logger.e('[CARDS_FEED] Feed load failed', error: e);
      emit(
        state.copyWith(
          initialLoading: false,
          loadingNext: false,
          loadFailed: state.characters.isEmpty,
          toastType: state.characters.isEmpty ? CardsFeedToastType.none : CardsFeedToastType.error,
        ),
      );
    }
  }

  void _loadNextPageNearEnd(int index) {
    if (state.characters.isEmpty) {
      return;
    }
    if (index >= state.characters.length - _loadMoreThreshold) {
      unawaited(_loadNextPage());
    }
  }

  List<CharacterModel> _newCharacters(
    List<CharacterModel> existingCharacters,
    List<CharacterModel> candidateCharacters,
  ) {
    final existingIds = existingCharacters.map((character) => character.id).toSet();
    return candidateCharacters.where((character) => existingIds.add(character.id)).toList();
  }

  Future<void> _updateFeedLike(CharacterModel currentCharacter, {required bool liked}) async {
    if (liked) {
      await _characterRepository.likeFeedCharacter(currentCharacter.id);
      if (isClosed) {
        return;
      }
      _analyticsService.trackEvent(CharacterLikedEvent(currentCharacter));
      final likedCharacter = currentCharacter.copyWith(hasFeedLike: true);
      _replaceCharacter(likedCharacter);
      unawaited(_featureAdapter.onCharacterLiked(likedCharacter));
      return;
    }

    await _characterRepository.unlikeFeedCharacter(currentCharacter.id);
    if (isClosed) {
      return;
    }
    _replaceCharacter(currentCharacter.copyWith(hasFeedLike: false));
  }

  void _replaceCharacter(CharacterModel character) {
    final characters = List<CharacterModel>.from(state.characters);
    final index = characters.indexWhere((item) => item.id == character.id);
    if (index == -1) {
      return;
    }
    characters[index] = character;
    emit(state.copyWith(characters: characters, toastType: CardsFeedToastType.none));
  }

  String? _resolveCreateCharacterPromoAfterCharacterId(
    List<CharacterModel> characters, {
    required bool endReached,
  }) {
    if (characters.isEmpty) {
      return null;
    }
    final currentAnchorId = state.createCharacterPromoAfterCharacterId;
    if (currentAnchorId != null) {
      return characters.any((character) => character.id == currentAnchorId)
          ? currentAnchorId
          : null;
    }
    if (characters.length >= _createCharacterPromoCardCount) {
      return characters[_createCharacterPromoCardCount - 1].id;
    }
    return endReached ? characters.last.id : null;
  }

  void _setLikeProcessing(String characterId, {required bool processing}) {
    if (isClosed) {
      return;
    }
    final likeProcessingIds = Set<String>.from(state.likeProcessingIds);
    if (processing) {
      likeProcessingIds.add(characterId);
    } else {
      likeProcessingIds.remove(characterId);
    }
    emit(state.copyWith(likeProcessingIds: likeProcessingIds));
  }

  void _onCardShown(CharacterModel character) {
    if (!_impressions.add('character:${character.id}')) {
      return;
    }
    _logger.d('[CARDS_FEED] Card shown ${character.id}');
    _analyticsService.trackEvent(CharacterShownEvent(character));
  }
}
