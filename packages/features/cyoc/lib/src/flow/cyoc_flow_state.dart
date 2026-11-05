part of 'cyoc_flow_controller.dart';

class CyocFlowState extends Equatable {
  const CyocFlowState({required this.steps, this.index = 0});

  final List<CyocFlowStep> steps;
  final int index;

  CyocFlowStep get current => steps[index];

  int get total => steps.length;

  bool get canGoBack => index > 0;

  bool get hasProgress => current.showsProgress;

  int get progressTotal => steps.where((step) => step.countsTowardsProgress).length;

  int get progressIndex => steps.take(index + 1).where((step) => step.countsTowardsProgress).length;

  CyocFlowState copyWith({List<CyocFlowStep>? steps, int? index}) {
    return CyocFlowState(steps: steps ?? this.steps, index: index ?? this.index);
  }

  @override
  List<Object?> get props => [steps, index];
}
