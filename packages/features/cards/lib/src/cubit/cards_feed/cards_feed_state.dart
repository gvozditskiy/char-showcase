part of 'cards_feed_cubit.dart';

enum CardsFeedToastType { none, error, likeError, characterJoined }

sealed class CardsFeedItem {
  const CardsFeedItem();
}

class CardsFeedCharacterItem extends CardsFeedItem {
  const CardsFeedCharacterItem({required this.character, required this.characterIndex});

  final CharacterModel character;
  final int characterIndex;
}

class CardsFeedCreateCharacterItem extends CardsFeedItem {
  const CardsFeedCreateCharacterItem();
}

class CardsFeedLoadingItem extends CardsFeedItem {
  const CardsFeedLoadingItem();
}

class CardsFeedState extends Equatable {
  CardsFeedState({
    this.characters = const [],
    this.nextCursor,
    this.likeProcessingIds = const {},
    this.advanceToCharacterId,
    this.advanceRequestId = 0,
    this.initialLoading = false,
    this.loadingNext = false,
    this.endReached = false,
    this.loadFailed = false,
    this.createCharacterPromoAfterCharacterId,
    this.toastType = CardsFeedToastType.none,
    this.toastCharacterName = '',
  });

  static const _unset = Object();

  final List<CharacterModel> characters;
  final String? nextCursor;
  final Set<String> likeProcessingIds;
  final String? advanceToCharacterId;
  final int advanceRequestId;
  final bool initialLoading;
  final bool loadingNext;
  final bool endReached;
  final bool loadFailed;
  final String? createCharacterPromoAfterCharacterId;
  final CardsFeedToastType toastType;
  final String toastCharacterName;

  late final List<CardsFeedItem> feedItems = _buildFeedItems();

  CardsFeedItem? feedItemAt(int pageIndex) {
    return pageIndex >= 0 && pageIndex < feedItems.length ? feedItems[pageIndex] : null;
  }

  int? feedPageIndexForCharacterId(String characterId) {
    final index = feedItems.indexWhere(
      (item) => item is CardsFeedCharacterItem && item.character.id == characterId,
    );
    return index >= 0 ? index : null;
  }

  bool isLikeProcessing(String characterId) => likeProcessingIds.contains(characterId);

  bool isLiked(String characterId) {
    final character = characterById(characterId);
    return character != null && character.hasFeedLike;
  }

  CharacterModel? characterById(String characterId) {
    for (final character in characters) {
      if (character.id == characterId) {
        return character;
      }
    }
    return null;
  }

  CardsFeedState copyWith({
    List<CharacterModel>? characters,
    Object? nextCursor = _unset,
    Set<String>? likeProcessingIds,
    Object? advanceToCharacterId = _unset,
    int? advanceRequestId,
    bool? initialLoading,
    bool? loadingNext,
    bool? endReached,
    bool? loadFailed,
    Object? createCharacterPromoAfterCharacterId = _unset,
    CardsFeedToastType? toastType,
    String? toastCharacterName,
  }) {
    return CardsFeedState(
      characters: characters ?? this.characters,
      nextCursor: identical(nextCursor, _unset) ? this.nextCursor : nextCursor as String?,
      likeProcessingIds: likeProcessingIds ?? this.likeProcessingIds,
      advanceToCharacterId: identical(advanceToCharacterId, _unset)
          ? this.advanceToCharacterId
          : advanceToCharacterId as String?,
      advanceRequestId: advanceRequestId ?? this.advanceRequestId,
      initialLoading: initialLoading ?? this.initialLoading,
      loadingNext: loadingNext ?? this.loadingNext,
      endReached: endReached ?? this.endReached,
      loadFailed: loadFailed ?? this.loadFailed,
      createCharacterPromoAfterCharacterId: identical(createCharacterPromoAfterCharacterId, _unset)
          ? this.createCharacterPromoAfterCharacterId
          : createCharacterPromoAfterCharacterId as String?,
      toastType: toastType ?? this.toastType,
      toastCharacterName: toastCharacterName ?? this.toastCharacterName,
    );
  }

  @override
  List<Object?> get props => [
    characters,
    nextCursor,
    likeProcessingIds,
    advanceToCharacterId,
    advanceRequestId,
    initialLoading,
    loadingNext,
    endReached,
    loadFailed,
    createCharacterPromoAfterCharacterId,
    toastType,
    toastCharacterName,
  ];

  List<CardsFeedItem> _buildFeedItems() {
    final items = <CardsFeedItem>[];
    for (var characterIndex = 0; characterIndex < characters.length; characterIndex++) {
      final character = characters[characterIndex];
      items.add(CardsFeedCharacterItem(character: character, characterIndex: characterIndex));
      if (createCharacterPromoAfterCharacterId == character.id) {
        items.add(const CardsFeedCreateCharacterItem());
      }
    }
    if (loadingNext) {
      items.add(const CardsFeedLoadingItem());
    }
    return items;
  }
}
