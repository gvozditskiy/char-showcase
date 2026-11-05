import 'package:equatable/equatable.dart';

import 'avatar_model.dart';
import 'character_gender.dart';

class CharacterModel extends Equatable {
  const CharacterModel({
    required this.id,
    required this.name,
    required this.fullName,
    required this.age,
    required this.gender,
    required this.cyoc,
    required this.photos,
    required this.publicBio,
    this.avatar,
    this.tags = const [],
    this.hasFeedLike = false,
    this.attributes,
  });

  final String id;
  final String name;
  final String? fullName;
  final int age;
  final List<CharacterGender> gender;
  final bool cyoc;
  final String publicBio;
  final AvatarModel? avatar;
  final List<String> photos;
  final bool hasFeedLike;
  final List<String> tags;
  final Map<String, String>? attributes;

  String get title => '$name, $age';

  String? get mainImage => avatar?.image;

  List<String> get images => [mainImage ?? '', ...photos];

  CharacterModel copyWith({
    String? id,
    String? name,
    String? fullName,
    int? age,
    List<CharacterGender>? gender,
    bool? cyoc,
    AvatarModel? avatar,
    List<String>? photos,
    bool? hasFeedLike,
    List<String>? tags,
    String? publicBio,
    Map<String, String>? attributes,
  }) {
    return CharacterModel(
      id: id ?? this.id,
      name: name ?? this.name,
      fullName: fullName ?? this.fullName,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      cyoc: cyoc ?? this.cyoc,
      avatar: avatar ?? this.avatar,
      photos: photos ?? this.photos,
      hasFeedLike: hasFeedLike ?? this.hasFeedLike,
      tags: tags ?? this.tags,
      publicBio: publicBio ?? this.publicBio,
      attributes: attributes ?? this.attributes,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    fullName,
    age,
    gender,
    cyoc,
    avatar,
    photos,
    hasFeedLike,
    tags,
    publicBio,
    attributes,
  ];
}
