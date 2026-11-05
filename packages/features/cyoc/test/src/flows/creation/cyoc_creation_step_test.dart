import 'package:cyoc/src/flows/creation/cyoc_creation_step.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CyocCreationStep progress participation', () {
    const countingSteps = [
      CyocCreationStep.genderStyleAge,
      CyocCreationStep.ethnicity,
      CyocCreationStep.bodyType,
      CyocCreationStep.hairEye,
      CyocCreationStep.personality,
    ];

    const nonProgressSteps = [
      CyocCreationStep.generation,
      CyocCreationStep.photoPreview,
      CyocCreationStep.nameRelationship,
    ];

    test('the attribute steps both show and count towards progress', () {
      for (final step in countingSteps) {
        expect(step.showsProgress, isTrue, reason: '$step should show progress');
        expect(step.countsTowardsProgress, isTrue, reason: '$step should count towards progress');
      }
    });

    test('yourChoice shows the bar without counting towards it', () {
      expect(CyocCreationStep.yourChoice.showsProgress, isTrue);
      expect(CyocCreationStep.yourChoice.countsTowardsProgress, isFalse);
    });

    test('non-progress steps neither show nor count', () {
      for (final step in nonProgressSteps) {
        expect(step.showsProgress, isFalse, reason: '$step should not show progress');
        expect(step.countsTowardsProgress, isFalse, reason: '$step should not count progress');
      }
    });
  });

  group('CyocCreationStep builder flow', () {
    test('counts 5 attribute steps', () {
      final total = CyocCreationStep.values.where((step) => step.countsTowardsProgress).length;
      expect(total, 5);
    });

    test('asks for appearance once, right after body type', () {
      const steps = CyocCreationStep.values;
      expect(steps.indexOf(CyocCreationStep.hairEye), steps.indexOf(CyocCreationStep.bodyType) + 1);
      expect(steps.where((step) => step == CyocCreationStep.hairEye).length, 1);
    });
  });
}
