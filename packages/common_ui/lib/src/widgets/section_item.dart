import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../styles.dart';

class SectionItem extends StatelessWidget {
  const SectionItem(this.title, this.section, {super.key});

  final String title;
  final Widget section;

  @override
  Widget build(BuildContext context) {
    final appStyle = AppStyle.of(context);
    final palette = context.palette;
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: appStyle.text.h8.copyWith(color: palette.textOnSurfacePrimary)),
              const SizedBox(height: 10),
              section,
            ],
          ),
        ),
      ],
    );
  }
}
