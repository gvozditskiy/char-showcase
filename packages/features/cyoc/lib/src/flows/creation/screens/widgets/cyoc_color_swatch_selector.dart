import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';

import 'cyoc_paged_selector.dart';

class CyocColorSwatchSelector<T> extends StatelessWidget {
  const CyocColorSwatchSelector({
    required this.title,
    required this.options,
    required this.selected,
    required this.onChanged,
    required this.titleOf,
    required this.imageUrlOf,
    required this.semanticsPrefix,
    required this.idOf,
    this.itemSpacing,
    this.titleGap,
    super.key,
  });

  final String title;
  final List<T> options;
  final T? selected;
  final ValueChanged<T> onChanged;
  final String Function(T value) titleOf;
  final String Function(T value) imageUrlOf;
  final String semanticsPrefix;
  final String Function(T value) idOf;
  final double? itemSpacing;
  final double? titleGap;

  static const double tileHeight = 128;

  @override
  Widget build(BuildContext context) {
    return CyocPagedSelector<T>(
      title: title,
      options: options,
      selected: selected,
      onChanged: onChanged,
      tileWidth: CyocColorSwatchTile.size,
      tileHeight: tileHeight,
      grows: false,
      itemSpacing: itemSpacing,
      titleGap: titleGap,
      tileBuilder: (context, option, {required selected, required scale, required onTap}) =>
          CyocColorSwatchTile<T>(
            value: option,
            selected: selected,
            onChanged: (_) => onTap(),
            title: titleOf(option),
            imageUrl: imageUrlOf(option),
            semanticsIdentifier: '${semanticsPrefix}_${idOf(option)}',
          ),
    );
  }
}

class CyocColorSwatchTile<T> extends StatelessWidget {
  const CyocColorSwatchTile({
    required this.value,
    required this.selected,
    required this.onChanged,
    required this.title,
    required this.imageUrl,
    this.semanticsIdentifier,
    super.key,
  });

  final T value;
  final bool selected;
  final ValueChanged<T> onChanged;
  final String title;
  final String imageUrl;
  final String? semanticsIdentifier;

  static const double size = 100;
  static const double checkMarkSize = 20;
  static const double checkMarkTickSize = 10;
  static const double checkMarkInset = 12;

  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;
    final palette = context.palette;
    return AutomationSemantics(
      identifier: semanticsIdentifier,
      button: true,
      selected: selected,
      enabled: true,
      child: ClickDetector(
        onClick: () => onChanged(value),
        child: Column(
          children: [
            SizedBox(
              width: size,
              height: size,
              child: ClipRRect(
                borderRadius: style.radii.mdAll,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const SizedBox.expand(),
                      ),
                    ),
                    if (selected)
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: style.radii.mdAll,
                            border: Border.all(color: palette.outlineFixedAccent),
                          ),
                        ),
                      ),
                    Positioned(
                      top: checkMarkInset,
                      right: checkMarkInset,
                      child: CheckMark(
                        selected: selected,
                        overImg: true,
                        size: checkMarkSize,
                        tickSize: checkMarkTickSize,
                        unselectedBorderColor: palette.outlineFixedMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: style.spacing.space2),
            SizedBox(
              width: size,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: style.text.subtitle3.copyWith(color: palette.textOnSurfacePrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
