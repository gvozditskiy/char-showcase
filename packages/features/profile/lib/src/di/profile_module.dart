import 'package:common_ui/common_ui.dart';
import 'package:core/core.dart';

import '../bloc/app_settings_cubit.dart';
import '../profile_feature_adapter.dart';

class ProfileModule {
  ProfileModule() {
    _setup();
  }

  final _di = ServiceLocator();

  void _setup() {
    _di.registerFactory<AppSettingsCubit>(
      (_) =>
          AppSettingsCubit(_di.get<AppThemeSettingsProvider>(), _di.get<ProfileFeatureAdapter>()),
    );
  }
}
