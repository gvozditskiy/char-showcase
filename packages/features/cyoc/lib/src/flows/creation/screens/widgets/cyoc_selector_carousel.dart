import 'package:flutter/material.dart';

import 'cyoc_paged_selector.dart';
import 'cyoc_selector_card.dart';

class CyocSelectorCarousel<T> extends StatelessWidget {
  const CyocSelectorCarousel({
    required this.title,
    required this.options,
    required this.selected,
    required this.onChanged,
    required this.titleOf,
    required this.imageUrlOf,
    required this.semanticsPrefix,
    required this.idOf,
    required this.isCompact,
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

  final bool isCompact;

  static const fullCardWidth = 210.0;
  static const fullCardHeight = 390.0;
  static const compactCardWidth = 178.0;
  static const compactCardHeight = 326.0;

  @override
  Widget build(BuildContext context) {
    final cardWidth = isCompact ? compactCardWidth : fullCardWidth;
    final cardHeight = isCompact ? compactCardHeight : fullCardHeight;
    return CyocPagedSelector<T>(
      title: title,
      options: options,
      selected: selected,
      onChanged: onChanged,
      tileWidth: cardWidth,
      tileHeight: cardHeight,
      grows: true,
      itemSpacing: itemSpacing,
      titleGap: titleGap,
      tileBuilder: (context, option, {required selected, required scale, required onTap}) =>
          CyocSelectorCard<T>(
            value: option,
            selected: selected,
            onChanged: (_) => onTap(),
            title: titleOf(option),
            imageUrl: imageUrlOf(option),
            semanticsIdentifier: '${semanticsPrefix}_${idOf(option)}',
            width: cardWidth * scale,
            height: cardHeight * scale,
          ),
    );
  }
}
