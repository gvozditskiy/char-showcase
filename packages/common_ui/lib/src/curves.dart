import 'package:flutter/animation.dart';

class AppCurves {
  static const fastInSlowOut = Cubic(0.30, 0.90, 0.50, 1);
  static const slowInSlowOut = Cubic(0.70, 0, 0.50, 1);
  static const easeOut = Cubic(0, 0, 0.58, 1);

  Cubic get slowInSlowOutCurve => slowInSlowOut;
}
