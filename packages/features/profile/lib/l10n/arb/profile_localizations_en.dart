// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'profile_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get profileRate => 'Rate app';

  @override
  String get profileSettingsAppearance => 'Appearance';

  @override
  String get profileSettingsAppMode => 'App mode';

  @override
  String get profileSettingsAppearanceDescription =>
      'Turn on dark mode, or let the app visually match your device settings.';

  @override
  String get profileSettingsThemeSystem => 'System';

  @override
  String get profileSettingsThemeLight => 'Light';

  @override
  String get profileSettingsThemeDark => 'Dark';
}
