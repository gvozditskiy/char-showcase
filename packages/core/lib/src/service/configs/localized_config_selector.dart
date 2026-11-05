import '../../locale/locale_defaults.dart';
import '../locale/locale_settings_provider.dart';

class LocalizedConfigSelector {
  LocalizedConfigSelector(this._localeSettingsProvider);

  final LocaleSettingsProvider _localeSettingsProvider;

  T? select<T>(dynamic value) {
    if (value is Map<String, dynamic>) {
      final resolvedTag = _localeSettingsProvider.resolvedLocaleTag;
      final languageCode = _localeSettingsProvider.resolvedLanguageCode;

      final byResolvedTag = _selectByKey<T>(value, resolvedTag);
      if (byResolvedTag != null) {
        return byResolvedTag;
      }

      final byLanguage = _selectByKey<T>(value, languageCode);
      if (byLanguage != null) {
        return byLanguage;
      }

      final byEnglish = _selectByKey<T>(value, LocaleDefaults.fallbackLanguageCode);
      if (byEnglish != null) {
        return byEnglish;
      }
    }

    return value as T?;
  }

  Map<String, dynamic>? selectMap(dynamic value) {
    final selected = select<dynamic>(value);
    return selected is Map<String, dynamic> ? selected : null;
  }

  List<T>? selectList<T>(dynamic value) {
    final selected = select<dynamic>(value);
    return selected is List ? selected.cast<T>() : null;
  }

  T? _selectByKey<T>(Map<String, dynamic> map, String key) {
    if (key.isEmpty) {
      return null;
    }
    final value = map[key];
    return value as T?;
  }
}
