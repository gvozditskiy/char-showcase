import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

const _supportedLocales = [Locale('en'), Locale('es')];

const _config = <String, dynamic>{
  'en': {'title': 'Rate Char'},
  'es': {'title': 'Valora Char'},
};

LocalizedConfigSelector _selectorFor(List<Locale> deviceLocales) {
  final provider = LocaleSettingsProvider(preferredLocalesProvider: () => deviceLocales)
    ..init(_supportedLocales);
  return LocalizedConfigSelector(provider);
}

void main() {
  group('LocalizedConfigSelector', () {
    test('selects the map of the resolved device locale', () {
      final selector = _selectorFor(const [Locale('es', 'MX')]);

      expect(selector.selectMap(_config), {'title': 'Valora Char'});
    });

    test('falls back to en when the device locale is not supported', () {
      final selector = _selectorFor(const [Locale('ja')]);

      expect(selector.selectMap(_config), {'title': 'Rate Char'});
    });

    test('falls back to en when the config has no key for the resolved locale', () {
      final selector = _selectorFor(const [Locale('es')]);

      expect(
        selector.selectList<String>(const <String, dynamic>{
          'en': ['Ava', 'Emma'],
        }),
        ['Ava', 'Emma'],
      );
    });
  });
}
