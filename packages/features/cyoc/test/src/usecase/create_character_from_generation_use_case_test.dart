import 'package:character_data/character_data.dart';
import 'package:cyoc/src/models/cyoc_character_choice.dart';
import 'package:cyoc/src/models/cyoc_generation_result.dart';
import 'package:cyoc/src/usecase/create_character_from_generation_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockCharacterRepository extends Mock implements CharacterRepository {}

class _FakeCharacterModel extends Fake implements CharacterModel {}

void main() {
  setUpAll(() => registerFallbackValue(_FakeCharacterModel()));

  test('creates a cyoc character with the generated avatar and chosen attributes', () async {
    final repository = _MockCharacterRepository();
    when(
      () => repository.createCharacterFromGeneration(any()),
    ).thenAnswer((invocation) async => invocation.positionalArguments.first as CharacterModel);
    const avatar = AvatarModel(image: 'packages/cyoc/assets/options/pers_m_real_rebel.webp');

    final created = await CreateCharacterFromGenerationUseCase(repository)(
      choice: const CyocCharacterChoice(gender: CharacterGender.male, age: 30, name: '  Leo '),
      result: const CyocGenerationResult(generationId: 'gen-1', avatar: avatar),
    );

    final saved =
        verify(() => repository.createCharacterFromGeneration(captureAny())).captured.single
            as CharacterModel;
    expect(saved, created);
    expect(saved.id, 'gen-1');
    expect(saved.name, 'Leo');
    expect(saved.age, 30);
    expect(saved.gender, [CharacterGender.male]);
    expect(saved.cyoc, isTrue);
    expect(saved.avatar, avatar);
  });
}
