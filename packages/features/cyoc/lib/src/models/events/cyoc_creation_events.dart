import 'package:core/core.dart';

import '../cyoc_character_choice.dart';

const _trackers = [Tracker.log];

class CyocCreationOpenEvent extends AnalyticsEvent {
  CyocCreationOpenEvent(String source)
    : super(name: 'Character creation open', params: {'source': source}, trackers: _trackers);
}

class CyocCreationStepOpenedEvent extends AnalyticsEvent {
  CyocCreationStepOpenedEvent(String step)
    : super(name: 'Character creation step opened', params: {'step': step}, trackers: _trackers);
}

class CyocCreationGenerateTappedEvent extends AnalyticsEvent {
  CyocCreationGenerateTappedEvent(CyocCharacterChoice choice)
    : super(
        name: 'Character creation generate tapped',
        params: {
          'gender': choice.gender.analyticsName,
          'age': choice.age,
          'style': choice.style.serverId,
          'ethnicity': ?choice.ethnicity?.serverId,
          'body type': ?choice.bodyType?.serverId,
          'hair style': ?choice.hairStyle?.serverId,
          'hair color': ?choice.hairColor?.serverId,
          'eye color': ?choice.eyeColor?.serverId,
          'facial hair': ?choice.facialHair?.serverId,
          'personality': ?choice.personality?.serverId,
        },
        trackers: _trackers,
      );
}

class CyocCreationRegenerateTappedEvent extends AnalyticsEvent {
  CyocCreationRegenerateTappedEvent()
    : super(name: 'Character creation regenerate tapped', trackers: _trackers);
}

class CyocCreationAutoSuggestTappedEvent extends AnalyticsEvent {
  CyocCreationAutoSuggestTappedEvent.name() : this._('name');

  CyocCreationAutoSuggestTappedEvent._(String source)
    : super(
        name: 'Character creation auto suggest tapped',
        params: {'source': source},
        trackers: _trackers,
      );
}

class CyocCreationAbortTappedEvent extends AnalyticsEvent {
  CyocCreationAbortTappedEvent(String step)
    : super(
        name: 'Character creation Abort button tapped',
        params: {'step': step},
        trackers: _trackers,
      );
}

class CyocCreationFailedEvent extends AnalyticsEvent {
  CyocCreationFailedEvent(String reason)
    : super(name: 'Character creation failed', params: {'reason': reason}, trackers: _trackers);
}
