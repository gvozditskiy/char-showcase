// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get cardsFeedTitle => 'Feed';

  @override
  String get cardsFeedErrorTitle => 'Feed unavailable';

  @override
  String get cardsFeedErrorDescription => 'We couldn\'t load new profiles. Please try again.';

  @override
  String get cardsFeedRetryButtonTitle => 'Retry';

  @override
  String get cardsFeedEmptyTitle => 'No profiles yet';

  @override
  String get cardsFeedEmptyDescription => 'Create your own character to get started.';

  @override
  String get cardsFeedLikeSentBadge => 'Liked';

  @override
  String get cardsFeedCreateCharacterTitle => 'Create your CUSTOM character';

  @override
  String get cardsFeedCreateCharacterLook => 'Pick look & body';

  @override
  String get cardsFeedCreateCharacterPersonality => 'Set personality';

  @override
  String get cardsFeedCreateCharacterButton => 'Start creating';

  @override
  String get cardsErrorToast => 'Something went wrong. Please try again.';

  @override
  String get cardsLikeErrorToast => 'Couldn\'t update like';

  @override
  String cardsCharacterJoinedToast(String name) {
    return '$name joined your feed';
  }

  @override
  String get detailsBioSectionTitle => 'Bio';

  @override
  String get detailsInterestsSectionTitle => 'Interests';

  @override
  String get detailsAttributesSectionTitle => 'Details';

  @override
  String get detailsNotFoundTitle => 'Profile unavailable';

  @override
  String get detailsNotFoundDescription => 'We couldn\'t load this profile.';
}
