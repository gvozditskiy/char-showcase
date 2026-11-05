import 'package:character_data/character_data.dart';
import 'package:core/core.dart';
import 'package:navigation/navigation.dart';

import '../cards_feature_adapter.dart';
import '../cubit/card_details/card_details_cubit.dart';
import '../cubit/cards_feed/cards_feed_cubit.dart';

class CardsModule {
  CardsModule() {
    _setup();
  }

  final _di = ServiceLocator();

  void _setup() {
    _di
      ..registerFactory<CardsFeedCubit>(
        (_) => CardsFeedCubit(
          _di.get<CharacterRepository>(),
          _di.get<CardsFeatureAdapter>(),
          _di.get<AppNavigator>(),
          _di.get<AnalyticsService>(),
          _di.get<Logger>(),
        ),
      )
      ..registerFactory<CardDetailsCubit>(
        (_) => CardDetailsCubit(
          _di.get<Logger>(),
          _di.get<AppNavigator>(),
          _di.get<CardsFeatureAdapter>(),
          _di.get<AnalyticsService>(),
          _di.get<CharacterRepository>(),
        ),
      );
  }
}
