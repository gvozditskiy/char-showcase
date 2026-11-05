import 'navigation_rule.dart';

class IndexRangeNavigationRule implements NavigationRule {
  const IndexRangeNavigationRule({required this.from, required this.to, required this.goTo});

  final int from;
  final int to;
  final String? goTo;

  @override
  String? evaluate(Object? answer) {
    if (answer is! int) return null;
    if (answer >= from && answer <= to) return goTo;
    return null;
  }
}
