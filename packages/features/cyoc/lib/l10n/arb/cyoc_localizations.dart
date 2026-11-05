import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'cyoc_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'arb/cyoc_localizations.dart';
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

  /// No description provided for @ageTitle.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get ageTitle;

  /// No description provided for @continueButtonTitle.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButtonTitle;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Woman'**
  String get genderFemale;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Man'**
  String get genderMale;

  /// No description provided for @genderNonBinary.
  ///
  /// In en, this message translates to:
  /// **'Non-binary'**
  String get genderNonBinary;

  /// No description provided for @genderTitle.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get genderTitle;

  /// No description provided for @genderUnspecified.
  ///
  /// In en, this message translates to:
  /// **'Unspecified'**
  String get genderUnspecified;

  /// Section title for choosing the generated photo style on the builder screen
  ///
  /// In en, this message translates to:
  /// **'Style'**
  String get cyocCreationStyleTitle;

  /// No description provided for @cyocCreationStyleRealistic.
  ///
  /// In en, this message translates to:
  /// **'Realistic'**
  String get cyocCreationStyleRealistic;

  /// No description provided for @cyocCreationStyleAnime.
  ///
  /// In en, this message translates to:
  /// **'Anime'**
  String get cyocCreationStyleAnime;

  /// Title shown on the loading screen while the character photo is generated
  ///
  /// In en, this message translates to:
  /// **'Creating your scene...'**
  String get cyocCreationGeneratingTitle;

  /// No description provided for @cyocCreationGeneratingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This may take 30-60 seconds'**
  String get cyocCreationGeneratingSubtitle;

  /// No description provided for @cyocCreationAgeYearsOld.
  ///
  /// In en, this message translates to:
  /// **'{age} years old'**
  String cyocCreationAgeYearsOld(int age);

  /// No description provided for @cyocCreationAgeMax.
  ///
  /// In en, this message translates to:
  /// **'99+'**
  String get cyocCreationAgeMax;

  /// No description provided for @cyocCreationEthnicityTitle.
  ///
  /// In en, this message translates to:
  /// **'Ethnicity'**
  String get cyocCreationEthnicityTitle;

  /// No description provided for @cyocCreationBodyTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'Body type'**
  String get cyocCreationBodyTypeTitle;

  /// No description provided for @cyocCreationHairStyleTitle.
  ///
  /// In en, this message translates to:
  /// **'Hair style'**
  String get cyocCreationHairStyleTitle;

  /// No description provided for @cyocCreationHairColorTitle.
  ///
  /// In en, this message translates to:
  /// **'Hair color'**
  String get cyocCreationHairColorTitle;

  /// No description provided for @cyocCreationFacialHairTitle.
  ///
  /// In en, this message translates to:
  /// **'Beard style'**
  String get cyocCreationFacialHairTitle;

  /// No description provided for @cyocCreationToolbarTitle.
  ///
  /// In en, this message translates to:
  /// **'Your AI character'**
  String get cyocCreationToolbarTitle;

  /// No description provided for @cyocCreationPersonalityTitle.
  ///
  /// In en, this message translates to:
  /// **'Personality'**
  String get cyocCreationPersonalityTitle;

  /// No description provided for @cyocCreationEyeColorTitle.
  ///
  /// In en, this message translates to:
  /// **'Eye color'**
  String get cyocCreationEyeColorTitle;

  /// No description provided for @cyocCreationYourChoiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Your choice'**
  String get cyocCreationYourChoiceTitle;

  /// No description provided for @cyocCreationChoiceAgeYears.
  ///
  /// In en, this message translates to:
  /// **'{age} years'**
  String cyocCreationChoiceAgeYears(int age);

  /// No description provided for @cyocCreationAgeArtLabel.
  ///
  /// In en, this message translates to:
  /// **'AGE'**
  String get cyocCreationAgeArtLabel;

  /// No description provided for @cyocCreationCreateMyAi.
  ///
  /// In en, this message translates to:
  /// **'Create my AI'**
  String get cyocCreationCreateMyAi;

  /// No description provided for @cyocCreationNameSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Character name'**
  String get cyocCreationNameSectionTitle;

  /// No description provided for @cyocCreationNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get cyocCreationNameHint;

  /// No description provided for @cyocCreationStartAsTitle.
  ///
  /// In en, this message translates to:
  /// **'Start as'**
  String get cyocCreationStartAsTitle;

  /// No description provided for @cyocCreationRelationshipStrangers.
  ///
  /// In en, this message translates to:
  /// **'Strangers'**
  String get cyocCreationRelationshipStrangers;

  /// No description provided for @cyocCreationRelationshipFriends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get cyocCreationRelationshipFriends;

  /// No description provided for @cyocCreationRelationshipFriendsWithBenefits.
  ///
  /// In en, this message translates to:
  /// **'Friends with benefits'**
  String get cyocCreationRelationshipFriendsWithBenefits;

  /// No description provided for @cyocCreationRelationshipDating.
  ///
  /// In en, this message translates to:
  /// **'Dating'**
  String get cyocCreationRelationshipDating;

  /// No description provided for @cyocCreationRelationshipAffair.
  ///
  /// In en, this message translates to:
  /// **'Affair'**
  String get cyocCreationRelationshipAffair;

  /// No description provided for @cyocCreationRelationshipMarried.
  ///
  /// In en, this message translates to:
  /// **'Married'**
  String get cyocCreationRelationshipMarried;

  /// No description provided for @cyocCreationEthnicityWhite.
  ///
  /// In en, this message translates to:
  /// **'White'**
  String get cyocCreationEthnicityWhite;

  /// No description provided for @cyocCreationEthnicityLatina.
  ///
  /// In en, this message translates to:
  /// **'Latina'**
  String get cyocCreationEthnicityLatina;

  /// No description provided for @cyocCreationEthnicityLatino.
  ///
  /// In en, this message translates to:
  /// **'Latino'**
  String get cyocCreationEthnicityLatino;

  /// No description provided for @cyocCreationEthnicityBlack.
  ///
  /// In en, this message translates to:
  /// **'Black'**
  String get cyocCreationEthnicityBlack;

  /// No description provided for @cyocCreationEthnicityEastAsian.
  ///
  /// In en, this message translates to:
  /// **'East Asian'**
  String get cyocCreationEthnicityEastAsian;

  /// No description provided for @cyocCreationEthnicitySouthAsian.
  ///
  /// In en, this message translates to:
  /// **'South Asian'**
  String get cyocCreationEthnicitySouthAsian;

  /// No description provided for @cyocCreationEthnicityMiddleEastern.
  ///
  /// In en, this message translates to:
  /// **'Middle Eastern'**
  String get cyocCreationEthnicityMiddleEastern;

  /// No description provided for @cyocCreationEthnicityNordic.
  ///
  /// In en, this message translates to:
  /// **'Nordic'**
  String get cyocCreationEthnicityNordic;

  /// No description provided for @cyocCreationEthnicitySlavic.
  ///
  /// In en, this message translates to:
  /// **'Slavic'**
  String get cyocCreationEthnicitySlavic;

  /// No description provided for @cyocCreationBodyTypeNatural.
  ///
  /// In en, this message translates to:
  /// **'Natural'**
  String get cyocCreationBodyTypeNatural;

  /// No description provided for @cyocCreationBodyTypeSlim.
  ///
  /// In en, this message translates to:
  /// **'Slim'**
  String get cyocCreationBodyTypeSlim;

  /// No description provided for @cyocCreationBodyTypeAthletic.
  ///
  /// In en, this message translates to:
  /// **'Athletic'**
  String get cyocCreationBodyTypeAthletic;

  /// No description provided for @cyocCreationBodyTypeThick.
  ///
  /// In en, this message translates to:
  /// **'Thick'**
  String get cyocCreationBodyTypeThick;

  /// No description provided for @cyocCreationBodyTypeCurvy.
  ///
  /// In en, this message translates to:
  /// **'Curvy'**
  String get cyocCreationBodyTypeCurvy;

  /// No description provided for @cyocCreationBodyTypePlusSize.
  ///
  /// In en, this message translates to:
  /// **'Plus size'**
  String get cyocCreationBodyTypePlusSize;

  /// No description provided for @cyocCreationBodyTypeMuscular.
  ///
  /// In en, this message translates to:
  /// **'Muscular'**
  String get cyocCreationBodyTypeMuscular;

  /// No description provided for @cyocCreationBodyTypeBodybuilder.
  ///
  /// In en, this message translates to:
  /// **'Bodybuilder'**
  String get cyocCreationBodyTypeBodybuilder;

  /// No description provided for @cyocCreationBodyTypeDadBod.
  ///
  /// In en, this message translates to:
  /// **'Dad bod'**
  String get cyocCreationBodyTypeDadBod;

  /// No description provided for @cyocCreationBodyTypeBear.
  ///
  /// In en, this message translates to:
  /// **'Bear'**
  String get cyocCreationBodyTypeBear;

  /// No description provided for @cyocCreationHairStyleStraight.
  ///
  /// In en, this message translates to:
  /// **'Straight'**
  String get cyocCreationHairStyleStraight;

  /// No description provided for @cyocCreationHairStyleWavy.
  ///
  /// In en, this message translates to:
  /// **'Wavy'**
  String get cyocCreationHairStyleWavy;

  /// No description provided for @cyocCreationHairStyleCurly.
  ///
  /// In en, this message translates to:
  /// **'Curly'**
  String get cyocCreationHairStyleCurly;

  /// No description provided for @cyocCreationHairStylePonytail.
  ///
  /// In en, this message translates to:
  /// **'Ponytail'**
  String get cyocCreationHairStylePonytail;

  /// No description provided for @cyocCreationHairStyleBun.
  ///
  /// In en, this message translates to:
  /// **'Bun'**
  String get cyocCreationHairStyleBun;

  /// No description provided for @cyocCreationHairStyleBraids.
  ///
  /// In en, this message translates to:
  /// **'Braids'**
  String get cyocCreationHairStyleBraids;

  /// No description provided for @cyocCreationHairStyleShort.
  ///
  /// In en, this message translates to:
  /// **'Short'**
  String get cyocCreationHairStyleShort;

  /// No description provided for @cyocCreationHairStyleBuzzcut.
  ///
  /// In en, this message translates to:
  /// **'Buzzcut'**
  String get cyocCreationHairStyleBuzzcut;

  /// No description provided for @cyocCreationHairStyleAfro.
  ///
  /// In en, this message translates to:
  /// **'Afro'**
  String get cyocCreationHairStyleAfro;

  /// No description provided for @cyocCreationHairStylePigtails.
  ///
  /// In en, this message translates to:
  /// **'Pigtails'**
  String get cyocCreationHairStylePigtails;

  /// No description provided for @cyocCreationHairStyleHijab.
  ///
  /// In en, this message translates to:
  /// **'Hijab'**
  String get cyocCreationHairStyleHijab;

  /// No description provided for @cyocCreationHairStyleBald.
  ///
  /// In en, this message translates to:
  /// **'Bald'**
  String get cyocCreationHairStyleBald;

  /// No description provided for @cyocCreationHairStyleFade.
  ///
  /// In en, this message translates to:
  /// **'Fade'**
  String get cyocCreationHairStyleFade;

  /// No description provided for @cyocCreationHairStyleSlickedBack.
  ///
  /// In en, this message translates to:
  /// **'Slicked back'**
  String get cyocCreationHairStyleSlickedBack;

  /// No description provided for @cyocCreationHairStyleManBun.
  ///
  /// In en, this message translates to:
  /// **'Man bun'**
  String get cyocCreationHairStyleManBun;

  /// No description provided for @cyocCreationHairStyleLong.
  ///
  /// In en, this message translates to:
  /// **'Long'**
  String get cyocCreationHairStyleLong;

  /// No description provided for @cyocCreationFacialHairCleanShaven.
  ///
  /// In en, this message translates to:
  /// **'Clean-shaven'**
  String get cyocCreationFacialHairCleanShaven;

  /// No description provided for @cyocCreationFacialHairStubble.
  ///
  /// In en, this message translates to:
  /// **'Stubble'**
  String get cyocCreationFacialHairStubble;

  /// No description provided for @cyocCreationFacialHairShortBeard.
  ///
  /// In en, this message translates to:
  /// **'Short beard'**
  String get cyocCreationFacialHairShortBeard;

  /// No description provided for @cyocCreationFacialHairFullBeard.
  ///
  /// In en, this message translates to:
  /// **'Full beard'**
  String get cyocCreationFacialHairFullBeard;

  /// No description provided for @cyocCreationFacialHairMustache.
  ///
  /// In en, this message translates to:
  /// **'Mustache'**
  String get cyocCreationFacialHairMustache;

  /// No description provided for @cyocCreationFacialHairGoatee.
  ///
  /// In en, this message translates to:
  /// **'Goatee'**
  String get cyocCreationFacialHairGoatee;

  /// No description provided for @cyocCreationHairColorBlonde.
  ///
  /// In en, this message translates to:
  /// **'Blonde'**
  String get cyocCreationHairColorBlonde;

  /// No description provided for @cyocCreationHairColorBrunette.
  ///
  /// In en, this message translates to:
  /// **'Brunette'**
  String get cyocCreationHairColorBrunette;

  /// No description provided for @cyocCreationHairColorBlack.
  ///
  /// In en, this message translates to:
  /// **'Black'**
  String get cyocCreationHairColorBlack;

  /// No description provided for @cyocCreationHairColorRed.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get cyocCreationHairColorRed;

  /// No description provided for @cyocCreationHairColorGinger.
  ///
  /// In en, this message translates to:
  /// **'Ginger'**
  String get cyocCreationHairColorGinger;

  /// No description provided for @cyocCreationHairColorPink.
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get cyocCreationHairColorPink;

  /// No description provided for @cyocCreationHairColorBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get cyocCreationHairColorBlue;

  /// No description provided for @cyocCreationHairColorGrey.
  ///
  /// In en, this message translates to:
  /// **'Grey'**
  String get cyocCreationHairColorGrey;

  /// No description provided for @cyocCreationEyeColorBrown.
  ///
  /// In en, this message translates to:
  /// **'Brown'**
  String get cyocCreationEyeColorBrown;

  /// No description provided for @cyocCreationEyeColorBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get cyocCreationEyeColorBlue;

  /// No description provided for @cyocCreationEyeColorGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get cyocCreationEyeColorGreen;

  /// No description provided for @cyocCreationEyeColorHazel.
  ///
  /// In en, this message translates to:
  /// **'Hazel'**
  String get cyocCreationEyeColorHazel;

  /// No description provided for @cyocCreationEyeColorGray.
  ///
  /// In en, this message translates to:
  /// **'Gray'**
  String get cyocCreationEyeColorGray;

  /// No description provided for @cyocCreationPersonalitySweetheart.
  ///
  /// In en, this message translates to:
  /// **'Sweetheart'**
  String get cyocCreationPersonalitySweetheart;

  /// No description provided for @cyocCreationPersonalityTease.
  ///
  /// In en, this message translates to:
  /// **'Tease'**
  String get cyocCreationPersonalityTease;

  /// No description provided for @cyocCreationPersonalityDominant.
  ///
  /// In en, this message translates to:
  /// **'Dominant'**
  String get cyocCreationPersonalityDominant;

  /// No description provided for @cyocCreationPersonalitySubmissive.
  ///
  /// In en, this message translates to:
  /// **'Submissive'**
  String get cyocCreationPersonalitySubmissive;

  /// No description provided for @cyocCreationPersonalityMysterious.
  ///
  /// In en, this message translates to:
  /// **'Mysterious'**
  String get cyocCreationPersonalityMysterious;

  /// No description provided for @cyocCreationPersonalityNympho.
  ///
  /// In en, this message translates to:
  /// **'Nympho'**
  String get cyocCreationPersonalityNympho;

  /// No description provided for @cyocCreationPersonalityRebel.
  ///
  /// In en, this message translates to:
  /// **'Rebel'**
  String get cyocCreationPersonalityRebel;

  /// No description provided for @cyocCreationPersonalityIntellectual.
  ///
  /// In en, this message translates to:
  /// **'Intellectual'**
  String get cyocCreationPersonalityIntellectual;

  /// No description provided for @cyocCreationPersonalityFreeSpirit.
  ///
  /// In en, this message translates to:
  /// **'Free spirit'**
  String get cyocCreationPersonalityFreeSpirit;

  /// No description provided for @cyocCreationPersonalitySweetheartDescription.
  ///
  /// In en, this message translates to:
  /// **'Soft heart, endless affection. Your happiness comes first'**
  String get cyocCreationPersonalitySweetheartDescription;

  /// No description provided for @cyocCreationPersonalityTeaseDescription.
  ///
  /// In en, this message translates to:
  /// **'Always one step out of reach. Loves watching you want more'**
  String get cyocCreationPersonalityTeaseDescription;

  /// No description provided for @cyocCreationPersonalityDominantDescription.
  ///
  /// In en, this message translates to:
  /// **'Sets the pace and the rules. All you have to do is follow'**
  String get cyocCreationPersonalityDominantDescription;

  /// No description provided for @cyocCreationPersonalitySubmissiveDescription.
  ///
  /// In en, this message translates to:
  /// **'Yours to command, no limits asked. Your wish comes first'**
  String get cyocCreationPersonalitySubmissiveDescription;

  /// No description provided for @cyocCreationPersonalityMysteriousDescription.
  ///
  /// In en, this message translates to:
  /// **'Never tells you everything. Every answer opens another question'**
  String get cyocCreationPersonalityMysteriousDescription;

  /// No description provided for @cyocCreationPersonalityNymphoDescription.
  ///
  /// In en, this message translates to:
  /// **'Insatiable and shameless about it. Wants you, always'**
  String get cyocCreationPersonalityNymphoDescription;

  /// No description provided for @cyocCreationPersonalityRebelDescription.
  ///
  /// In en, this message translates to:
  /// **'Breaks every rule and dares you to keep up. Fearless by default'**
  String get cyocCreationPersonalityRebelDescription;

  /// No description provided for @cyocCreationPersonalityIntellectualDescription.
  ///
  /// In en, this message translates to:
  /// **'Sharp mind, slow burn. Gets inside your head first'**
  String get cyocCreationPersonalityIntellectualDescription;

  /// No description provided for @cyocCreationPersonalityFreeSpiritDescription.
  ///
  /// In en, this message translates to:
  /// **'No plans, no limits, no regrets. Up for anything, anytime'**
  String get cyocCreationPersonalityFreeSpiritDescription;

  /// Toast shown when character photo generation fails
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t generate the photo. Please try again'**
  String get cyocCreationGenerationFailedToast;

  /// Toast shown when saving the created character fails
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t create the character. Please try again'**
  String get cyocCreationCreateFailedToast;
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
