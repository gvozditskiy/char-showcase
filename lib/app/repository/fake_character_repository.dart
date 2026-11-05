import 'dart:async';
import 'dart:convert';

import 'package:character_data/character_data.dart';
import 'package:flutter/services.dart';

import '../mapper/character_json_mapper.dart';

class FakeCharacterRepository implements CharacterRepository {
  FakeCharacterRepository(
    this._mapper, {
    AssetBundle? bundle,
    Duration fetchDelay = const Duration(milliseconds: 300),
  }) : _bundle = bundle ?? rootBundle,
       _fetchDelay = fetchDelay;

  static const _assetPath = 'packages/character_data/assets/characters/characters.json';

  final CharacterJsonMapper _mapper;
  final AssetBundle _bundle;
  final Duration _fetchDelay;
  final _controller = StreamController<List<CharacterModel>>.broadcast();
  final List<CharacterModel> _created = [];
  Future<List<CharacterModel>>? _characters;

  @override
  Future<CharacterFeedModel> fetchCharacterFeed({required int limit, String? cursor}) async {
    await Future<void>.delayed(_fetchDelay);
    final characters = await _load();
    final start = int.tryParse(cursor ?? '') ?? 0;
    final end = start + limit;
    final page = characters.skip(start).take(limit).toList();
    return CharacterFeedModel(
      characters: cursor == null ? [..._created, ...page] : page,
      nextCursor: end < characters.length ? end.toString() : null,
    );
  }

  @override
  Future<void> likeFeedCharacter(String characterId) => _setLike(characterId, liked: true);

  @override
  Future<void> unlikeFeedCharacter(String characterId) => _setLike(characterId, liked: false);

  @override
  Future<CharacterModel?> getCharacter(String characterId) async {
    final characters = await _all();
    return characters.where((character) => character.id == characterId).firstOrNull;
  }

  @override
  Stream<List<CharacterModel>> observeAllCharacters() => Stream.multi((listener) {
    final updates = _controller.stream.listen(listener.add, onError: listener.addError);
    listener.onCancel = updates.cancel;
    unawaited(_all().then(listener.add, onError: listener.addError));
  });

  @override
  Future<CharacterModel> createCharacterFromGeneration(CharacterModel character) async {
    final created = character.copyWith(cyoc: true);
    _created.insert(0, created);
    _controller.add(await _all());
    return created;
  }

  Future<List<CharacterModel>> _load() =>
      _characters ??= _decode().onError<Object>((error, stackTrace) {
        _characters = null;
        Error.throwWithStackTrace(error, stackTrace);
      });

  Future<List<CharacterModel>> _decode() async {
    final raw = json.decode(await _bundle.loadString(_assetPath)) as List<dynamic>;
    return raw.map((item) => _mapper.toModel(item as Map<String, dynamic>)).toList();
  }

  Future<List<CharacterModel>> _all() async {
    final loaded = await _load();
    return List.unmodifiable([..._created, ...loaded]);
  }

  Future<void> _setLike(String characterId, {required bool liked}) async {
    final characters = await _load();
    final list = _created.any((character) => character.id == characterId) ? _created : characters;
    final index = list.indexWhere((character) => character.id == characterId);
    if (index == -1) {
      return;
    }
    list[index] = list[index].copyWith(hasFeedLike: liked);
    _controller.add(await _all());
  }
}
