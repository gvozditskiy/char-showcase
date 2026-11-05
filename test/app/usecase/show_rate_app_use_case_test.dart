import 'package:char/app/usecase/show_rate_app_use_case.dart';
import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:navigation/navigation.dart';
import 'package:survey/survey.dart';

class _MockAppNavigator extends Mock implements AppNavigator {}

class _MockSurveyConfigParser extends Mock implements SurveyConfigParser<SurveyScreenModel> {}

class _MockLogger extends Mock implements Logger {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
    registerFallbackValue(SurveyPath.screen);
  });

  group('ShowRateAppUseCase', () {
    late _MockAppNavigator navigator;
    late _MockLogger logger;
    late LocalizedConfigSelector selector;

    setUp(() {
      navigator = _MockAppNavigator();
      logger = _MockLogger();
      selector = LocalizedConfigSelector(
        LocaleSettingsProvider(preferredLocalesProvider: () => const [Locale('en')])
          ..init(const [Locale('en')]),
      );
    });

    test('loads the localized rate app config, parses it and opens the survey', () async {
      final parser = BaseSurveyConfigParserImpl(logger);

      await ShowRateAppUseCase(navigator, parser, selector, logger)();

      final config =
          verify(
                () => navigator.push(SurveyPath.screen, extra: captureAny(named: 'extra')),
              ).captured.single
              as SurveyFlowConfig<SurveyScreenModel>;
      expect(config.surveyId, 'rate_app');
      expect(config.screens.map((screen) => screen.key), [
        'rating',
        'negative_feedback',
        'store_rating',
      ]);
    });

    test('does not open the survey when parsing fails', () async {
      final parser = _MockSurveyConfigParser();
      when(() => parser.parse(any())).thenAnswer((_) async => null);

      await ShowRateAppUseCase(navigator, parser, selector, logger)();

      verify(() => parser.parse(any())).called(1);
      verifyNever(() => navigator.push(any(), extra: any(named: 'extra')));
    });
  });
}
