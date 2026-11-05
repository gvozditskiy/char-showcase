import 'package:flutter/material.dart';

import '../styles.dart';

class CharLinearProgressBar extends StatelessWidget {
  const CharLinearProgressBar({
    required this.progress,
    this.durationMs = 300,
    this.lineWidth = 6,
    this.progressColor,
    this.backgroundColor,
    super.key,
  }) : assert(progress >= 0.0 && progress <= 1.0, 'Progress must be between 0 and 1.0');

  final double progress;
  final int durationMs;
  final double lineWidth;
  final Color? progressColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return LayoutBuilder(
      builder: (context, constraints) => SizedBox(
        height: lineWidth,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: context.appStyle.radii.smAll,
            color: backgroundColor ?? palette.surfaceLightAccent,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: AnimatedContainer(
              duration: Duration(milliseconds: durationMs),
              curve: Curves.easeOut,
              width: progress.isNaN ? 0 : constraints.maxWidth * progress,
              decoration: BoxDecoration(
                borderRadius: context.appStyle.radii.smAll,
                color: progressColor ?? palette.surfaceFixedAccent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
