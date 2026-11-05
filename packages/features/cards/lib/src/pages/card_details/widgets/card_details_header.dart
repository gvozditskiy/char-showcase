part of '../card_details_page.dart';

class _CardDetailsHeader extends StatelessWidget {
  const _CardDetailsHeader({
    required this.character,
    required this.height,
    required this.pageController,
    required this.processing,
    required this.onLike,
  });

  final CharacterModel character;
  final double height;
  final PageController pageController;
  final bool processing;
  final VoidCallback onLike;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final images = character.images.where((image) => image.isNotEmpty).toList();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _CardMediaCarousel(images: images, pageController: pageController),
              IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        palette.surfaceTranslucentFixedBlack.withAlphaPercent(0),
                        palette.surfaceTranslucentFixedBlack.withAlphaPercent(55),
                      ],
                      stops: const [0.6, 1],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 24,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (images.length > 1)
                      Center(
                        child: ListenableBuilder(
                          listenable: pageController,
                          builder: (context, _) {
                            final page = pageController.hasClients
                                ? (pageController.page ?? 0).round()
                                : 0;
                            return CharDotsIndicator(
                              total: images.length,
                              activeIndex: page.clamp(0, images.length - 1),
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        CharacterFeedAvatar(character: character),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            character.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.appStyle.text.h5.copyWith(
                              color: palette.textOnSurfaceFixedWhite,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        FeedLikeButton(
                          liked: character.hasFeedLike,
                          processing: processing,
                          onTap: onLike,
                          semanticsIdentifier: 'card_details_like_button',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CardMediaCarousel extends StatelessWidget {
  const _CardMediaCarousel({required this.images, required this.pageController});

  final List<String> images;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return const CharBackground();
    }
    return PageView.builder(
      controller: pageController,
      itemCount: images.length,
      itemBuilder: (context, index) =>
          Image.asset(images[index], fit: BoxFit.cover, alignment: Alignment.topCenter),
    );
  }
}
