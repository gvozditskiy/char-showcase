import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../styles.dart';
import 'automation_semantics.dart';
import 'click_detector.dart';
import 'loader.dart';

enum ThemedButtonSize {
  xxl(height: 84, contentPadding: 20, iconSize: 24, iconPadding: 10),
  xl(height: 64, contentPadding: 20, iconSize: 24, iconPadding: 10),
  l(height: 64, contentPadding: 20, iconSize: 24, iconPadding: 10),
  m(height: 54, contentPadding: 15, iconSize: 24, iconPadding: 10),
  s(height: 44, contentPadding: 12, iconSize: 16, iconPadding: 8),
  xs(height: 34, contentPadding: 12, iconSize: 16, iconPadding: 3);

  const ThemedButtonSize({
    required this.height,
    required this.contentPadding,
    required this.iconSize,
    required this.iconPadding,
  });

  final double height;
  final double contentPadding;
  final double iconSize;
  final double iconPadding;
}

class ThemedButtonIcon {
  const ThemedButtonIcon({required this.icon, this.applyThemeColor = true, this.tintColor});

  final IconData icon;
  final bool applyThemeColor;
  final Color? tintColor;
}

class ThemedButtonTheme {
  const ThemedButtonTheme({
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.gradient,
    this.borderRadius,
  });

  factory ThemedButtonTheme.primary(BuildContext context, {bool enabled = true}) {
    final palette = context.palette;
    return ThemedButtonTheme(
      backgroundColor: enabled ? palette.buttonPrimaryDefault : palette.buttonDisabledLight,
      textColor: enabled ? palette.textOnSurfaceWhite : palette.textOnSurfaceDisabled,
    );
  }

  factory ThemedButtonTheme.secondary(BuildContext context, {bool enabled = true}) {
    final palette = context.palette;
    return ThemedButtonTheme(
      backgroundColor: enabled ? palette.buttonFixedSecAccentDefault : palette.buttonDisabledLight,
      textColor: enabled ? palette.textOnSurfaceFixedWhite : palette.textOnSurfaceDisabled,
    );
  }

  factory ThemedButtonTheme.gold(BuildContext context, {bool enabled = true}) {
    final palette = context.palette;
    return ThemedButtonTheme(
      backgroundColor: enabled ? palette.buttonFixedPremiumDefault : palette.buttonDisabledLight,
      textColor: enabled ? palette.textOnSurfaceDarkPremium : palette.textOnSurfaceDisabled,
    );
  }

  factory ThemedButtonTheme.gray(BuildContext context, {bool enabled = true}) {
    final palette = context.palette;
    return ThemedButtonTheme(
      backgroundColor: enabled ? palette.buttonSecondaryDefault : palette.buttonDisabledLight,
      textColor: enabled ? palette.textOnSurfacePrimary : palette.textOnSurfaceDisabled,
    );
  }

  factory ThemedButtonTheme.white(BuildContext context, {bool enabled = true}) {
    final palette = context.palette;
    return ThemedButtonTheme(
      backgroundColor: enabled ? palette.surfaceWhite : palette.buttonDisabledLight,
      textColor: enabled ? palette.textOnSurfacePrimary : palette.textOnSurfaceDisabled,
      borderColor: enabled ? palette.outlineDefault : null,
    );
  }

  factory ThemedButtonTheme.fixedWhite(BuildContext context, {bool enabled = true}) {
    final palette = context.palette;
    return ThemedButtonTheme(
      backgroundColor: enabled ? palette.buttonFixedWhiteDefault : palette.buttonDisabledLight,
      textColor: enabled ? palette.textOnSurfaceFixedPrimary : palette.textOnSurfaceDisabledLight,
    );
  }

  factory ThemedButtonTheme.black(BuildContext context, {bool enabled = true}) {
    final palette = context.palette;
    return ThemedButtonTheme(
      backgroundColor: enabled ? palette.buttonPrimaryDefault : palette.buttonDisabledLight,
      textColor: enabled ? palette.textOnSurfaceWhite : palette.textOnSurfaceDisabled,
    );
  }

  factory ThemedButtonTheme.fixedBlack(BuildContext context, {bool enabled = true}) {
    final palette = context.palette;
    return ThemedButtonTheme(
      backgroundColor: enabled ? palette.buttonFixedPrimaryDefault : palette.buttonDisabledLight,
      textColor: enabled ? palette.textOnSurfaceFixedWhite : palette.textOnSurfaceDisabledLight,
    );
  }

  factory ThemedButtonTheme.orange(BuildContext context, {bool enabled = true}) {
    final palette = context.palette;
    return ThemedButtonTheme(
      backgroundColor: enabled ? palette.buttonFixedAccentDefault : palette.buttonDisabledLight,
      textColor: enabled ? palette.textOnSurfaceFixedWhite : palette.textOnSurfaceDisabledLight,
    );
  }

  factory ThemedButtonTheme.outline(BuildContext context, {bool enabled = true}) {
    final palette = context.palette;
    return ThemedButtonTheme(
      backgroundColor: Colors.transparent,
      textColor: enabled ? palette.textOnSurfacePrimary : palette.textOnSurfaceDisabled,
      borderColor: palette.outlineFixedMedium,
    );
  }

  factory ThemedButtonTheme.custom({
    required Color backgroundColor,
    required Color textColor,
    Color? borderColor,
    double borderWidth = 1.0,
    Gradient? gradient,
  }) {
    return ThemedButtonTheme(
      backgroundColor: backgroundColor,
      textColor: textColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      gradient: gradient,
    );
  }

  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final double borderWidth;
  final Gradient? gradient;
  final double? borderRadius;

  ThemedButtonTheme copyWith({
    Color? backgroundColor,
    Color? textColor,
    Color? borderColor,
    double? borderWidth,
    Gradient? gradient,
    double? borderRadius,
  }) => ThemedButtonTheme(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    textColor: textColor ?? this.textColor,
    borderColor: borderColor ?? this.borderColor,
    borderWidth: borderWidth ?? this.borderWidth,
    gradient: gradient ?? this.gradient,
    borderRadius: borderRadius ?? this.borderRadius,
  );
}

class ThemedButton extends StatelessWidget implements PreferredSizeWidget {
  const ThemedButton({
    this.text,
    this.child,
    super.key,
    this.theme,
    this.size = ThemedButtonSize.l,
    this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.preserveSizeOnLoading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.withShimmer = false,
    this.shrink = false,
    this.alignment = Alignment.center,
    this.padding,
    this.textStyle,
    this.semanticsIdentifier,
    this.maxLines = 1,
  }) : assert(text != null || child != null, 'Either text or child must be provided');

  final String? text;
  final Widget? child;
  final ThemedButtonTheme? theme;
  final ThemedButtonSize size;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final bool preserveSizeOnLoading;
  final ThemedButtonIcon? leadingIcon;
  final ThemedButtonIcon? trailingIcon;
  final bool withShimmer;
  final bool shrink;
  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final String? semanticsIdentifier;
  final int maxLines;

  bool get isEnabled => enabled && !isLoading && onPressed != null;

  @override
  Size get preferredSize => Size.fromHeight(size.height);

  @override
  Widget build(BuildContext context) {
    final appStyle = context.appStyle;

    final buttonTheme = theme ?? ThemedButtonTheme.gray(context, enabled: enabled);

    final baseTextStyle =
        textStyle ??
        ([ThemedButtonSize.s, ThemedButtonSize.xs].contains(size)
            ? appStyle.text.subtitle2
            : appStyle.text.h7);
    final resolvedTextStyle = baseTextStyle.copyWith(
      color: buttonTheme.textColor,
      leadingDistribution: TextLeadingDistribution.even,
    );

    Widget content;
    if (isLoading) {
      content = SizedBox(
        key: const ValueKey('loading'),
        width: size.height,
        height: size.height,
        child: Center(
          child: SizedBox(width: 32, height: 32, child: CharLoader(color: buttonTheme.textColor)),
        ),
      );
    } else if (child != null) {
      content = child!;
    } else if (leadingIcon == null && trailingIcon == null) {
      content = Text(
        text!,
        key: const ValueKey('text'),
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: resolvedTextStyle,
      );
    } else {
      content = Row(
        key: const ValueKey('row'),
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leadingIcon != null) ...[
            _buildIcon(leadingIcon!, buttonTheme),
            SizedBox(width: size.iconPadding),
          ],
          if (trailingIcon != null)
            Expanded(
              child: Text(
                text!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: resolvedTextStyle,
              ),
            ),
          if (trailingIcon == null)
            Text(text!, maxLines: 1, overflow: TextOverflow.ellipsis, style: resolvedTextStyle),
          if (trailingIcon != null) ...[
            SizedBox(width: size.iconPadding),
            _buildIcon(trailingIcon!, buttonTheme),
          ],
        ],
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final fullWidth = shrink || !constraints.hasBoundedWidth ? null : constraints.maxWidth;
        final collapse = isLoading && !preserveSizeOnLoading;
        final decoration = BoxDecoration(
          color: buttonTheme.gradient == null ? buttonTheme.backgroundColor : null,
          gradient: buttonTheme.gradient,
          border: buttonTheme.borderColor != null
              ? Border.all(color: buttonTheme.borderColor!, width: buttonTheme.borderWidth)
              : null,
          borderRadius: buttonTheme.borderRadius != null
              ? BorderRadius.circular(buttonTheme.borderRadius!)
              : appStyle.radii.pillAll,
        );
        final restingPadding = padding ?? EdgeInsets.symmetric(horizontal: size.contentPadding);
        final resolvedPadding = collapse ? null : restingPadding;
        final Widget coreButton;
        if (fullWidth != null) {
          final contentMaxWidth = (fullWidth - restingPadding.horizontal).clamp(
            0.0,
            double.infinity,
          );
          coreButton = AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            clipBehavior: Clip.antiAlias,
            width: collapse ? size.height : fullWidth,
            height: size.height,
            decoration: decoration,
            padding: resolvedPadding,
            child: OverflowBox(
              minWidth: 0,
              maxWidth: contentMaxWidth,
              minHeight: 0,
              maxHeight: size.height,
              alignment: alignment,
              child: content,
            ),
          );
        } else {
          coreButton = AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: SizedBox(
              width: collapse ? size.height : null,
              height: size.height,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                clipBehavior: Clip.antiAlias,
                alignment: alignment,
                decoration: decoration,
                padding: resolvedPadding,
                child: content,
              ),
            ),
          );
        }

        final shimmering = withShimmer && !isLoading
            ? Animate(
                onComplete: (controller) => controller.repeat(),
                effects: const [
                  ShimmerEffect(
                    size: .2,
                    color: Colors.white10,
                    delay: Duration(seconds: 2),
                    duration: Duration(milliseconds: 800),
                  ),
                ],
                child: coreButton,
              )
            : coreButton;

        return AutomationSemantics(
          identifier: semanticsIdentifier,
          button: true,
          enabled: isEnabled,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: ClickDetector(onClick: isEnabled ? onPressed : null, child: shimmering),
          ),
        );
      },
    );
  }

  Widget _buildIcon(ThemedButtonIcon icon, ThemedButtonTheme buttonTheme) {
    final iconTintColor = icon.tintColor ?? (icon.applyThemeColor ? buttonTheme.textColor : null);
    return Icon(icon.icon, size: size.iconSize, color: iconTintColor);
  }
}
