import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';

import '../../../../../l10n/l10n.dart';
import '../../../../widgets/cyoc_fake_progress_bar.dart';

class CyocLoadingProgressFooter extends StatelessWidget {
  const CyocLoadingProgressFooter({
    required this.titleColor,
    required this.subtitleColor,
    this.progressColor,
    this.progressBackgroundColor,
    this.titleBoxHeight,
    super.key,
  });

  final Color titleColor;
  final Color subtitleColor;
  final Color? progressColor;
  final Color? progressBackgroundColor;
  final double? titleBoxHeight;

  static const _averageGenerationTime = Duration(seconds: 45);

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    final style = context.appStyle;
    final title = Text(
      strings.cyocCreationGeneratingTitle,
      style: style.text.h6.copyWith(color: titleColor),
      textAlign: TextAlign.center,
    );
    final boxHeight = titleBoxHeight;

    return Column(
      children: [
        if (boxHeight == null)
          title
        else
          SizedBox(
            height: boxHeight,
            child: Center(child: title),
          ),
        SizedBox(height: style.spacing.space3),
        CyocFakeProgressBar(
          averageGenerationTime: _averageGenerationTime,
          finished: false,
          progressColor: progressColor,
          backgroundColor: progressBackgroundColor,
        ),
        SizedBox(height: style.spacing.space3),
        Text(
          strings.cyocCreationGeneratingSubtitle,
          style: style.text.p2.copyWith(color: subtitleColor),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
