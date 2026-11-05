import 'dart:convert';
import 'dart:io';

import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:survey/survey.dart';

class _MockLogger extends Mock implements Logger {}

void main() {
  late BaseSurveyConfigParserImpl parser;

  Map<String, dynamic> loadFixture() =>
      jsonDecode(File('test/fixtures/feedback_rate_app.json').readAsStringSync())
          as Map<String, dynamic>;

  setUp(() {
    parser = BaseSurveyConfigParserImpl(_MockLogger());
  });

  test('parses rate app fixture', () async {
    final config = await parser.parse(loadFixture());

    expect(config, isNotNull);
    expect(config!.surveyId, 'rate_app');
    expect(config.introButtonText, 'Start');
    expect(config.screens.map((screen) => screen.key), [
      'rating',
      'negative_feedback',
      'store_rating',
    ]);
    expect(config.screens[0], isA<RatingSurveyScreenModel>());
    expect(config.screens[1], isA<SurveyCoverScreenModel>());
    expect(config.screens[2], isA<SurveyCoverScreenModel>());

    final rating = config.screens[0] as RatingSurveyScreenModel;
    expect(rating.title, 'Rate Char');
    expect(rating.options.map((option) => option.value), [1, 2, 3, 4, 5]);
    expect((config.screens[1] as SurveyCoverScreenModel).continueButtonText, 'Rate Char');

    final rules = rating.navigation!.rules!;
    expect(rules, hasLength(2));
    expect(rules[0].evaluate(2), 'negative_feedback');
    expect(rules[1].evaluate(5), 'store_rating');

    expect(config.eventHandlerConfigs, hasLength(3));
    final positive = config.eventHandlerConfigs[0];
    expect(positive.type, 'rate_app_positive');
    expect(positive.scope, EventHandlerScope.screen);
    expect(positive.screenKeys, ['store_rating']);
    final negative = config.eventHandlerConfigs[1];
    expect(negative.type, 'rate_app_negative_feedback');
    expect(negative.scope, EventHandlerScope.screen);
    expect(negative.screenKeys, ['negative_feedback']);
  });

  test('returns null for unknown screenType', () async {
    final json = loadFixture();
    (json['screens'] as List<dynamic>).add({'screenType': 'LIST_SURVEY', 'key': 'list'});

    expect(await parser.parse(json), isNull);
  });

  test('returns null for unknown navigation ruleType', () async {
    final json = loadFixture();
    ((json['screens'] as List<dynamic>)[0] as Map<String, dynamic>)['navigation'] = {
      'rules': [
        {'ruleType': 'UNKNOWN', 'goTo': 'x'},
      ],
    };

    expect(await parser.parse(json), isNull);
  });

  test('returns null for unknown event handler scope', () async {
    final json = loadFixture()
      ..['eventHandlers'] = [
        {'type': 'rate_app_positive', 'scope': 'conditional'},
      ];

    expect(await parser.parse(json), isNull);
  });
}
