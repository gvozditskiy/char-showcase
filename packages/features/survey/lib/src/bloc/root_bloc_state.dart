part of 'root_bloc.dart';

enum SurveyExit { none, inProgress, awaitingPop }

class RootState {
  const RootState({
    required this.totalScreenNumber,
    required this.currentScreenNumber,
    this.exit = SurveyExit.none,
  });

  const RootState.init() : totalScreenNumber = 0, currentScreenNumber = 0, exit = SurveyExit.none;

  final int totalScreenNumber;
  final int currentScreenNumber;
  final SurveyExit exit;

  bool get finished => exit != SurveyExit.none;

  RootState copyWith({int? totalScreenNumber, int? currentScreenNumber, SurveyExit? exit}) {
    return RootState(
      totalScreenNumber: totalScreenNumber ?? this.totalScreenNumber,
      currentScreenNumber: currentScreenNumber ?? this.currentScreenNumber,
      exit: exit ?? this.exit,
    );
  }
}
