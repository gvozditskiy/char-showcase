import 'analytics_event.dart';
import 'analytics_interceptor.dart';
import 'analytics_tracker.dart';

class AnalyticsService {
  const AnalyticsService({required this.trackers, this.interceptors});

  final Set<AnalyticsTracker> trackers;
  final Set<AnalyticsInterceptor>? interceptors;

  void trackEvent(AnalyticsEvent event) {
    interceptors?.forEach((interceptor) => interceptor.onTrackEvent(event));
    final trackersForEvent = trackers.where(
      (tracker) => event.trackers?.contains(tracker.tracker) ?? false,
    );
    for (final tracker in trackersForEvent) {
      tracker.track(event);
    }
  }
}
