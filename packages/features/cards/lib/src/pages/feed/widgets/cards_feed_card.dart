part of '../cards_feed_page.dart';

class _FeedCharacterCard extends StatelessWidget {
  const _FeedCharacterCard({
    required this.character,
    required this.likeProcessing,
    required this.liked,
    required this.onTap,
    required this.onLike,
  });

  static const radius = 40.0;

  final CharacterModel character;
  final bool likeProcessing;
  final bool liked;
  final VoidCallback onTap;
  final VoidCallback onLike;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final text = context.appStyle.text;
    final strings = cards_l10n.AppLocalizations.of(context);
    final imagePath = _mediaPosterPath(character);
    final tags = [
      if (liked) _FeedTag(title: strings.cardsFeedLikeSentBadge, type: _FeedTagType.liked),
      ...character.tags
          .where((tag) => tag.isNotEmpty)
          .take(3)
          .map((tag) => _FeedTag(title: tag, type: _FeedTagType.interest)),
    ];

    return AutomationSemantics(
      identifier: AutomationId.join(['cards_feed_card', character.id]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: ColoredBox(
          color: palette.surfaceFixedBlackBg,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (imagePath != null)
                Image.asset(imagePath, fit: BoxFit.cover, alignment: Alignment.topCenter),
              const Positioned(top: 0, left: 0, right: 0, child: _FeedCardTopGradient()),
              Positioned.fill(child: _FeedProfileGestureLayer(onTap: onTap)),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _FeedCardBottomGradient(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (tags.isNotEmpty) ...[
                        _ProfileTapTarget(
                          onTap: onTap,
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: tags
                                .map(
                                  (tag) => _FeedBadge(
                                    title: tag.title,
                                    accent: tag.type == _FeedTagType.liked,
                                  ),
                                )
                                .toList(growable: false),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                      Row(
                        children: [
                          Expanded(
                            child: _ProfileTapTarget(
                              onTap: onTap,
                              child: Row(
                                children: [
                                  CharacterFeedAvatar(character: character),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      character.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: text.h5.copyWith(
                                        color: palette.textOnSurfaceFixedWhite,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          FeedLikeButton(
                            liked: liked,
                            processing: likeProcessing,
                            onTap: onLike,
                            semanticsIdentifier: 'cards_feed_like_button',
                          ),
                        ],
                      ),
                      if (character.publicBio.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        _ProfileTapTarget(
                          onTap: onTap,
                          child: Text(
                            character.publicBio,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: text.p2.copyWith(color: palette.textOnSurfaceFixedWhite),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeedCardTopGradient extends StatelessWidget {
  const _FeedCardTopGradient();

  static const _fadeHeight = 48.0;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return SizedBox(
      height: _FeedTopOverlay.bottomEdgeOf(context) + _fadeHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              palette.surfaceTranslucentFixedBlack.withAlphaPercent(70),
              palette.surfaceTranslucentFixedBlack.withAlphaPercent(50),
              palette.surfaceTranslucentFixedBlack.withAlphaPercent(0),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeedCardBottomGradient extends StatelessWidget {
  const _FeedCardBottomGradient({required this.child});

  static const _fadeHeight = 56.0;
  static const _contentPadding = EdgeInsets.only(left: 20, right: 20, top: _fadeHeight, bottom: 32);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            palette.surfaceTranslucentFixedBlack.withAlphaPercent(0),
            palette.surfaceTranslucentFixedBlack.withAlphaPercent(50),
            palette.surfaceTranslucentFixedBlack.withAlphaPercent(70),
          ],
        ),
      ),
      child: Padding(
        padding: _contentPadding + EdgeInsets.only(bottom: CharPadding.of(context).bottom),
        child: child,
      ),
    );
  }
}

class _ProfileTapTarget extends StatelessWidget {
  const _ProfileTapTarget({required this.onTap, required this.child});

  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClickDetector(onClick: onTap, child: child);
  }
}

class _FeedProfileGestureLayer extends StatelessWidget {
  const _FeedProfileGestureLayer({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: const SizedBox.expand(),
    );
  }
}

class _FeedBadge extends StatelessWidget {
  const _FeedBadge({required this.title, this.accent = false});

  final String title;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: accent
            ? palette.iconOnSurfaceFixedAccent
            : palette.surfaceTranslucentFixedBlack.withAlphaPercent(30),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          title,
          style: context.appStyle.text.caption1.copyWith(
            color: palette.textOnSurfaceFixedWhite,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _FeedTag {
  const _FeedTag({required this.title, required this.type});

  final String title;
  final _FeedTagType type;
}

enum _FeedTagType { liked, interest }

String? _mediaPosterPath(CharacterModel character) {
  final mainImage = character.mainImage;
  if (mainImage != null && mainImage.isNotEmpty) {
    return mainImage;
  }
  return character.photos.firstOrNull;
}
