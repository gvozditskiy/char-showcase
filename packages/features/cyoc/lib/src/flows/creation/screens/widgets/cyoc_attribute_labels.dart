import '../../../../../l10n/l10n.dart';
import '../../../../models/builder_attributes.dart';

extension CyocEthnicityLabel on CyocEthnicity {
  String label(AppLocalizations strings) => switch (this) {
    CyocEthnicity.white => strings.cyocCreationEthnicityWhite,
    CyocEthnicity.latina => strings.cyocCreationEthnicityLatina,
    CyocEthnicity.latino => strings.cyocCreationEthnicityLatino,
    CyocEthnicity.black => strings.cyocCreationEthnicityBlack,
    CyocEthnicity.eastAsian => strings.cyocCreationEthnicityEastAsian,
    CyocEthnicity.southAsian => strings.cyocCreationEthnicitySouthAsian,
    CyocEthnicity.middleEastern => strings.cyocCreationEthnicityMiddleEastern,
    CyocEthnicity.nordic => strings.cyocCreationEthnicityNordic,
    CyocEthnicity.slavic => strings.cyocCreationEthnicitySlavic,
  };
}

extension CyocBodyTypeLabel on CyocBodyType {
  String label(AppLocalizations strings) => switch (this) {
    CyocBodyType.natural => strings.cyocCreationBodyTypeNatural,
    CyocBodyType.slim => strings.cyocCreationBodyTypeSlim,
    CyocBodyType.athletic => strings.cyocCreationBodyTypeAthletic,
    CyocBodyType.thick => strings.cyocCreationBodyTypeThick,
    CyocBodyType.curvy => strings.cyocCreationBodyTypeCurvy,
    CyocBodyType.plusSize => strings.cyocCreationBodyTypePlusSize,
    CyocBodyType.muscular => strings.cyocCreationBodyTypeMuscular,
    CyocBodyType.bodybuilder => strings.cyocCreationBodyTypeBodybuilder,
    CyocBodyType.dadBod => strings.cyocCreationBodyTypeDadBod,
    CyocBodyType.bear => strings.cyocCreationBodyTypeBear,
  };
}

extension CyocHairStyleLabel on CyocHairStyle {
  String label(AppLocalizations strings) => switch (this) {
    CyocHairStyle.straight => strings.cyocCreationHairStyleStraight,
    CyocHairStyle.wavy => strings.cyocCreationHairStyleWavy,
    CyocHairStyle.curly => strings.cyocCreationHairStyleCurly,
    CyocHairStyle.ponytail => strings.cyocCreationHairStylePonytail,
    CyocHairStyle.bun => strings.cyocCreationHairStyleBun,
    CyocHairStyle.braids => strings.cyocCreationHairStyleBraids,
    CyocHairStyle.short => strings.cyocCreationHairStyleShort,
    CyocHairStyle.buzzCut => strings.cyocCreationHairStyleBuzzcut,
    CyocHairStyle.afro => strings.cyocCreationHairStyleAfro,
    CyocHairStyle.pigtails => strings.cyocCreationHairStylePigtails,
    CyocHairStyle.hijab => strings.cyocCreationHairStyleHijab,
    CyocHairStyle.bald => strings.cyocCreationHairStyleBald,
    CyocHairStyle.fade => strings.cyocCreationHairStyleFade,
    CyocHairStyle.slickedBack => strings.cyocCreationHairStyleSlickedBack,
    CyocHairStyle.manBun => strings.cyocCreationHairStyleManBun,
    CyocHairStyle.long => strings.cyocCreationHairStyleLong,
  };
}

extension CyocFacialHairLabel on CyocFacialHair {
  String label(AppLocalizations strings) => switch (this) {
    CyocFacialHair.cleanShaven => strings.cyocCreationFacialHairCleanShaven,
    CyocFacialHair.stubble => strings.cyocCreationFacialHairStubble,
    CyocFacialHair.shortBeard => strings.cyocCreationFacialHairShortBeard,
    CyocFacialHair.fullBeard => strings.cyocCreationFacialHairFullBeard,
    CyocFacialHair.mustache => strings.cyocCreationFacialHairMustache,
    CyocFacialHair.goatee => strings.cyocCreationFacialHairGoatee,
  };
}

extension CyocHairColorLabel on CyocHairColor {
  String label(AppLocalizations strings) => switch (this) {
    CyocHairColor.blonde => strings.cyocCreationHairColorBlonde,
    CyocHairColor.brunette => strings.cyocCreationHairColorBrunette,
    CyocHairColor.black => strings.cyocCreationHairColorBlack,
    CyocHairColor.red => strings.cyocCreationHairColorRed,
    CyocHairColor.ginger => strings.cyocCreationHairColorGinger,
    CyocHairColor.pink => strings.cyocCreationHairColorPink,
    CyocHairColor.blue => strings.cyocCreationHairColorBlue,
    CyocHairColor.grey => strings.cyocCreationHairColorGrey,
  };
}

extension CyocEyeColorLabel on CyocEyeColor {
  String label(AppLocalizations strings) => switch (this) {
    CyocEyeColor.brown => strings.cyocCreationEyeColorBrown,
    CyocEyeColor.blue => strings.cyocCreationEyeColorBlue,
    CyocEyeColor.green => strings.cyocCreationEyeColorGreen,
    CyocEyeColor.hazel => strings.cyocCreationEyeColorHazel,
    CyocEyeColor.gray => strings.cyocCreationEyeColorGray,
  };
}

extension CyocPersonalityLabel on CyocPersonality {
  String label(AppLocalizations strings) => switch (this) {
    CyocPersonality.sweetheart => strings.cyocCreationPersonalitySweetheart,
    CyocPersonality.tease => strings.cyocCreationPersonalityTease,
    CyocPersonality.dominant => strings.cyocCreationPersonalityDominant,
    CyocPersonality.submissive => strings.cyocCreationPersonalitySubmissive,
    CyocPersonality.mysterious => strings.cyocCreationPersonalityMysterious,
    CyocPersonality.nympho => strings.cyocCreationPersonalityNympho,
    CyocPersonality.rebel => strings.cyocCreationPersonalityRebel,
    CyocPersonality.intellectual => strings.cyocCreationPersonalityIntellectual,
    CyocPersonality.freeSpirit => strings.cyocCreationPersonalityFreeSpirit,
  };

  String description(AppLocalizations strings) => switch (this) {
    CyocPersonality.sweetheart => strings.cyocCreationPersonalitySweetheartDescription,
    CyocPersonality.tease => strings.cyocCreationPersonalityTeaseDescription,
    CyocPersonality.dominant => strings.cyocCreationPersonalityDominantDescription,
    CyocPersonality.submissive => strings.cyocCreationPersonalitySubmissiveDescription,
    CyocPersonality.mysterious => strings.cyocCreationPersonalityMysteriousDescription,
    CyocPersonality.nympho => strings.cyocCreationPersonalityNymphoDescription,
    CyocPersonality.rebel => strings.cyocCreationPersonalityRebelDescription,
    CyocPersonality.intellectual => strings.cyocCreationPersonalityIntellectualDescription,
    CyocPersonality.freeSpirit => strings.cyocCreationPersonalityFreeSpiritDescription,
  };
}
