import '../model/survey_screen_model.dart';

enum SurveyHandlerOutcome { proceed, finish }

abstract interface class SurveyEventHandler {
  Future<SurveyHandlerOutcome> handle(SurveyScreenModel screen, Object? answer);

  void onScreenChanged(SurveyScreenModel screen);
}
