import 'dart:math';

import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';

import '../../../../../l10n/l10n.dart';

class CyocSelectorCard<T> extends StatelessWidget {
  const CyocSelectorCard({
    required this.value,
    required this.selected,
    required this.onChanged,
    required this.title,
    required this.imageUrl,
    this.semanticsIdentifier,
    this.width = defaultWidth,
    this.height = defaultHeight,
    this.borderRadius,
    this.titleBottomPadding = titleInset,
    this.titleHorizontalPadding = titleInset,
    super.key,
  });

  final T value;
  final bool selected;
  final ValueChanged<T> onChanged;
  final String title;
  final String imageUrl;
  final String? semanticsIdentifier;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final double titleBottomPadding;
  final double titleHorizontalPadding;

  static const defaultWidth = 160.0;
  static const defaultHeight = 260.0;
  static const aspectRatio = defaultWidth / defaultHeight;
  static const titleInset = 17.0;
  static const checkMarkTickSize = 16.0;
  static const gradientStops = [0.0, 0.635, 1.0];
  static const glowCenter = Alignment(0.0125, -0.0846);
  static const glowRadius = 0.93125;

  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;
    final palette = context.palette;
    final radius = borderRadius ?? style.radii.xlAll;
    return AutomationSemantics(
      identifier: semanticsIdentifier,
      button: true,
      selected: selected,
      enabled: true,
      child: ClickDetector(
        onClick: () => onChanged(value),
        child: SizedBox(
          width: width,
          height: height,
          child: CyocCardSurface(
            borderRadius: radius,
            glowCenter: glowCenter,
            glowRadius: glowRadius,
            title: title,
            titleStyle: style.text.subtitle2.copyWith(color: palette.textOnSurfaceFixedWhite),
            titlePadding: EdgeInsets.fromLTRB(
              titleHorizontalPadding,
              0,
              titleHorizontalPadding,
              titleBottomPadding,
            ),
            artwork: CyocCardArtwork(imageUrl: imageUrl),
            selected: selected,
            showSelectedBorder: true,
            checkMark: CheckMark(
              selected: selected,
              overImg: true,
              tickSize: checkMarkTickSize,
              unselectedBorderColor: palette.outlineFixedMedium,
            ),
          ),
        ),
      ),
    );
  }
}

class CyocChoiceCard extends StatelessWidget {
  const CyocChoiceCard({
    required this.title,
    this.imageUrl = '',
    this.image,
    this.semanticsIdentifier,
    super.key,
  });

  final String title;
  final String imageUrl;
  final Widget? image;
  final String? semanticsIdentifier;

  static const width = 106.0;
  static const height = 173.0;
  static const glowCenter = Alignment(0, 0.0058);
  static const glowRadius = 1.1226;
  static const titlePadding = EdgeInsets.fromLTRB(12, 0, 12, 12);

  static const aspectRatio = width / height;

  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;
    final palette = context.palette;
    return AutomationSemantics(
      identifier: semanticsIdentifier,
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: CyocCardSurface(
          borderRadius: style.radii.lgAll,
          glowCenter: glowCenter,
          glowRadius: glowRadius,
          title: title,
          titleStyle: style.text.subtitle4.copyWith(color: palette.textOnSurfaceFixedWhite),
          titlePadding: titlePadding,
          artwork: image ?? CyocCardArtwork(imageUrl: imageUrl),
        ),
      ),
    );
  }
}

class CyocCardSurface extends StatelessWidget {
  const CyocCardSurface({
    required this.borderRadius,
    required this.glowCenter,
    required this.glowRadius,
    required this.title,
    required this.titleStyle,
    required this.titlePadding,
    required this.artwork,
    this.selected = false,
    this.showSelectedBorder = false,
    this.checkMark,
    super.key,
  });

  final BorderRadius borderRadius;
  final Alignment glowCenter;
  final double glowRadius;
  final String title;
  final TextStyle titleStyle;
  final EdgeInsets titlePadding;
  final Widget artwork;
  final bool selected;
  final bool showSelectedBorder;
  final Widget? checkMark;

  static const _titleMaxLines = 2;
  static const _checkMarkInset = 10.0;
  static const _fadeAlphaPercent = 70;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final mark = checkMark;
    return DecoratedBox(
      decoration: BoxDecoration(color: palette.surfaceFixedBlackBg, borderRadius: borderRadius),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          gradient: RadialGradient(
            center: glowCenter,
            radius: glowRadius,
            colors: [palette.surfaceFixedAccent, palette.surfaceFixedAccent.withAlphaPercent(0)],
          ),
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  position: DecorationPosition.foreground,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: CyocSelectorCard.gradientStops,
                      colors: [
                        palette.surfaceFixedBlackBg.withAlphaPercent(0),
                        palette.surfaceFixedBlackBg.withAlphaPercent(0),
                        palette.surfaceFixedBlackBg.withAlphaPercent(_fadeAlphaPercent),
                      ],
                    ),
                  ),
                  child: artwork,
                ),
              ),
              if (showSelectedBorder && selected)
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: borderRadius,
                      border: Border.all(color: palette.outlineFixedAccent),
                    ),
                  ),
                ),
              Positioned(
                bottom: titlePadding.bottom,
                left: titlePadding.left,
                right: titlePadding.right,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: titleStyle,
                  maxLines: _titleMaxLines,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (mark != null)
                Positioned(top: _checkMarkInset, right: _checkMarkInset, child: mark),
            ],
          ),
        ),
      ),
    );
  }
}

class CyocCardArtwork extends StatelessWidget {
  const CyocCardArtwork({required this.imageUrl, super.key});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return const SizedBox.expand();
    }
    return Image.asset(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => const SizedBox.expand(),
    );
  }
}

class CyocAgeCardArt extends StatelessWidget {
  const CyocAgeCardArt({super.key});

  static const arrowSize = Size(35.82, 28.72);
  static const upArrowOffset = Offset(46.71, 28.54);
  static const downArrowOffset = Offset(23.89, 92.29);
  static const labelTop = 59.0;

  @override
  Widget build(BuildContext context) {
    final color = context.palette.iconOnSurfaceFixedBlack;
    final arrow = Icon(Icons.north_east_rounded, size: arrowSize.height, color: color);
    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: CyocChoiceCard.width,
        height: CyocChoiceCard.height,
        child: Stack(
          children: [
            Positioned(left: upArrowOffset.dx, top: upArrowOffset.dy, child: arrow),
            Positioned(
              left: downArrowOffset.dx,
              top: downArrowOffset.dy,
              child: Transform.rotate(angle: pi, child: arrow),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: labelTop,
              child: Text(
                context.l10n.cyocCreationAgeArtLabel,
                textAlign: TextAlign.center,
                style: context.appStyle.text.h5.copyWith(color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
