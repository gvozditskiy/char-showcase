import 'package:flutter/foundation.dart';

import '../model/app_theme_mode.dart';

class ThemeController extends ValueNotifier<AppThemeMode> {
  ThemeController._() : super(AppThemeMode.system);
  static final ThemeController instance = ThemeController._();

  AppThemeMode get themeMode => value;

  void setThemeMode(AppThemeMode themeMode) {
    if (value != themeMode) {
      value = themeMode;
    }
  }
}
