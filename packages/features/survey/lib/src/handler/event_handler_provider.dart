import 'package:core/core.dart';

import '../helper/app_survey_constants.dart';

import 'survey_event_handler.dart';

class EventHandlerProvider {
  EventHandlerProvider(this._di, this._logger);

  final ServiceLocator _di;
  final Logger _logger;

  SurveyEventHandler? getHandler(String type, {String? surveyId}) {
    try {
      return _di.get<SurveyEventHandler>(
        instanceName: type,
        params: {AppSurveyConstants.surveyIdParam: surveyId},
      );
    } catch (e, stackTrace) {
      _logger.w('[EventHandlerProvider] Handler $type could not be resolved', e, stackTrace);
      return null;
    }
  }
}
