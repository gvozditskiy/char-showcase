import 'package:core/core.dart';

class LogAnalyticsTracker implements AnalyticsTracker {
  const LogAnalyticsTracker(this._logger);

  final Logger _logger;

  @override
  Tracker get tracker => Tracker.log;

  @override
  void track(AnalyticsEvent event) {
    _logger.d('[LogAnalyticsTracker] : track ${event.name} ${event.params ?? const {}}');
  }
}
