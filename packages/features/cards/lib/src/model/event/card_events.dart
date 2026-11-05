import 'package:character_data/character_data.dart';
import 'package:core/core.dart';

class CharacterShownEvent extends AnalyticsEvent {
  CharacterShownEvent(CharacterModel character)
    : super(name: 'Card shown', params: character.toAnalyticsMap(), trackers: const [Tracker.log]);
}

class CharacterLikedEvent extends AnalyticsEvent {
  CharacterLikedEvent(CharacterModel character)
    : super(name: 'Card liked', params: character.toAnalyticsMap(), trackers: const [Tracker.log]);
}

class CharacterUnlikedEvent extends AnalyticsEvent {
  CharacterUnlikedEvent(CharacterModel character)
    : super(
        name: 'Card unliked',
        params: character.toAnalyticsMap(),
        trackers: const [Tracker.log],
      );
}

extension CharacterAnalyticsMap on CharacterModel {
  Map<String, dynamic> toAnalyticsMap() {
    return <String, dynamic>{
      'card id': id,
      'card name': name,
      'card full name': fullName,
      'card age': age.toString(),
      'card tags': tags,
      'card gender': gender.map((e) => e.analyticsName).toList(),
      'cyoc': cyoc,
    };
  }
}
