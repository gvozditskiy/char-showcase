import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';

class FeedLikeButton extends StatelessWidget {
  const FeedLikeButton({
    required this.liked,
    required this.processing,
    required this.onTap,
    this.semanticsIdentifier,
    this.dimension = 62,
    super.key,
  });

  final bool liked;
  final bool processing;
  final VoidCallback onTap;
  final String? semanticsIdentifier;
  final double dimension;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AutomationSemantics(
      identifier: semanticsIdentifier,
      button: true,
      enabled: !processing,
      selected: liked,
      child: ClickDetector(
        onClick: processing ? null : onTap,
        child: SizedBox.square(
          dimension: dimension,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: liked ? palette.iconOnSurfaceFixedWhite : palette.iconOnSurfaceFixedAccent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: processing
                  ? CharLoader(
                      dimension: 28,
                      color: liked
                          ? palette.iconOnSurfaceFixedAccent
                          : palette.iconOnSurfaceFixedWhite,
                    )
                  : Icon(
                      Icons.favorite_rounded,
                      size: 31,
                      color: liked
                          ? palette.iconOnSurfaceFixedAccent
                          : palette.iconOnSurfaceFixedWhite,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
