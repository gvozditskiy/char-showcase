import 'package:common_ui/common_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AutomationId.normalizePart', () {
    test('lowercases and replaces non-alphanumeric runs with single underscore', () {
      expect(AutomationId.normalizePart('Auth Account Logged In'), 'auth_account_logged_in');
      expect(
        AutomationId.normalizePart('Subscription/Plan.Continue'),
        'subscription_plan_continue',
      );
    });

    test('trims leading and trailing underscores', () {
      expect(AutomationId.normalizePart('  hello  '), 'hello');
      expect(AutomationId.normalizePart('___leading'), 'leading');
      expect(AutomationId.normalizePart('trailing___'), 'trailing');
      expect(AutomationId.normalizePart('---both---'), 'both');
    });

    test('returns empty string for non-alphanumeric only input', () {
      expect(AutomationId.normalizePart(''), '');
      expect(AutomationId.normalizePart('   '), '');
      expect(AutomationId.normalizePart('!!!'), '');
    });

    test('preserves digits', () {
      expect(AutomationId.normalizePart('Step 1 of 2'), 'step_1_of_2');
    });
  });

  group('AutomationId.join', () {
    test('skips null and empty parts', () {
      expect(AutomationId.join(['onboarding', null, '', 'screen']), 'onboarding_screen');
    });

    test('normalizes each part before joining', () {
      expect(AutomationId.join(['Auth', 'logIn', 'email button']), 'auth_login_email_button');
    });

    test('returns empty string for entirely empty input', () {
      expect(AutomationId.join(<String?>[]), '');
      expect(AutomationId.join([null, '', '   ']), '');
    });
  });

  group('AutomationSemantics', () {
    testWidgets('wraps child without identifier when identifier is null', (tester) async {
      const childKey = ValueKey('child');
      await tester.pumpWidget(const AutomationSemantics(child: SizedBox(key: childKey)));

      expect(find.byKey(childKey), findsOneWidget);
      final semantics = tester.widget<Semantics>(find.byType(Semantics));
      expect(semantics.properties.identifier, isNull);
    });

    testWidgets('wraps child in Semantics when identifier provided', (tester) async {
      await tester.pumpWidget(
        const AutomationSemantics(identifier: 'test_id', button: true, child: SizedBox()),
      );

      final semantics = tester.widget<Semantics>(find.byType(Semantics));
      expect(semantics.properties.identifier, 'test_id');
      expect(semantics.properties.button, isTrue);
    });
  });
}
