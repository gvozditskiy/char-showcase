part of 'app_settings_cubit.dart';

class AppSettingsState extends Equatable {
  const AppSettingsState({required this.themeMode});

  const AppSettingsState.initial() : themeMode = AppThemeMode.system;

  final AppThemeMode themeMode;

  AppSettingsState copyWith({AppThemeMode? themeMode}) {
    return AppSettingsState(themeMode: themeMode ?? this.themeMode);
  }

  @override
  List<Object?> get props => [themeMode];
}
