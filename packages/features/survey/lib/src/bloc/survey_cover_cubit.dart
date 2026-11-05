import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/survey_screen_model.dart';
import '../route/survey_navigator.dart';

class SurveyCoverCubit extends Cubit<SurveyCoverState> {
  SurveyCoverCubit(this._obNavigator, this._screenModel) : super(const SurveyCoverState());

  final SurveyNavigator _obNavigator;
  final BaseSurveyScreenModel _screenModel;

  void onContinueTap() {
    unawaited(_obNavigator.goNext(_screenModel));
  }
}

class SurveyCoverState {
  const SurveyCoverState();
}
