import 'package:cyoc/src/flow/cyoc_flow_controller.dart';
import 'package:cyoc/src/flow/cyoc_flow_step.dart';
import 'package:flutter_test/flutter_test.dart';

class _Step implements CyocFlowStep {
  const _Step(this.key);

  @override
  final String key;

  @override
  bool get showsProgress => false;

  @override
  bool get countsTowardsProgress => false;

  @override
  bool get allowsBack => true;
}

void main() {
  group('CyocFlowController', () {
    const a = _Step('a');
    const b = _Step('b');
    const c = _Step('c');

    late CyocFlowController controller;

    setUp(() {
      controller = CyocFlowController(initialSteps: const [a, b, c]);
    });

    tearDown(() async {
      await controller.close();
    });

    test('starts at the first step', () {
      expect(controller.state.current.key, 'a');
      expect(controller.state.index, 0);
    });

    test('next advances one step', () {
      controller.next();
      expect(controller.state.current.key, 'b');
    });

    test('next does nothing at the last step', () {
      controller
        ..next()
        ..next()
        ..next();
      expect(controller.state.index, 2);
    });

    test('back retreats one step', () {
      controller
        ..next()
        ..back();
      expect(controller.state.current.key, 'a');
    });

    test('back does nothing at the first step', () {
      controller.back();
      expect(controller.state.index, 0);
    });

    test('goTo jumps to a step by key', () {
      controller.goTo(c);
      expect(controller.state.index, 2);
    });

    test('goTo ignores unknown step', () {
      controller.goTo(const _Step('z'));
      expect(controller.state.index, 0);
    });
  });
}
