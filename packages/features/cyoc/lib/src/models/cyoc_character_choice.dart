import 'package:character_data/character_data.dart';
import 'package:equatable/equatable.dart';

import 'builder_attributes.dart';
import 'cyoc_photo_style.dart';

class CyocCharacterChoice extends Equatable {
  const CyocCharacterChoice({
    this.gender = CharacterGender.female,
    this.age = defaultAge,
    this.style = CyocPhotoStyle.realistic,
    this.name = '',
    this.ethnicity,
    this.bodyType,
    this.hairStyle,
    this.hairColor,
    this.eyeColor,
    this.facialHair,
    this.personality,
  });

  static const int defaultAge = 25;
  static const int minAge = 21;
  static const int maxAge = 99;

  final CharacterGender gender;
  final int age;
  final CyocPhotoStyle style;
  final String name;
  final CyocEthnicity? ethnicity;
  final CyocBodyType? bodyType;
  final CyocHairStyle? hairStyle;
  final CyocHairColor? hairColor;
  final CyocEyeColor? eyeColor;
  final CyocFacialHair? facialHair;
  final CyocPersonality? personality;

  CyocCharacterChoice copyWith({
    CharacterGender? gender,
    int? age,
    CyocPhotoStyle? style,
    String? name,
    CyocEthnicity? ethnicity,
    CyocBodyType? bodyType,
    CyocHairStyle? hairStyle,
    CyocHairColor? hairColor,
    CyocEyeColor? eyeColor,
    CyocFacialHair? facialHair,
    CyocPersonality? personality,
  }) {
    return CyocCharacterChoice(
      gender: gender ?? this.gender,
      age: age ?? this.age,
      style: style ?? this.style,
      name: name ?? this.name,
      ethnicity: ethnicity ?? this.ethnicity,
      bodyType: bodyType ?? this.bodyType,
      hairStyle: hairStyle ?? this.hairStyle,
      hairColor: hairColor ?? this.hairColor,
      eyeColor: eyeColor ?? this.eyeColor,
      facialHair: facialHair ?? this.facialHair,
      personality: personality ?? this.personality,
    );
  }

  CyocCharacterChoice withGender(CharacterGender newGender) {
    return CyocCharacterChoice(
      gender: newGender,
      age: age,
      style: style,
      name: name,
      ethnicity: ethnicity?.forGender(newGender),
      bodyType: CyocBodyType.valuesFor(newGender).contains(bodyType) ? bodyType : null,
      hairStyle: CyocHairStyle.valuesFor(newGender).contains(hairStyle) ? hairStyle : null,
      hairColor: hairColor,
      eyeColor: eyeColor,
      facialHair: newGender == CharacterGender.male ? facialHair : null,
      personality: personality,
    );
  }

  CyocCharacterChoice withBuilderDefaults() {
    return CyocCharacterChoice(
      gender: gender,
      age: age,
      style: style,
      name: name,
      ethnicity: ethnicity ?? CyocEthnicity.valuesFor(gender).first,
      bodyType: bodyType ?? CyocBodyType.valuesFor(gender).first,
      hairStyle: hairStyle ?? CyocHairStyle.valuesFor(gender).first,
      hairColor: hairColor ?? CyocHairColor.values.first,
      eyeColor: eyeColor ?? CyocEyeColor.values.first,
      facialHair: gender == CharacterGender.male ? facialHair ?? CyocFacialHair.values.first : null,
      personality: personality ?? CyocPersonality.values.first,
    );
  }

  @override
  List<Object?> get props => [
    gender,
    age,
    style,
    name,
    ethnicity,
    bodyType,
    hairStyle,
    hairColor,
    eyeColor,
    facialHair,
    personality,
  ];
}
