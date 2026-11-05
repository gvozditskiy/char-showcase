import 'package:flutter/material.dart';

import '../styles.dart';
import 'automation_semantics.dart';
import 'click_detector.dart';

class CharCloseButton extends StatelessWidget {
  const CharCloseButton({
    super.key,
    this.onTap,
    this.color,
    this.withBackground = false,
    this.semanticsIdentifier,
  });

  final VoidCallback? onTap;
  final Color? color;
  final bool withBackground;
  final String? semanticsIdentifier;

  static const double _buttonSize = 34;
  static const double _iconSize = 24;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    Widget child = Center(
      child: Icon(
        Icons.close_rounded,
        size: _iconSize,
        color: color ?? palette.iconOnSurfacePrimary,
      ),
    );

    if (withBackground) {
      child = DecoratedBox(
        decoration: BoxDecoration(shape: BoxShape.circle, color: palette.buttonTranslucentBlack30),
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: palette.buttonTranslucentWhite30,
          ),
          child: child,
        ),
      );
    }

    return AutomationSemantics(
      identifier: semanticsIdentifier,
      button: true,
      enabled: onTap != null,
      child: SizedBox.fromSize(
        size: const Size.square(_buttonSize),
        child: ClickDetector(onClick: onTap, child: child),
      ),
    );
  }
}
