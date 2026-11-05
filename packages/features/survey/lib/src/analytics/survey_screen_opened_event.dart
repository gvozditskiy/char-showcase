import 'package:core/core.dart';

class SurveyScreenOpenedEvent extends AnalyticsEvent {
  SurveyScreenOpenedEvent({required String screenKey, String? surveyId})
    : super(
        name: defaultEventName,
        params: {screenKeyParam: screenKey, if (surveyId != null) surveyIdParam: surveyId},
        trackers: const [Tracker.log],
      );

  static const defaultEventName = 'Survey screen opened';
  static const screenKeyParam = 'screen key';
  static const surveyIdParam = 'survey id';
}
