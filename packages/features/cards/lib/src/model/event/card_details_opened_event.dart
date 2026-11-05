import 'package:character_data/character_data.dart';
import 'package:core/core.dart';

import 'card_events.dart';

class CharacterDetailsOpenedEvent extends AnalyticsEvent {
  CharacterDetailsOpenedEvent(CharacterModel character)
    : super(
        name: 'Card details tapped',
        params: character.toAnalyticsMap(),
        trackers: const [Tracker.log],
      );
}
