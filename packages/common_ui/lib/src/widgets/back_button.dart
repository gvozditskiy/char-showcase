import 'dart:ui';

import 'package:flutter/material.dart';

import '../extensions/color_extensions.dart';
import '../styles.dart';
import 'automation_semantics.dart';

class CharBackButton extends StatelessWidget {
  const CharBackButton({
    required this.onBackClick,
    super.key,
    this.fixedWhite = false,
    this.withShadow = false,
    this.withBackground = false,
    this.semanticsIdentifier,
  });

  final VoidCallback onBackClick;
  final bool fixedWhite;
  final bool withShadow;
  final bool withBackground;
  final String? semanticsIdentifier;

  static const double _iconSize = 24;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AutomationSemantics(
      identifier: semanticsIdentifier,
      button: true,
      enabled: true,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onBackClick,
        child: SizedBox(
          width: 34,
          height: 34,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: withBackground
                  ? palette.surfaceTranslucentFixedGrey
                  : palette.surfaceTranslucentFixedGrey.withAlphaPercent(0),
            ),
            child: Center(
              child: Stack(
                children: [
                  if (withShadow)
                    ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3, tileMode: TileMode.decal),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: _iconSize,
                        color: palette.iconOnSurfaceFixedBlack.withAlphaPercent(25),
                      ),
                    ),
                  Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: _iconSize,
                    color: fixedWhite
                        ? palette.iconOnSurfaceFixedWhite
                        : palette.iconOnSurfacePrimary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
