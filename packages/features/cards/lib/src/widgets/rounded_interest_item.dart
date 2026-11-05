import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';

class RoundedInterestItem extends StatelessWidget {
  const RoundedInterestItem({required this.title, super.key, this.backgroundColor, this.textColor});

  final String title;
  final Color? backgroundColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: backgroundColor ?? palette.tagLightGrey,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Text(
          title,
          style: context.appStyle.text.subtitle3.copyWith(
            color: textColor ?? palette.textOnSurfacePrimary,
          ),
        ),
      ),
    );
  }
}
