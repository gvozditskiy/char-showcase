// ignore_for_file: one_member_abstracts

import '../model/survey_screen_model.dart';

abstract interface class SurveyNavigator {
  Future<void> goNext(SurveyScreenModel currentScreen, {Object? answer});
}
