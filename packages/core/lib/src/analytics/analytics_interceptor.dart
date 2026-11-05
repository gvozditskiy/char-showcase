// ignore_for_file: one_member_abstracts

import 'analytics_event.dart';

abstract interface class AnalyticsInterceptor {
  const AnalyticsInterceptor();

  void onTrackEvent(AnalyticsEvent event);
}
