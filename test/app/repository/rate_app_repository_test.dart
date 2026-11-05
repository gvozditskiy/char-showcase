import 'package:char/app/model/rate_app_source.dart';
import 'package:char/app/repository/rate_app_repository.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

class _InMemoryPreferences implements SharedPreferencesProvider {
  final Map<String, Object> _values = {};

  @override
  Future<void> init() async {}

  @override
  String? getString(String key) => _values[key] as String?;

  @override
  Future<bool> setString(String key, String value) async {
    _values[key] = value;
    return true;
  }

  @override
  bool? getBool(String key) => _values[key] as bool?;

  @override
  Future<bool> setBool(String key, {required bool value}) async {
    _values[key] = value;
    return true;
  }
}

void main() {
  group('RateAppRepository', () {
    late RateAppRepository repository;

    setUp(() {
      repository = RateAppRepository(_InMemoryPreferences());
    });

    const source = RateAppPopUpSource.firstCharacterLike;

    test('a second show cannot start while the first is in flight', () async {
      expect(repository.tryStartShow(source), isTrue);
      expect(repository.tryStartShow(source), isFalse);
    });

    test('a shown source is not offered again', () async {
      expect(repository.tryStartShow(source), isTrue);
      await repository.finishShow(source, shown: true);

      expect(repository.tryStartShow(source), isFalse);
    });

    test('a source that failed to show is offered again', () async {
      expect(repository.tryStartShow(source), isTrue);
      await repository.finishShow(source, shown: false);

      expect(repository.tryStartShow(source), isTrue);
    });

    test('profile source is not offered by the repository', () {
      expect(repository.tryStartShow(RateAppPopUpSource.profile), isFalse);
      expect(repository.tryStartShow(source), isTrue);
    });

    test('shows nothing after rating was set', () async {
      await repository.setRatingWasSet();

      expect(repository.tryStartShow(source), isFalse);
    });

    test('remembers native rate or store shown', () async {
      expect(await repository.isNativeRateOrStoreShown(), isFalse);

      await repository.setNativeRateOrStoreShown();

      expect(await repository.isNativeRateOrStoreShown(), isTrue);
    });
  });
}
