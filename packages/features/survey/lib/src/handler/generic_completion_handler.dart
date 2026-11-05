import 'package:core/core.dart';

import 'completion_handler.dart';

class GenericCompletionHandler implements CompletionHandler {
  const GenericCompletionHandler(this._analyticsService, this._logger);

  final AnalyticsService _analyticsService;
  final Logger _logger;

  @override
  Future<void> execute(String surveyId, Map<String, dynamic> answers) async {
    _logger.d('[GenericCompletionHandler] Survey completed: $surveyId');

    _analyticsService.trackEvent(
      AnalyticsEvent(
        name: 'Survey finished',
        params: {'survey_id': surveyId, 'answers_count': answers.length},
        trackers: const [Tracker.log],
      ),
    );

    _logger.d('[GenericCompletionHandler] Completion handled successfully');
  }
}
