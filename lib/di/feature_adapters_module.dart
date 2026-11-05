import 'package:cards/cards.dart';
import 'package:core/core.dart';
import 'package:cyoc/cyoc.dart';
import 'package:navigation/navigation.dart';
import 'package:profile/profile.dart';

import '../app/feature_adapter/cards_feature_adapter_impl.dart';
import '../app/feature_adapter/cyoc_feature_adapter_impl.dart';
import '../app/feature_adapter/profile_feature_adapter_impl.dart';
import '../app/repository/rate_app_repository.dart';
import '../app/usecase/show_rate_app_use_case.dart';

class FeatureAdaptersModule {
  FeatureAdaptersModule() {
    _setup();
  }

  final _di = ServiceLocator();

  void _setup() {
    _di
      ..registerFactory<CardsFeatureAdapter>(
        (_) => CardsFeatureAdapterImpl(
          _di.get<AppNavigator>(),
          _di.get<RateAppRepository>(),
          _di.get<ShowRateAppUseCase>(),
          _di.get<Logger>(),
        ),
      )
      ..registerFactory<ProfileFeatureAdapter>(
        (_) => ProfileFeatureAdapterImpl(_di.get<ShowRateAppUseCase>()),
      )
      ..registerFactory<CyocFeatureAdapter>((_) => CyocFeatureAdapterImpl(_di.get<AppNavigator>()));
  }
}
