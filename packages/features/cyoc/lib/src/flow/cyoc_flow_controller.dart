import 'package:bloc/bloc.dart';
import 'package:common_ui/common_ui.dart';
import 'package:equatable/equatable.dart';

import 'cyoc_flow_step.dart';

part 'cyoc_flow_state.dart';

class CyocFlowController extends Cubit<CyocFlowState> with SafeCubit<CyocFlowState> {
  CyocFlowController({required List<CyocFlowStep> initialSteps})
    : super(CyocFlowState(steps: initialSteps));

  void next() {
    if (state.index < state.total - 1) {
      safeEmit(state.copyWith(index: state.index + 1));
    }
  }

  void back() {
    if (state.canGoBack) {
      safeEmit(state.copyWith(index: state.index - 1));
    }
  }

  void goTo(CyocFlowStep step) {
    final index = state.steps.indexWhere((s) => s.key == step.key);
    if (index >= 0) {
      safeEmit(state.copyWith(index: index));
    }
  }
}
