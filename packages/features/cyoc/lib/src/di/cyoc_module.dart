import 'dart:math';

import 'package:character_data/character_data.dart';
import 'package:core/core.dart';
import 'package:flutter/services.dart';
import 'package:navigation/navigation.dart';

import '../cyoc_feature_adapter.dart';
import '../data/cyoc_suggestions_repository.dart';
import '../flows/creation/cyoc_creation_cubit.dart';
import '../route/cyoc_navigation_source.dart';
import '../route/cyoc_paths.dart';
import '../service/cyoc_assets_service.dart';
import '../service/cyoc_generation_service.dart';
import '../service/fake_cyoc_assets_service.dart';
import '../service/fake_cyoc_generation_service.dart';
import '../usecase/create_character_from_generation_use_case.dart';

class CyocModule {
  CyocModule() {
    _setup();
  }

  final _di = ServiceLocator();

  void _setup() {
    _di
      ..registerFactory((_) => CreateCharacterFromGenerationUseCase(_di.get<CharacterRepository>()))
      ..registerLazySingleton(
        (_) => CyocSuggestionsRepository(rootBundle, Random(), _di.get<LocalizedConfigSelector>()),
      )
      ..registerLazySingleton<CyocAssetsService>((_) => const FakeCyocAssetsService())
      ..registerFactory<CyocGenerationService>(
        (_) => FakeCyocGenerationService(_di.get<CyocAssetsService>()),
      )
      ..registerFactory<CyocCreationCubit>(
        (params) => CyocCreationCubit(
          _di.get<CyocGenerationService>(),
          _di.get<CyocAssetsService>(),
          _di.get<CyocSuggestionsRepository>(),
          _di.get<CreateCharacterFromGenerationUseCase>(),
          _di.get<CyocFeatureAdapter>(),
          _di.get<AppNavigator>(),
          _di.get<AnalyticsService>(),
          _di.get<Logger>(),
          params?[CyocPath.cyocSourceParam] as CyocNavigationSource? ?? CyocNavigationSource.navBar,
        ),
      );
  }
}
