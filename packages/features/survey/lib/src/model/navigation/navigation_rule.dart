// ignore_for_file: one_member_abstracts

abstract interface class NavigationRule {
  String? evaluate(Object? answer);
}

class NavigationRuleConfig {
  const NavigationRuleConfig({this.rules});

  final List<NavigationRule>? rules;
}
