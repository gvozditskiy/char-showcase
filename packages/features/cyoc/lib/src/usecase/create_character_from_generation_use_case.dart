import 'package:character_data/character_data.dart';

import '../models/cyoc_character_choice.dart';
import '../models/cyoc_generation_result.dart';

class CreateCharacterFromGenerationUseCase {
  CreateCharacterFromGenerationUseCase(this._repository);

  final CharacterRepository _repository;

  Future<CharacterModel> call({
    required CyocCharacterChoice choice,
    required CyocGenerationResult result,
  }) {
    final name = choice.name.trim();
    return _repository.createCharacterFromGeneration(
      CharacterModel(
        id: result.generationId,
        name: name,
        fullName: name,
        age: choice.age,
        gender: [choice.gender],
        cyoc: true,
        avatar: result.avatar,
        photos: const [],
        publicBio: '',
      ),
    );
  }
}
