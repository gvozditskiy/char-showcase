import 'package:core/core.dart';

class CyocButtonTappedEvent extends AnalyticsEvent {
  const CyocButtonTappedEvent()
    : super(
        name: 'Create your character button tapped',
        params: const {'placement': 'button'},
        trackers: const [Tracker.log],
      );
}
