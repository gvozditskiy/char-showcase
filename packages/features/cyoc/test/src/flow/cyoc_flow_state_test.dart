import 'package:cyoc/src/flow/cyoc_flow_controller.dart';
import 'package:cyoc/src/flow/cyoc_flow_step.dart';
import 'package:flutter_test/flutter_test.dart';

class _Step implements CyocFlowStep {
  const _Step(this.key, {this.showsProgress = false, this.countsTowardsProgress = false});

  @override
  final String key;

  @override
  final bool showsProgress;

  @override
  final bool countsTowardsProgress;

  @override
  bool get allowsBack => true;
}

void main() {
  group('CyocFlowState', () {
    const steps = [_Step('a'), _Step('b'), _Step('c')];

    test('defaults index to 0 and shows toolbar', () {
      const state = CyocFlowState(steps: steps);
      expect(state.index, 0);
    });

    test('current returns the step at index', () {
      const state = CyocFlowState(steps: steps, index: 1);
      expect(state.current.key, 'b');
    });

    test('total is the number of steps', () {
      const state = CyocFlowState(steps: steps);
      expect(state.total, 3);
    });

    test('canGoBack is false at first step and true afterwards', () {
      expect(const CyocFlowState(steps: steps).canGoBack, isFalse);
      expect(const CyocFlowState(steps: steps, index: 1).canGoBack, isTrue);
    });

    test('copyWith overrides only provided fields', () {
      const state = CyocFlowState(steps: steps, index: 1);
      final next = state.copyWith(index: 2);
      expect(next.index, 2);
      expect(next.total, 3);
    });

    test('equatable treats same values as equal', () {
      expect(
        const CyocFlowState(steps: steps, index: 1),
        const CyocFlowState(steps: steps, index: 1),
      );
    });
  });

  group('CyocFlowState progress', () {
    const progressSteps = [
      _Step('intro'),
      _Step('p1', showsProgress: true, countsTowardsProgress: true),
      _Step('p2', showsProgress: true, countsTowardsProgress: true),
      _Step('p3', showsProgress: true, countsTowardsProgress: true),
      _Step('summary', showsProgress: true),
      _Step('outro'),
    ];

    test('hasProgress is false on a step that does not show progress', () {
      const state = CyocFlowState(steps: progressSteps);
      expect(state.hasProgress, isFalse);
    });

    test('hasProgress is true on a counting step', () {
      const state = CyocFlowState(steps: progressSteps, index: 1);
      expect(state.hasProgress, isTrue);
    });

    test('progressTotal counts only the counting steps', () {
      const state = CyocFlowState(steps: progressSteps);
      expect(state.progressTotal, 3);
    });

    test('progressIndex reflects the ordinal position among counting steps', () {
      expect(const CyocFlowState(steps: progressSteps, index: 1).progressIndex, 1);
      expect(const CyocFlowState(steps: progressSteps, index: 2).progressIndex, 2);
      expect(const CyocFlowState(steps: progressSteps, index: 3).progressIndex, 3);
    });

    test('progressIndex is full on a trailing step that shows but does not count', () {
      const state = CyocFlowState(steps: progressSteps, index: 4);
      expect(state.hasProgress, isTrue);
      expect(state.progressIndex, state.progressTotal);
      expect(state.progressIndex, 3);
    });

    test('progressIndex is empty on a leading step that shows but does not count', () {
      const steps = [
        _Step('type', showsProgress: true),
        _Step('p1', showsProgress: true, countsTowardsProgress: true),
        _Step('p2', showsProgress: true, countsTowardsProgress: true),
      ];
      const state = CyocFlowState(steps: steps);
      expect(state.hasProgress, isTrue);
      expect(state.progressTotal, 2);
      expect(state.progressIndex, 0);
    });

    test('hasProgress is false again after the counted range', () {
      const state = CyocFlowState(steps: progressSteps, index: 5);
      expect(state.hasProgress, isFalse);
    });
  });
}
