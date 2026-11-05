import 'package:flutter/material.dart';

enum AppThemeMode {
  system(ThemeMode.system),
  light(ThemeMode.light),
  dark(ThemeMode.dark);

  const AppThemeMode(this.materialThemeMode);

  final ThemeMode materialThemeMode;

  static AppThemeMode safeValueOf(String? value) {
    return AppThemeMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => AppThemeMode.system,
    );
  }
}
