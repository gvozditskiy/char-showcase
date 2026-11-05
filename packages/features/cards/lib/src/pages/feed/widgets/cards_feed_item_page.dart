part of '../cards_feed_page.dart';

class _FeedItemPage extends StatelessWidget {
  const _FeedItemPage({required this.cubit, required this.state, required this.item, super.key});

  final CardsFeedCubit cubit;
  final CardsFeedState state;
  final CardsFeedItem item;

  @override
  Widget build(BuildContext context) {
    return switch (item) {
      CardsFeedLoadingItem() => const _FeedLoadingView(),
      CardsFeedCreateCharacterItem() => _FeedCreateCharacterCard(
        onTap: cubit.onCreateCharacterPromoTap,
      ),
      CardsFeedCharacterItem(:final character) => _FeedCharacterCard(
        character: character,
        likeProcessing: state.isLikeProcessing(character.id),
        liked: character.hasFeedLike,
        onTap: () => cubit.onCharacterTap(character),
        onLike: () => cubit.onLike(character),
      ),
    };
  }
}
