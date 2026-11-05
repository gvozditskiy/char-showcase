import '../models/cyoc_character_choice.dart';
import '../models/cyoc_generation_result.dart';

class CyocGenerationCancelledException implements Exception {
  const CyocGenerationCancelledException();
}

abstract interface class CyocGenerationService {
  Future<CyocGenerationResult> generate(CyocCharacterChoice choice);

  Future<CyocGenerationResult> regenerate(String generationId);

  Future<void> cancel();
}
