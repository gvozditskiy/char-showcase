import 'dart:convert';
import 'dart:io';

import 'package:char/app/mapper/character_json_mapper.dart';
import 'package:char/app/repository/fake_character_repository.dart';
import 'package:character_data/character_data.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class _FailingOnceBundle extends _FileBundle {
  bool _failed = false;

  @override
  Future<String> loadString(String key, {bool cache = true}) {
    if (!_failed) {
      _failed = true;
      throw StateError('asset not ready');
    }
    return super.loadString(key, cache: cache);
  }
}

class _FileBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    final bytes = await File(
      'packages/character_data/assets/characters/characters.json',
    ).readAsBytes();
    return ByteData.sublistView(bytes);
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) async =>
      utf8.decode((await load(key)).buffer.asUint8List());
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeCharacterRepository repository;

  setUp(() {
    repository = FakeCharacterRepository(
      const CharacterJsonMapper(),
      bundle: _FileBundle(),
      fetchDelay: Duration.zero,
    );
  });

  test('paging returns all 8 characters in order', () async {
    final ids = <String>[];
    String? cursor;
    do {
      final page = await repository.fetchCharacterFeed(limit: 3, cursor: cursor);
      ids.addAll(page.characters.map((character) => character.id));
      cursor = page.nextCursor;
    } while (cursor != null);

    final all = await repository.observeAllCharacters().first;
    expect(ids, hasLength(8));
    expect(ids, all.map((character) => character.id));
  });

  test('like and unlike flip hasFeedLike and emit', () async {
    final lists = <List<CharacterModel>>[];
    final subscription = repository.observeAllCharacters().listen(lists.add);
    await pumpEventQueue();
    final id = lists.first.first.id;

    await repository.likeFeedCharacter(id);
    expect((await repository.getCharacter(id))!.hasFeedLike, isTrue);
    await repository.unlikeFeedCharacter(id);
    expect((await repository.getCharacter(id))!.hasFeedLike, isFalse);
    await pumpEventQueue();
    await subscription.cancel();

    expect(lists[1].first.hasFeedLike, isTrue);
    expect(lists.last.first.hasFeedLike, isFalse);
  });

  test('created character comes first in the feed', () async {
    const created = CharacterModel(
      id: 'new',
      name: 'New',
      fullName: 'New One',
      age: 20,
      gender: [CharacterGender.female],
      cyoc: false,
      photos: [],
      publicBio: '',
    );

    final result = await repository.createCharacterFromGeneration(created);
    final page = await repository.fetchCharacterFeed(limit: 20);

    expect(result.cyoc, isTrue);
    expect(page.characters.first.id, 'new');
    expect(page.characters, hasLength(9));
  });

  test('a created character does not shift later pages', () async {
    final firstPage = await repository.fetchCharacterFeed(limit: 3);
    await repository.createCharacterFromGeneration(
      const CharacterModel(
        id: 'new',
        name: 'New',
        fullName: 'New One',
        age: 20,
        gender: [CharacterGender.female],
        cyoc: false,
        photos: [],
        publicBio: '',
      ),
    );
    final secondPage = await repository.fetchCharacterFeed(limit: 3, cursor: firstPage.nextCursor);

    final all = await repository.observeAllCharacters().first;
    final baseIds = all.where((character) => !character.cyoc).map((character) => character.id);
    expect(secondPage.characters.map((character) => character.id), baseIds.skip(3).take(3));
  });

  test('a failed first load is retried on the next call', () async {
    final flaky = FakeCharacterRepository(
      const CharacterJsonMapper(),
      bundle: _FailingOnceBundle(),
      fetchDelay: Duration.zero,
    );

    await expectLater(flaky.fetchCharacterFeed(limit: 3), throwsStateError);
    final page = await flaky.fetchCharacterFeed(limit: 3);

    expect(page.characters, hasLength(3));
  });
}
