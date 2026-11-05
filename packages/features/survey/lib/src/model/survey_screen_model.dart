import 'navigation/navigation_rule.dart';

abstract interface class SurveyScreenModel {
  String get key;
  NavigationRuleConfig? get navigation => null;
}

abstract class BaseSurveyScreenModel implements SurveyScreenModel {
  BaseSurveyScreenModel({required this.key, this.title, this.subtitle, this.navigation});

  @override
  final String key;
  final String? title;
  final String? subtitle;
  @override
  final NavigationRuleConfig? navigation;
}
