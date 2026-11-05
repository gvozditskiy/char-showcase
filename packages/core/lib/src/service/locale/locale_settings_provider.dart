import 'package:flutter/widgets.dart';

import '../../locale/locale_defaults.dart';
import 'locale_resolver.dart';
import 'preferred_locales_provider.dart';

class LocaleSettingsProvider extends ValueNotifier<Locale> {
  LocaleSettingsProvider({List<Locale> Function()? preferredLocalesProvider})
    : _preferredLocalesProvider = preferredLocalesProvider ?? getPreferredLocales,
      super(LocaleDefaults.fallbackLocale);

  final List<Locale> Function() _preferredLocalesProvider;

  Locale get resolvedLocale => value;

  String get resolvedLocaleTag => value.toLanguageTag();

  String get resolvedLanguageCode => value.languageCode.toLowerCase();

  void init(List<Locale> supportedLocales) {
    value = LocaleResolver.resolve(
      preferredLocales: _preferredLocalesProvider(),
      supportedLocales: supportedLocales,
    );
  }
}
