import 'package:flutter/widgets.dart';

class AppRadii {
  const AppRadii({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.pill,
  });

  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double pill;

  BorderRadius get smAll => BorderRadius.circular(sm);
  BorderRadius get mdAll => BorderRadius.circular(md);
  BorderRadius get lgAll => BorderRadius.circular(lg);
  BorderRadius get xlAll => BorderRadius.circular(xl);
  BorderRadius get pillAll => BorderRadius.circular(pill);

  static const AppRadii char = AppRadii(xs: 8, sm: 12, md: 16, lg: 20, xl: 28, pill: 999);
}
