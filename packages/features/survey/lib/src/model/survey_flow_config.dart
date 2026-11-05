import 'event_handler_config.dart';
import 'survey_screen_model.dart';

class SurveyFlowConfig<T extends SurveyScreenModel> {
  SurveyFlowConfig(
    this.screens, {
    this.surveyId,
    this.completionHandlerType,
    this.closeHandlerType,
    this.eventHandlerConfigs = const [],
    this.introButtonText,
  });

  final List<T> screens;
  final String? surveyId;
  final String? completionHandlerType;
  final String? closeHandlerType;
  final List<EventHandlerConfig> eventHandlerConfigs;
  final String? introButtonText;
}
