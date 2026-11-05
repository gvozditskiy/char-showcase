import 'package:character_data/character_data.dart';
import 'package:cyoc/src/models/builder_attributes.dart';
import 'package:cyoc/src/models/cyoc_character_choice.dart';
import 'package:cyoc/src/models/cyoc_photo_style.dart';
import 'package:cyoc/src/service/cyoc_generation_service.dart';
import 'package:cyoc/src/service/fake_cyoc_assets_service.dart';
import 'package:cyoc/src/service/fake_cyoc_generation_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakeCyocGenerationService service;

  setUp(() {
    service = FakeCyocGenerationService(const FakeCyocAssetsService(), delay: Duration.zero);
  });

  test('picks the personality image matching gender and style', () async {
    const choice = CyocCharacterChoice(
      gender: CharacterGender.male,
      style: CyocPhotoStyle.anime,
      personality: CyocPersonality.rebel,
    );

    final first = await service.generate(choice);
    final second = await service.generate(choice);

    expect(first.avatarUrl, 'packages/cyoc/assets/options/pers_m_anime_rebel.webp');
    expect(second.avatarUrl, first.avatarUrl);
  });

  test('falls back to the first personality image of the gender and style', () async {
    final result = await service.generate(const CyocCharacterChoice());

    expect(result.avatarUrl, 'packages/cyoc/assets/options/pers_f_real_sweetheart.webp');
  });

  test('regenerate moves to the next personality image of the same gender and style', () async {
    const choice = CyocCharacterChoice(personality: CyocPersonality.freeSpirit);
    final generated = await service.generate(choice);

    final regenerated = await service.regenerate(generated.generationId);

    expect(regenerated.avatarUrl, 'packages/cyoc/assets/options/pers_f_real_sweetheart.webp');
  });

  test('cancel fails the pending generation', () async {
    final slow = FakeCyocGenerationService(const FakeCyocAssetsService());
    final cancelled = expectLater(
      slow.generate(const CyocCharacterChoice()),
      throwsA(isA<CyocGenerationCancelledException>()),
    );

    await slow.cancel();

    await cancelled;
  });
}
