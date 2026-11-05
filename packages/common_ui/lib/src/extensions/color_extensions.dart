import 'package:flutter/widgets.dart';

extension CharColorExtensions on Color {
  Color withAlphaPercent(int alpha) {
    if (alpha == 0) {
      return withAlpha(0);
    }
    return withAlpha((255 * alpha.toDouble() / 100.0).round().clamp(0, 255));
  }
}
