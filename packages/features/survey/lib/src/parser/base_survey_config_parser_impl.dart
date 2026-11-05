import 'package:core/core.dart';

import '../model/event_handler_config.dart';
import '../model/navigation/index_range_navigation_rule.dart';
import '../model/navigation/navigation_rule.dart';
import '../model/survey_base_screen_models.dart';
import '../model/survey_flow_config.dart';
import '../model/survey_option_model.dart';
import '../model/survey_screen_model.dart';
import '../model/survey_screen_models.dart';
import 'survey_config_parser.dart';

class BaseSurveyConfigParserImpl implements SurveyConfigParser<SurveyScreenModel> {
  BaseSurveyConfigParserImpl(this._logger);

  final Logger _logger;

  @override
  Future<SurveyFlowConfig<SurveyScreenModel>?> parse(Map<String, dynamic> json) async {
    try {
      final screens = <SurveyScreenModel>[];
      for (final screenJson in (json['screens'] as List<dynamic>?) ?? const <dynamic>[]) {
        screens.add(_parseScreen(screenJson as Map<String, dynamic>));
      }

      if (screens.isEmpty) {
        _logger.w('[BaseSurveyConfigParser] Survey config is empty after parsing');
        return null;
      }

      _logger.d('[BaseSurveyConfigParser] Successfully parsed ${screens.length} survey screens');
      return SurveyFlowConfig<SurveyScreenModel>(
        screens,
        surveyId: json['surveyId'] as String?,
        introButtonText: json['introButtonText'] as String?,
        eventHandlerConfigs: _parseEventHandlerConfigs(json['eventHandlers'] as List<dynamic>?),
      );
    } catch (e, stackTrace) {
      _logger.e(
        '[BaseSurveyConfigParser] Failed to parse survey config',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  SurveyScreenModel _parseScreen(Map<String, dynamic> json) {
    final typeString = json['screenType'] as String?;
    final key = json['key'] as String;
    final title = json['title'] as String?;
    final subtitle = json['subtitle'] as String?;
    final navigation = _parseNavigation(json['navigation']);
    return switch (typeString?.toUpperCase()) {
      'COVER_SURVEY' => SurveyCoverScreenModel(
        key: key,
        title: title,
        subtitle: subtitle,
        navigation: navigation,
        continueButtonText: json['continueButtonText'] as String?,
      ),
      'RATING_SURVEY' => RatingSurveyScreenModel(
        key: key,
        title: title,
        subtitle: subtitle,
        navigation: navigation,
        options: ((json['options'] as List<dynamic>?) ?? const <dynamic>[])
            .cast<Map<String, dynamic>>()
            .map(
              (option) => RatingOptionModel(
                key: option['key'] as String,
                value: option['value'] as int,
                emoji: option['emoji'] as String,
              ),
            )
            .toList(),
      ),
      _ => throw FormatException('Unknown screenType: $typeString'),
    };
  }

  List<EventHandlerConfig> _parseEventHandlerConfigs(List<dynamic>? json) {
    return (json ?? const <dynamic>[])
        .cast<Map<String, dynamic>>()
        .map(
          (handler) => EventHandlerConfig(
            type: handler['type'] as String,
            scope: _parseScope(handler['scope'] as String? ?? 'global'),
            screenKeys: (handler['screenKeys'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList(),
          ),
        )
        .toList();
  }

  EventHandlerScope _parseScope(String value) => switch (value.toLowerCase()) {
    'global' => EventHandlerScope.global,
    'screen' => EventHandlerScope.screen,
    _ => throw FormatException('Unknown event handler scope: $value'),
  };

  NavigationRuleConfig _parseNavigation(Object? json) {
    final rules = switch (json) {
      final List<dynamic> list => list,
      {'rules': final List<dynamic> list} => list,
      _ => const <dynamic>[],
    };
    if (rules.isEmpty) {
      return const NavigationRuleConfig();
    }
    return NavigationRuleConfig(
      rules: rules.cast<Map<String, dynamic>>().map(_parseNavigationRule).toList(),
    );
  }

  NavigationRule _parseNavigationRule(Map<String, dynamic> json) {
    final ruleType = (json['ruleType'] as String?)?.toUpperCase();
    return switch (ruleType) {
      'INDEX_RANGE' => _parseIndexRangeRule(json),
      _ => throw FormatException('Unknown navigation rule type: $ruleType'),
    };
  }

  IndexRangeNavigationRule _parseIndexRangeRule(Map<String, dynamic> json) {
    final range = json['range'] as List<dynamic>;
    return IndexRangeNavigationRule(
      from: range[0] as int,
      to: range[1] as int,
      goTo: json['goTo'] as String?,
    );
  }
}
