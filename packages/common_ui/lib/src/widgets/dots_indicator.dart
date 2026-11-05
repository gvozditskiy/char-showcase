import 'package:flutter/material.dart';

import '../curves.dart';
import '../styles.dart';

class CharDotsIndicator extends StatelessWidget {
  const CharDotsIndicator({
    required this.total,
    required this.activeIndex,
    this.maxVisible,
    this.activeColor,
    this.inactiveColor,
    super.key,
  });

  final int total;
  final int activeIndex;
  final int? maxVisible;
  final Color? activeColor;
  final Color? inactiveColor;

  static const _activeSize = 12.0;
  static const _inactiveSize = 8.0;
  static const _spacing = 12.0;

  @override
  Widget build(BuildContext context) {
    if (total <= 1) {
      return const SizedBox.shrink();
    }
    final palette = context.palette;
    final visible = maxVisible == null ? total : (maxVisible! < total ? maxVisible! : total);
    final maxStart = total - visible;
    var start = activeIndex - visible ~/ 2;
    if (start < 0) {
      start = 0;
    }
    if (start > maxStart) {
      start = maxStart;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(visible, (offset) {
        final index = start + offset;
        final active = index == activeIndex;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: _spacing / 2),
          child: SizedBox(
            height: _activeSize,
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: AppCurves.easeOut,
                width: active ? _activeSize : _inactiveSize,
                height: active ? _activeSize : _inactiveSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: active
                      ? (activeColor ?? palette.iconOnSurfaceFixedWhite)
                      : (inactiveColor ?? palette.iconOnSurfaceFixedLightGrey),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
