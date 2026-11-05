import 'package:character_data/character_data.dart';

import 'character_gender_asset_slug.dart';

enum CyocPhotoStyle {
  realistic('REALISTIC'),
  anime('ANIME');

  const CyocPhotoStyle(this.serverId);

  final String serverId;

  String get assetSlug => this == CyocPhotoStyle.realistic ? 'real' : 'anime';

  String assetKey({required CharacterGender gender}) =>
      'styl_${gender.assetGenderSlug}_$assetSlug.webp';
}
