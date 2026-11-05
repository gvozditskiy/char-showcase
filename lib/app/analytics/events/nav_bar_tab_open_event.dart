import 'package:core/core.dart';

class FeedOpenedEvent extends AnalyticsEvent {
  const FeedOpenedEvent() : super(name: 'Feed screen opened', trackers: const [Tracker.log]);
}
