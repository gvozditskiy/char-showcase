import 'package:core/core.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:survey/survey.dart';

import '../repository/rate_app_repository.dart';

class RateAppSystemRatingHandler extends SurveyAnalyticsEventHandler {
  const RateAppSystemRatingHandler(
    this._rateAppRepository,
    AnalyticsService analyticsService,
    this._logger,
  ) : super(analyticsService, surveyId: 'rate_app');

  final RateAppRepository _rateAppRepository;
  final Logger _logger;

  static const _storeRatingScreenKey = 'store_rating';

  @override
  Future<SurveyHandlerOutcome> handle(SurveyScreenModel screen, Object? answer) async {
    _logger.d(
      '[RateAppSystemRatingHandler] handle() called with screen=${screen.key}, answer=$answer',
    );
    if (screen.key != _storeRatingScreenKey) {
      return SurveyHandlerOutcome.proceed;
    }
    await super.handle(screen, answer);

    try {
      final inAppReview = InAppReview.instance;
      final shouldRequestInApp = !await _rateAppRepository.isNativeRateOrStoreShown();

      if (shouldRequestInApp && await inAppReview.isAvailable()) {
        _logger.d('[RateAppSystemRatingHandler] Requesting native rating');
        await inAppReview.requestReview();
      } else {
        _logger.d('[RateAppSystemRatingHandler] Opening store listing');
        await inAppReview.openStoreListing();
      }

      await _rateAppRepository.setNativeRateOrStoreShown();
      await _rateAppRepository.setRatingWasSet();
    } catch (e) {
      _logger.e('[RateAppSystemRatingHandler] Failed to show native rating', error: e);
    }
    return SurveyHandlerOutcome.finish;
  }

  @override
  void onScreenChanged(SurveyScreenModel screen) {
    if (screen.key != _storeRatingScreenKey) {
      return;
    }
    super.onScreenChanged(screen);
  }
}
