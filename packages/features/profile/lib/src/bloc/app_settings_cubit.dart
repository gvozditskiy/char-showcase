import 'package:common_ui/common_ui.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../profile_feature_adapter.dart';

part 'app_settings_cubit_state.dart';

class AppSettingsCubit extends Cubit<AppSettingsState> {
  AppSettingsCubit(this._themeProvider, this._featureAdapter)
    : super(const AppSettingsState.initial());

  final AppThemeSettingsProvider _themeProvider;
  final ProfileFeatureAdapter _featureAdapter;

  void load() {
    emit(state.copyWith(themeMode: _themeProvider.getThemeMode()));
  }

  Future<void> setThemeMode(AppThemeMode themeMode) async {
    await _themeProvider.setThemeMode(themeMode);
    emit(state.copyWith(themeMode: themeMode));
  }

  Future<void> onRateTap() => _featureAdapter.showRateApp();
}
