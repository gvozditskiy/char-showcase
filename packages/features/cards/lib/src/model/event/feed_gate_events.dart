import 'package:core/core.dart';

class FeedCreateCharacterPromoShownEvent extends AnalyticsEvent {
  FeedCreateCharacterPromoShownEvent()
    : super(name: 'Feed create character promo shown', trackers: const [Tracker.log]);
}

class FeedCreateCharacterPromoTappedEvent extends AnalyticsEvent {
  FeedCreateCharacterPromoTappedEvent()
    : super(name: 'Feed create character promo button tapped', trackers: const [Tracker.log]);
}
