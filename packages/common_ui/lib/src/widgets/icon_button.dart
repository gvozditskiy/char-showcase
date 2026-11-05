import 'package:flutter/widgets.dart';

import '../extensions/color_extensions.dart';
import '../styles.dart';
import 'automation_semantics.dart';
import 'click_detector.dart';

enum CharIconButtonSize { small, medium, large }

class CharIconButton extends StatelessWidget {
  const CharIconButton({
    required this.icon,
    super.key,
    this.size = CharIconButtonSize.small,
    this.side,
    this.iconSide,
    this.iconPadding,
    this.hasCircularBackground = false,
    this.hasShadow,
    this.gradient,
    this.onTap,
    this.color,
    this.colorFilter,
    this.infinityWidth = false,
    this.semanticsIdentifier,
  });

  final IconData icon;
  final CharIconButtonSize size;
  final double? side;
  final double? iconSide;
  final EdgeInsets? iconPadding;
  final bool hasCircularBackground;
  final bool? hasShadow;
  final VoidCallback? onTap;
  final LinearGradient? gradient;
  final Color? color;
  final Color? colorFilter;
  final bool infinityWidth;
  final String? semanticsIdentifier;

  static const double _smallIconSize = 24;
  static const double _iconSize = 30;
  static const Size _smallButtonSize = Size(34, 34);
  static const Size _mediumButtonSize = Size(54, 54);
  static const Size _largeButtonSize = Size(64, 64);

  bool get showShadow => hasShadow ?? hasCircularBackground;

  @override
  Widget build(BuildContext context) {
    final Size buttonSize;
    if (side != null) {
      buttonSize = Size(side!, side!);
    } else {
      switch (size) {
        case CharIconButtonSize.small:
          buttonSize = _smallButtonSize;
        case CharIconButtonSize.medium:
          buttonSize = _mediumButtonSize;
        case CharIconButtonSize.large:
          buttonSize = _largeButtonSize;
      }
    }
    final palette = context.palette;
    return AutomationSemantics(
      identifier: semanticsIdentifier,
      button: true,
      enabled: onTap != null,
      child: ClickDetector(
        onClick: onTap,
        child: SizedBox(
          width: infinityWidth ? null : buttonSize.width,
          height: buttonSize.height,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: hasCircularBackground ? color ?? palette.surfaceFixedWhite : null,
              boxShadow: showShadow
                  ? [
                      BoxShadow(
                        color: palette.surfaceTranslucentFixedBlack.withAlphaPercent(10),
                        blurRadius: 50,
                      ),
                    ]
                  : null,
              gradient: gradient,
              borderRadius: BorderRadius.circular(buttonSize.width / 2),
            ),
            child: Padding(
              padding: iconPadding ?? EdgeInsets.zero,
              child: Center(
                child: Icon(
                  icon,
                  key: ValueKey(icon),
                  size: iconSide ?? _iconSizeFor,
                  color: colorFilter ?? palette.iconOnSurfacePrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double get _iconSizeFor => switch (size) {
    CharIconButtonSize.small => _smallIconSize,
    CharIconButtonSize.medium => _iconSize,
    CharIconButtonSize.large => _iconSize,
  };
}
