part of 'root_bloc.dart';

sealed class RootEvent {
  const RootEvent();
}

class RootScreenKeyChangedEvent extends RootEvent {
  const RootScreenKeyChangedEvent({required this.screenKey});

  final String screenKey;
}

class RootScreenBackPressedEvent extends RootEvent {
  const RootScreenBackPressedEvent({required this.screenKey});

  final String? screenKey;
}

class RootScreenClosePressedEvent extends RootEvent {
  const RootScreenClosePressedEvent();
}

class RootContinuePressedEvent extends RootEvent {
  RootContinuePressedEvent(this.currentScreen, {this.answer});

  final SurveyScreenModel currentScreen;
  final Object? answer;
  final Completer<void> processed = Completer<void>();
}
