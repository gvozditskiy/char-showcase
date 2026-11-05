import 'package:character_data/character_data.dart';

abstract interface class CardsFeatureAdapter {
  Future<void> createCharacter();

  Future<void> onCharacterLiked(CharacterModel character);
}
