import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin SafeCubit<State> on Cubit<State> {
  void safeEmit(State state, {Logger? logger}) {
    if (isClosed) {
      logger?.w(
        '[$runtimeType] Attempted to emit state after close. '
        'State: $state',
      );
      return;
    }
    emit(state);
  }
}
