import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'arb/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @cardsFeedTitle.
  ///
  /// In en, this message translates to:
  /// **'Feed'**
  String get cardsFeedTitle;

  /// No description provided for @cardsFeedErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Feed unavailable'**
  String get cardsFeedErrorTitle;

  /// No description provided for @cardsFeedErrorDescription.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load new profiles. Please try again.'**
  String get cardsFeedErrorDescription;

  /// No description provided for @cardsFeedRetryButtonTitle.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get cardsFeedRetryButtonTitle;

  /// No description provided for @cardsFeedEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No profiles yet'**
  String get cardsFeedEmptyTitle;

  /// No description provided for @cardsFeedEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Create your own character to get started.'**
  String get cardsFeedEmptyDescription;

  /// No description provided for @cardsFeedLikeSentBadge.
  ///
  /// In en, this message translates to:
  /// **'Liked'**
  String get cardsFeedLikeSentBadge;

  /// No description provided for @cardsFeedCreateCharacterTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your CUSTOM character'**
  String get cardsFeedCreateCharacterTitle;

  /// No description provided for @cardsFeedCreateCharacterLook.
  ///
  /// In en, this message translates to:
  /// **'Pick look & body'**
  String get cardsFeedCreateCharacterLook;

  /// No description provided for @cardsFeedCreateCharacterPersonality.
  ///
  /// In en, this message translates to:
  /// **'Set personality'**
  String get cardsFeedCreateCharacterPersonality;

  /// No description provided for @cardsFeedCreateCharacterButton.
  ///
  /// In en, this message translates to:
  /// **'Start creating'**
  String get cardsFeedCreateCharacterButton;

  /// No description provided for @cardsErrorToast.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get cardsErrorToast;

  /// No description provided for @cardsLikeErrorToast.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t update like'**
  String get cardsLikeErrorToast;

  /// No description provided for @cardsCharacterJoinedToast.
  ///
  /// In en, this message translates to:
  /// **'{name} joined your feed'**
  String cardsCharacterJoinedToast(String name);

  /// No description provided for @detailsBioSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get detailsBioSectionTitle;

  /// No description provided for @detailsInterestsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Interests'**
  String get detailsInterestsSectionTitle;

  /// No description provided for @detailsAttributesSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get detailsAttributesSectionTitle;

  /// No description provided for @detailsNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile unavailable'**
  String get detailsNotFoundTitle;

  /// No description provided for @detailsNotFoundDescription.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load this profile.'**
  String get detailsNotFoundDescription;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
