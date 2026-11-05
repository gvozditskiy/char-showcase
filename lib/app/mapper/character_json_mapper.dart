import 'package:character_data/character_data.dart';

class CharacterJsonMapper {
  const CharacterJsonMapper();

  CharacterModel toModel(Map<String, dynamic> json) {
    final avatar = json['avatar'] as String?;
    return CharacterModel(
      id: json['id'] as String,
      name: json['name'] as String,
      fullName: json['fullName'] as String,
      age: json['age'] as int,
      gender: _gender(json['gender']),
      cyoc: json['cyoc'] as bool? ?? false,
      avatar: avatar != null ? AvatarModel(image: avatar) : null,
      photos: List<String>.from(json['photos'] as List<dynamic>),
      hasFeedLike: json['hasFeedLike'] as bool? ?? false,
      tags: List<String>.from(json['interests'] as List<dynamic>? ?? const []),
      publicBio: json['bio'] as String,
      attributes: _attributes(json['attributes']),
    );
  }

  List<CharacterGender> _gender(Object? value) {
    final values = value is List<dynamic> ? value : [value];
    return values.map((item) => _genderOf(item as String?)).toList();
  }

  CharacterGender _genderOf(String? value) => switch (value) {
    'MAN' || 'man' => CharacterGender.male,
    'WOMAN' || 'woman' => CharacterGender.female,
    'OTHER' || 'other' => CharacterGender.other,
    'NON_BINARY' || 'nonBinary' => CharacterGender.nonBinary,
    _ => CharacterGender.unspecified,
  };

  Map<String, String>? _attributes(Object? value) {
    if (value == null) {
      return null;
    }
    return (value as Map<String, dynamic>).map((key, label) => MapEntry(key, label as String));
  }
}
