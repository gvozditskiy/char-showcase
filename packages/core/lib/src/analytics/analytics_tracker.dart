import 'analytics_event.dart';
import 'tracker.dart';

abstract interface class AnalyticsTracker {
  abstract final Tracker tracker;
  void track(AnalyticsEvent event);
}
