import 'package:core/core.dart';
import 'package:survey/survey.dart';

import '../repository/rate_app_repository.dart';
import '../usecase/open_email_composer_use_case.dart';

class RateAppNegativeFeedbackHandler extends SurveyAnalyticsEventHandler {
  const RateAppNegativeFeedbackHandler(
    this._openEmailComposerUseCase,
    this._surveyRepository,
    this._rateAppRepository,
    AnalyticsService analyticsService,
    this._logger,
  ) : super(analyticsService, surveyId: 'rate_app');

  final OpenEmailComposerUseCase _openEmailComposerUseCase;
  final SurveyRepository _surveyRepository;
  final RateAppRepository _rateAppRepository;
  final Logger _logger;

  static const _ratingScreenKey = 'rating';
  static const _negativeFeedbackScreenKey = 'negative_feedback';
  static const _negativeFeedbackEmailAddress = 'support@char.app';

  @override
  Future<SurveyHandlerOutcome> handle(SurveyScreenModel screen, Object? answer) async {
    _logger.d('[RateAppNegativeFeedbackHandler] handle() called with screen=${screen.key}');
    if (screen.key != _negativeFeedbackScreenKey) {
      return SurveyHandlerOutcome.proceed;
    }
    await super.handle(screen, answer);

    try {
      await _rateAppRepository.setRatingWasSet();

      final rawRating = _surveyRepository.getAnswerAs<int>(screenKey: _ratingScreenKey);
      final rating = rawRating != null ? _normalizeRating(rawRating) : 1;
      await _openEmailComposerUseCase(
        emailAddress: _negativeFeedbackEmailAddress,
        subject: _buildStars(rating),
      );
    } catch (e) {
      _logger.e('[RateAppNegativeFeedbackHandler] Failed to handle negative feedback', error: e);
    }
    return SurveyHandlerOutcome.finish;
  }

  @override
  void onScreenChanged(SurveyScreenModel screen) {
    if (screen.key != _negativeFeedbackScreenKey) {
      return;
    }
    super.onScreenChanged(screen);
  }

  int _normalizeRating(int value) {
    if (value < 1) {
      return 1;
    }
    if (value > 5) {
      return 5;
    }
    return value;
  }

  String _buildStars(int rating) {
    final buffer = StringBuffer();
    for (var i = 0; i < rating; i++) {
      buffer.write('★');
    }
    return buffer.toString();
  }
}
