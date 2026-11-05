import 'package:character_data/character_data.dart';

import 'character_gender_asset_slug.dart';
import 'cyoc_photo_style.dart';

enum CyocEthnicity {
  white('WHITE', 'white'),
  latina('LATINA', 'latina'),
  latino('LATINO', 'latina'),
  black('BLACK', 'black'),
  eastAsian('EAST_ASIAN', 'east_asian'),
  southAsian('SOUTH_ASIAN', 'south_asian'),
  middleEastern('MIDDLE_EASTERN', 'middle_eastern'),
  nordic('NORDIC', 'nordic'),
  slavic('SLAVIC', 'slavic');

  const CyocEthnicity(this.serverId, this.assetSlug);

  final String serverId;
  final String assetSlug;

  static const femaleValues = [
    white,
    latina,
    black,
    eastAsian,
    southAsian,
    middleEastern,
    nordic,
    slavic,
  ];
  static const maleValues = [
    white,
    latino,
    black,
    eastAsian,
    southAsian,
    middleEastern,
    nordic,
    slavic,
  ];

  static List<CyocEthnicity> valuesFor(CharacterGender gender) =>
      gender == CharacterGender.male ? maleValues : femaleValues;

  CyocEthnicity forGender(CharacterGender gender) {
    if (gender == CharacterGender.male) {
      return this == latina ? latino : this;
    }
    return this == latino ? latina : this;
  }

  String assetKey({required CharacterGender gender, required CyocPhotoStyle style}) =>
      'eth_${gender.assetGenderSlug}_${style.assetSlug}_$assetSlug.webp';
}

enum CyocBodyType {
  natural('NATURAL', 'natural'),
  slim('SLIM', 'slim'),
  athletic('ATHLETIC', 'athletic'),
  thick('THICK', 'thick'),
  curvy('CURVY', 'curvy'),
  plusSize('PLUS_SIZE', 'plus_size'),
  muscular('MUSCULAR', 'muscular'),
  bodybuilder('BODYBUILDER', 'bodybuilder'),
  dadBod('DAD_BOD', 'dadbod'),
  bear('BEAR', 'bear');

  const CyocBodyType(this.serverId, this.assetSlug);

  final String serverId;
  final String assetSlug;

  static const femaleValues = [natural, slim, athletic, thick, curvy, plusSize, muscular];
  static const maleValues = [slim, natural, athletic, bodybuilder, dadBod, bear];

  static List<CyocBodyType> valuesFor(CharacterGender gender) =>
      gender == CharacterGender.male ? maleValues : femaleValues;

  String assetKey({required CharacterGender gender, required CyocPhotoStyle style}) =>
      'body_${gender.assetGenderSlug}_${style.assetSlug}_$assetSlug.webp';
}

enum CyocHairStyle {
  straight('STRAIGHT', 'straight'),
  wavy('WAVY', 'wavy'),
  curly('CURLY', 'curly'),
  ponytail('PONYTAIL', 'ponytail'),
  bun('BUN', 'bun'),
  braids('BRAIDS', 'braids'),
  short('SHORT', 'short'),
  buzzCut('BUZZCUT', 'buzzcut'),
  afro('AFRO', 'afro'),
  pigtails('PIGTAILS', 'pigtails'),
  hijab('HIJAB', 'hijab'),
  bald('BALD', 'bald'),
  fade('FADE', 'fade'),
  slickedBack('SLICKED_BACK', 'slicked_back'),
  manBun('MAN_BUN', 'manbun'),
  long('LONG', 'long');

  const CyocHairStyle(this.serverId, this.assetSlug);

  final String serverId;
  final String assetSlug;

  static const femaleValues = [
    straight,
    wavy,
    curly,
    ponytail,
    bun,
    buzzCut,
    braids,
    short,
    afro,
    pigtails,
    hijab,
  ];
  static const maleValues = [
    short,
    buzzCut,
    fade,
    slickedBack,
    curly,
    afro,
    long,
    manBun,
    braids,
    bald,
  ];

  static List<CyocHairStyle> valuesFor(CharacterGender gender) =>
      gender == CharacterGender.male ? maleValues : femaleValues;

  String assetKey({required CharacterGender gender, required CyocPhotoStyle style}) =>
      'hair_${gender.assetGenderSlug}_${style.assetSlug}_$assetSlug.webp';
}

enum CyocFacialHair {
  cleanShaven('CLEAN_SHAVEN', 'clean_shaven'),
  stubble('STUBBLE', 'stubble'),
  shortBeard('SHORT_BEARD', 'shortbeard'),
  fullBeard('FULL_BEARD', 'fullbeard'),
  mustache('MUSTACHE', 'mustache'),
  goatee('GOATEE', 'goatee');

  const CyocFacialHair(this.serverId, this.assetSlug);

  final String serverId;
  final String assetSlug;

  String assetKey({required CyocPhotoStyle style}) => 'beard_m_${style.assetSlug}_$assetSlug.webp';
}

enum CyocHairColor {
  blonde('BLONDE', 'blonde'),
  brunette('BRUNETTE', 'brunette'),
  black('BLACK', 'black'),
  red('RED', 'red'),
  ginger('GINGER', 'ginger'),
  pink('PINK', 'pink'),
  blue('BLUE', 'blue'),
  grey('GREY', 'grey');

  const CyocHairColor(this.serverId, this.assetSlug);

  final String serverId;
  final String assetSlug;

  String assetKey({required CyocPhotoStyle style}) => 'hcol_${style.assetSlug}_$assetSlug.webp';
}

enum CyocEyeColor {
  brown('BROWN', 'brown'),
  blue('BLUE', 'blue'),
  green('GREEN', 'green'),
  hazel('HAZEL', 'hazel'),
  gray('GRAY', 'gray');

  const CyocEyeColor(this.serverId, this.assetSlug);

  final String serverId;
  final String assetSlug;

  String assetKey({required CyocPhotoStyle style}) => 'eye_${style.assetSlug}_$assetSlug.webp';
}

enum CyocPersonality {
  sweetheart('SWEETHEART', 'sweetheart'),
  tease('TEASE', 'tease'),
  dominant('DOMINANT', 'dominant'),
  submissive('SUBMISSIVE', 'submissive'),
  mysterious('MYSTERIOUS', 'mysterious'),
  nympho('NYMPHO', 'nympho'),
  rebel('REBEL', 'rebel'),
  intellectual('INTELLECTUAL', 'intellectual'),
  freeSpirit('FREE_SPIRIT', 'freespirit');

  const CyocPersonality(this.serverId, this.assetSlug);

  final String serverId;
  final String assetSlug;

  String assetKey({required CharacterGender gender, required CyocPhotoStyle style}) =>
      'pers_${gender.assetGenderSlug}_${style.assetSlug}_$assetSlug.webp';
}
