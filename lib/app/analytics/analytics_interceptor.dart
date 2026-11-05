import 'package:core/core.dart';

class LogInterceptor implements AnalyticsInterceptor {
  const LogInterceptor(this._logger);

  final Logger _logger;

  @override
  void onTrackEvent(AnalyticsEvent event) {
    _logger.i('[ANALYTICS] : $event');
  }
}
