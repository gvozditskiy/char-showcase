import 'package:flutter/material.dart';

import '../../styles.dart';
import '../automation_semantics.dart';
import '../click_detector.dart';

class ToggleSwitch extends StatelessWidget {
  const ToggleSwitch({
    required this.value,
    required this.onChanged,
    super.key,
    this.semanticsIdentifier,
  });
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? semanticsIdentifier;

  static const _thumbSize = 20.0;
  static const _thumbPadding = 5.0;
  static const _trackWidth = 54.0;
  static const _trackHeight = 30.0;
  static const _defaultDuration = Duration(milliseconds: 250);

  @override
  Widget build(BuildContext context) {
    final curves = context.appStyle.curves;
    final palette = context.palette;
    final trackColor = value ? palette.surfaceFixedAccent : palette.surfaceLight;
    final thumbPosition = value ? _trackWidth - _thumbSize - _thumbPadding : _thumbPadding;
    return AutomationSemantics(
      identifier: semanticsIdentifier,
      button: true,
      selected: value,
      enabled: true,
      child: ClickDetector(
        onClick: () => onChanged(!value),
        child: Stack(
          children: [
            AnimatedContainer(
              width: _trackWidth,
              height: _trackHeight,
              duration: _defaultDuration,
              curve: curves.slowInSlowOutCurve,
              decoration: BoxDecoration(
                color: trackColor,
                borderRadius: const BorderRadius.all(Radius.circular(_trackHeight / 2)),
              ),
            ),
            AnimatedPositionedDirectional(
              top: _thumbPadding,
              start: thumbPosition,
              duration: _defaultDuration,
              curve: curves.slowInSlowOutCurve,
              child: SizedBox(
                width: _thumbSize,
                height: _thumbSize,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: palette.surfaceFixedWhite,
                    borderRadius: const BorderRadius.all(Radius.circular(_thumbSize / 2)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
