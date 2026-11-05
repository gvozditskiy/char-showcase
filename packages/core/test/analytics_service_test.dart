import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AnalyticsService', () {
    test('sends event only to trackers listed in the event', () {
      final operations = <String>[];
      final tracker = _FakeTracker(operations);
      final service = AnalyticsService(trackers: {tracker})
        ..trackEvent(const AnalyticsEvent(name: 'matching', trackers: [Tracker.log]))
        ..trackEvent(const AnalyticsEvent(name: 'not_matching', trackers: []))
        ..trackEvent(const AnalyticsEvent(name: 'no_trackers'));

      expect(service.trackers, {tracker});
      expect(operations, ['track:matching']);
    });

    test('calls interceptors before trackers', () {
      final operations = <String>[];
      AnalyticsService(
        trackers: {_FakeTracker(operations)},
        interceptors: {_FakeInterceptor(operations)},
      ).trackEvent(const AnalyticsEvent(name: 'event', trackers: [Tracker.log]));

      expect(operations, ['intercept:event', 'track:event']);
    });
  });
}

class _FakeTracker implements AnalyticsTracker {
  _FakeTracker(this._operations);

  final List<String> _operations;

  @override
  Tracker get tracker => Tracker.log;

  @override
  void track(AnalyticsEvent event) {
    _operations.add('track:${event.name}');
  }
}

class _FakeInterceptor implements AnalyticsInterceptor {
  const _FakeInterceptor(this._operations);

  final List<String> _operations;

  @override
  void onTrackEvent(AnalyticsEvent event) {
    _operations.add('intercept:${event.name}');
  }
}
