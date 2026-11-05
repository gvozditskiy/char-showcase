import '../../flow/cyoc_flow_step.dart';

enum CyocCreationStep implements CyocFlowStep {
  genderStyleAge,
  ethnicity,
  bodyType,
  hairEye,
  personality,
  yourChoice,
  generation,
  photoPreview,
  nameRelationship;

  @override
  String get key => name;

  @override
  bool get showsProgress => switch (this) {
    CyocCreationStep.genderStyleAge ||
    CyocCreationStep.ethnicity ||
    CyocCreationStep.bodyType ||
    CyocCreationStep.hairEye ||
    CyocCreationStep.personality ||
    CyocCreationStep.yourChoice => true,
    CyocCreationStep.generation ||
    CyocCreationStep.photoPreview ||
    CyocCreationStep.nameRelationship => false,
  };

  @override
  bool get countsTowardsProgress => switch (this) {
    CyocCreationStep.genderStyleAge ||
    CyocCreationStep.ethnicity ||
    CyocCreationStep.bodyType ||
    CyocCreationStep.hairEye ||
    CyocCreationStep.personality => true,
    CyocCreationStep.yourChoice ||
    CyocCreationStep.generation ||
    CyocCreationStep.photoPreview ||
    CyocCreationStep.nameRelationship => false,
  };

  @override
  bool get allowsBack => switch (this) {
    CyocCreationStep.genderStyleAge ||
    CyocCreationStep.ethnicity ||
    CyocCreationStep.bodyType ||
    CyocCreationStep.hairEye ||
    CyocCreationStep.personality ||
    CyocCreationStep.yourChoice ||
    CyocCreationStep.generation ||
    CyocCreationStep.photoPreview => true,
    CyocCreationStep.nameRelationship => false,
  };
}
