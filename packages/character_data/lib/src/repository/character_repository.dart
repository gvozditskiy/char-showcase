import '../models/character.dart';
import '../models/character_feed_model.dart';

abstract interface class CharacterRepository {
  Future<CharacterFeedModel> fetchCharacterFeed({required int limit, String? cursor});

  Future<void> likeFeedCharacter(String characterId);

  Future<void> unlikeFeedCharacter(String characterId);

  Future<CharacterModel?> getCharacter(String characterId);

  Stream<List<CharacterModel>> observeAllCharacters();

  Future<CharacterModel> createCharacterFromGeneration(CharacterModel character);
}
