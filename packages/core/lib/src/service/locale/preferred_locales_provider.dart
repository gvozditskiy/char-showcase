import 'dart:ui';

List<Locale> getPreferredLocales() {
  return PlatformDispatcher.instance.locales;
}
