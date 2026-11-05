import 'package:char/app/feature_adapter/cards_feature_adapter_impl.dart';
import 'package:char/app/repository/rate_app_repository.dart';
import 'package:char/app/usecase/show_rate_app_use_case.dart';
import 'package:character_data/character_data.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:navigation/navigation.dart';

class _MockAppNavigator extends Mock implements AppNavigator {}

class _MockShowRateAppUseCase extends Mock implements ShowRateAppUseCase {}

class _MockLogger extends Mock implements Logger {}

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
  group('CardsFeatureAdapterImpl', () {
    const character = CharacterModel(
      id: 'id',
      name: 'Name',
      fullName: 'Full Name',
      age: 25,
      gender: [],
      cyoc: false,
      photos: [],
      publicBio: 'Bio',
    );

    late RateAppRepository rateAppRepository;
    late _MockShowRateAppUseCase showRateAppUseCase;
    late CardsFeatureAdapterImpl adapter;

    setUp(() {
      rateAppRepository = RateAppRepository(_InMemoryPreferences());
      showRateAppUseCase = _MockShowRateAppUseCase();
      when(() => showRateAppUseCase()).thenAnswer((_) async => true);
      adapter = CardsFeatureAdapterImpl(
        _MockAppNavigator(),
        rateAppRepository,
        showRateAppUseCase,
        _MockLogger(),
      );
    });

    test('first like shows rate app', () async {
      await adapter.onCharacterLiked(character);

      verify(() => showRateAppUseCase()).called(1);
    });

    test('second like does not show rate app again', () async {
      await adapter.onCharacterLiked(character);
      await adapter.onCharacterLiked(character);

      verify(() => showRateAppUseCase()).called(1);
    });

    test('two quick likes show rate app once', () async {
      await Future.wait([adapter.onCharacterLiked(character), adapter.onCharacterLiked(character)]);

      verify(() => showRateAppUseCase()).called(1);
    });

    test('like shows rate app again if the survey did not open', () async {
      when(() => showRateAppUseCase()).thenAnswer((_) async => false);
      await adapter.onCharacterLiked(character);
      await adapter.onCharacterLiked(character);

      verify(() => showRateAppUseCase()).called(2);
    });

    test('like after rating was set does not show rate app', () async {
      await rateAppRepository.setRatingWasSet();

      await adapter.onCharacterLiked(character);

      verifyNever(() => showRateAppUseCase());
    });
  });
}
