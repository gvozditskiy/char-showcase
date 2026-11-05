abstract interface class CyocFlowStep {
  String get key;

  bool get showsProgress;

  bool get countsTowardsProgress;

  bool get allowsBack;
}
