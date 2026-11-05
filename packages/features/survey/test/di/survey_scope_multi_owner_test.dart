import 'package:common_ui/common_ui.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:survey/survey.dart';

void main() {
  final di = ServiceLocator();

  tearDown(() {
    di.destroyScope(SurveyComponent.scope);
  });

  test('survey scope survives until the last owner disposes', () {
    SurveyComponent.init();
    SurveyComponent.init();

    SurveyComponent.dispose();
    expect(di.containsScope(scopeName: SurveyComponent.scope), isTrue);

    SurveyComponent.dispose();
    expect(di.containsScope(scopeName: SurveyComponent.scope), isFalse);
  });

  test('dispose without a matching init is a no-op', () {
    SurveyComponent.dispose();

    expect(di.containsScope(scopeName: SurveyComponent.scope), isFalse);
  });

  testWidgets('survey scope stays registered while a sibling Scoped is still mounted', (
    tester,
  ) async {
    await tester.pumpWidget(const _SurveyOwners(firstOwnerMounted: true, secondOwnerMounted: true));
    expect(di.containsScope(scopeName: SurveyComponent.scope), isTrue);

    await tester.pumpWidget(
      const _SurveyOwners(firstOwnerMounted: false, secondOwnerMounted: true),
    );
    expect(di.containsScope(scopeName: SurveyComponent.scope), isTrue);

    await tester.pumpWidget(
      const _SurveyOwners(firstOwnerMounted: false, secondOwnerMounted: false),
    );
    expect(di.containsScope(scopeName: SurveyComponent.scope), isFalse);
  });
}

class _SurveyOwners extends StatelessWidget {
  const _SurveyOwners({required this.firstOwnerMounted, required this.secondOwnerMounted});

  final bool firstOwnerMounted;
  final bool secondOwnerMounted;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Stack(
        children: [
          if (firstOwnerMounted)
            const Scoped(
              key: ValueKey('shell_route_owner'),
              onInit: SurveyComponent.init,
              onDispose: SurveyComponent.dispose,
              child: SizedBox.shrink(),
            ),
          if (secondOwnerMounted)
            const Scoped(
              key: ValueKey('modal_survey_owner'),
              onInit: SurveyComponent.init,
              onDispose: SurveyComponent.dispose,
              child: SizedBox.shrink(),
            ),
        ],
      ),
    );
  }
}
