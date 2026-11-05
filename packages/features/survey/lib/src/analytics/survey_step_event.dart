import 'package:core/core.dart';

class SurveyStepEvent extends AnalyticsEvent {
  const SurveyStepEvent({super.params}) : super(name: eventName, trackers: const [Tracker.log]);

  static const eventName = 'Survey step';
  static const screenKey = 'screen key';
  static const surveyId = 'survey id';
  static const answer = 'answer';
}
