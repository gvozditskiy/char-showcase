import 'package:flutter/widgets.dart';

abstract final class LocaleDefaults {
  static const String fallbackLanguageCode = 'en';
  static const Locale fallbackLocale = Locale(fallbackLanguageCode);
  static const List<Locale> fallbackLocales = <Locale>[fallbackLocale];
}
