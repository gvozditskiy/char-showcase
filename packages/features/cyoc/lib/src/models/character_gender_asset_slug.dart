import 'package:character_data/character_data.dart';

extension CharacterGenderAssetSlug on CharacterGender {
  String get assetGenderSlug => this == CharacterGender.male ? 'm' : 'f';

  String get assetKey => switch (this) {
    CharacterGender.male => 'gender_m.webp',
    CharacterGender.female => 'gender_f.webp',
    _ => 'gender_n.webp',
  };
}
