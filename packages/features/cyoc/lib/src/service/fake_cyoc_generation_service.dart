import 'dart:async';

import 'package:character_data/character_data.dart';

import '../models/builder_attributes.dart';
import '../models/cyoc_character_choice.dart';
import '../models/cyoc_generation_result.dart';
import 'cyoc_assets_service.dart';
import 'cyoc_generation_service.dart';

class FakeCyocGenerationService implements CyocGenerationService {
  FakeCyocGenerationService(this._assetsService, {Duration delay = defaultDelay}) : _delay = delay;

  static const defaultDelay = Duration(seconds: 3);

  final CyocAssetsService _assetsService;
  final Duration _delay;
  final Map<String, ({CyocCharacterChoice choice, int attempt})> _generations = {};
  Timer? _timer;
  Completer<CyocGenerationResult>? _pending;

  @override
  Future<CyocGenerationResult> generate(CyocCharacterChoice choice) =>
      _produce(choice: choice, attempt: 0);

  @override
  Future<CyocGenerationResult> regenerate(String generationId) {
    final generation = _generations[generationId];
    if (generation == null) {
      return Future.error(StateError('Unknown generation $generationId'));
    }
    return _produce(choice: generation.choice, attempt: generation.attempt + 1);
  }

  @override
  Future<void> cancel() async {
    _timer?.cancel();
    final pending = _pending;
    _pending = null;
    if (pending != null && !pending.isCompleted) {
      pending.completeError(const CyocGenerationCancelledException());
    }
  }

  Future<CyocGenerationResult> _produce({
    required CyocCharacterChoice choice,
    required int attempt,
  }) {
    final completer = Completer<CyocGenerationResult>();
    _pending = completer;
    _timer = Timer(_delay, () {
      final generationId = 'generation_${DateTime.now().microsecondsSinceEpoch}';
      _generations[generationId] = (choice: choice, attempt: attempt);
      completer.complete(
        CyocGenerationResult(
          generationId: generationId,
          avatar: AvatarModel(image: _assetsService.getAsset(_imageKey(choice, attempt))),
        ),
      );
    });
    return completer.future;
  }

  String _imageKey(CyocCharacterChoice choice, int attempt) {
    const personalities = CyocPersonality.values;
    final personality = choice.personality;
    final base = personality == null ? 0 : personalities.indexOf(personality);
    return personalities[(base + attempt) % personalities.length].assetKey(
      gender: choice.gender,
      style: choice.style,
    );
  }
}
