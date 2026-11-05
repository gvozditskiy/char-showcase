import 'package:core/core.dart';

import '../analytics/survey_screen_opened_event.dart';
import '../analytics/survey_step_event.dart';
import '../model/survey_screen_model.dart';
import 'survey_event_handler.dart';

class SurveyAnalyticsEventHandler implements SurveyEventHandler {
  const SurveyAnalyticsEventHandler(this._analyticsService, {this.surveyId});

  static const type = 'analytics';

  final AnalyticsService _analyticsService;
  final String? surveyId;

  @override
  Future<SurveyHandlerOutcome> handle(SurveyScreenModel screen, Object? answer) async {
    final currentSurveyId = surveyId;
    _analyticsService.trackEvent(
      SurveyStepEvent(
        params: {
          SurveyStepEvent.screenKey: screen.key,
          if (currentSurveyId != null && currentSurveyId.isNotEmpty)
            SurveyStepEvent.surveyId: currentSurveyId,
          if (answer != null) SurveyStepEvent.answer: answer,
        },
      ),
    );
    return SurveyHandlerOutcome.proceed;
  }

  @override
  void onScreenChanged(SurveyScreenModel screen) {
    _analyticsService.trackEvent(
      SurveyScreenOpenedEvent(screenKey: screen.key, surveyId: surveyId),
    );
  }
}
