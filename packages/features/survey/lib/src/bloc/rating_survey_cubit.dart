import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/survey_base_screen_models.dart';
import '../route/survey_navigator.dart';

class RatingSurveyCubit extends Cubit<RatingSurveyState> {
  RatingSurveyCubit(this._surveyNavigator, this._screenModel) : super(const RatingSurveyState());

  final SurveyNavigator _surveyNavigator;
  final RatingSurveyScreenModel _screenModel;

  void onRatingSelected(int rating) {
    unawaited(_surveyNavigator.goNext(_screenModel, answer: rating));
  }
}

class RatingSurveyState {
  const RatingSurveyState();
}
