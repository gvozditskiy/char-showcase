import 'package:flutter_test/flutter_test.dart';
import 'package:survey/src/model/navigation/index_range_navigation_rule.dart';

void main() {
  const rule = IndexRangeNavigationRule(from: 1, to: 3, goTo: 'next');

  test('returns goTo for answer in range', () {
    expect(rule.evaluate(1), 'next');
    expect(rule.evaluate(3), 'next');
  });

  test('returns null for answer out of range or non-int', () {
    expect(rule.evaluate(4), isNull);
    expect(rule.evaluate('2'), isNull);
    expect(rule.evaluate(null), isNull);
  });
}
