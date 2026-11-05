import 'package:flutter/widgets.dart';

import '../../locale/locale_defaults.dart';

abstract final class LocaleResolver {
  static Locale resolve({
    required List<Locale> preferredLocales,
    required List<Locale> supportedLocales,
  }) {
    final resolvedSupported = supportedLocales.isNotEmpty
        ? supportedLocales
        : LocaleDefaults.fallbackLocales;

    for (final preferred in preferredLocales) {
      final exact = _findExact(preferred, resolvedSupported);
      if (exact != null) {
        return exact;
      }
      final language = _findLanguage(preferred.languageCode, resolvedSupported);
      if (language != null) {
        return language;
      }
    }

    final english = _findLanguage(LocaleDefaults.fallbackLanguageCode, resolvedSupported);
    return english ?? resolvedSupported.first;
  }

  static Locale? _findExact(Locale preferred, List<Locale> supportedLocales) {
    for (final locale in supportedLocales) {
      if (_equalsLocale(locale, preferred)) {
        return locale;
      }
    }
    return null;
  }

  static Locale? _findLanguage(String languageCode, List<Locale> supportedLocales) {
    final normalizedLanguageCode = languageCode.toLowerCase();
    for (final locale in supportedLocales) {
      if (locale.languageCode.toLowerCase() == normalizedLanguageCode) {
        return locale;
      }
    }
    return null;
  }

  static bool _equalsLocale(Locale first, Locale second) {
    final firstLanguage = first.languageCode.toLowerCase();
    final secondLanguage = second.languageCode.toLowerCase();
    final firstCountry = (first.countryCode ?? '').toUpperCase();
    final secondCountry = (second.countryCode ?? '').toUpperCase();
    return firstLanguage == secondLanguage && firstCountry == secondCountry;
  }
}
