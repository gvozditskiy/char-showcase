import 'package:core/core.dart';

import '../controller/theme_controller.dart';
import '../model/app_theme_mode.dart';

class AppThemeSettingsProvider {
  AppThemeSettingsProvider(this._preferences);

  static const _themeModeKey = 'app_settings_theme_mode';

  final SharedPreferencesProvider _preferences;

  void init() {
    final themeMode = getThemeMode();
    ThemeController.instance.setThemeMode(themeMode);
  }

  AppThemeMode getThemeMode() {
    final themeModeKey = _preferences.getString(_themeModeKey);
    return AppThemeMode.safeValueOf(themeModeKey);
  }

  Future<void> setThemeMode(AppThemeMode themeMode) async {
    await _preferences.setString(_themeModeKey, themeMode.name);
    ThemeController.instance.setThemeMode(themeMode);
  }
}
