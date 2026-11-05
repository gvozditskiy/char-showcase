import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';

class CyocSectionHeader extends StatelessWidget {
  const CyocSectionHeader({
    required this.title,
    this.info,
    this.trailing,
    this.verticalPadding = compactVerticalPadding,
    super.key,
  });

  final String title;
  final Widget? info;
  final Widget? trailing;
  final double verticalPadding;

  static const double compactVerticalPadding = 7;
  static const double carouselVerticalPadding = 8;
  static const double trailingVerticalPadding = 10;
  static const double infoGap = 5;

  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;
    final action = trailing;
    final infoAction = info;
    Widget text = Text(
      title,
      style: style.text.h8.copyWith(color: style.palette.textOnSurfacePrimary),
    );
    if (infoAction != null) {
      text = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: text),
          const SizedBox(width: infoGap),
          infoAction,
        ],
      );
    }
    final vertical = action == null ? verticalPadding : trailingVerticalPadding;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: style.spacing.space5, vertical: vertical),
      child: action == null
          ? text
          : Row(
              children: [
                Expanded(child: text),
                action,
              ],
            ),
    );
  }
}
