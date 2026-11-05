import 'package:bloc_test/bloc_test.dart';
import 'package:common_ui/common_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:profile/src/bloc/app_settings_cubit.dart';
import 'package:profile/src/profile_feature_adapter.dart';

class _MockAppThemeSettingsProvider extends Mock implements AppThemeSettingsProvider {}

class _MockProfileFeatureAdapter extends Mock implements ProfileFeatureAdapter {}

void main() {
  late _MockAppThemeSettingsProvider themeProvider;
  late _MockProfileFeatureAdapter featureAdapter;

  setUpAll(() => registerFallbackValue(AppThemeMode.system));

  setUp(() {
    themeProvider = _MockAppThemeSettingsProvider();
    featureAdapter = _MockProfileFeatureAdapter();
    when(() => featureAdapter.showRateApp()).thenAnswer((_) async {});
    when(() => themeProvider.getThemeMode()).thenReturn(AppThemeMode.light);
    when(() => themeProvider.setThemeMode(any())).thenAnswer((_) async {});
  });

  group('AppSettingsCubit', () {
    blocTest<AppSettingsCubit, AppSettingsState>(
      'load emits the saved theme mode',
      build: () => AppSettingsCubit(themeProvider, featureAdapter),
      act: (cubit) => cubit.load(),
      expect: () => const [AppSettingsState(themeMode: AppThemeMode.light)],
    );

    blocTest<AppSettingsCubit, AppSettingsState>(
      'setThemeMode saves the mode through the provider and emits it',
      build: () => AppSettingsCubit(themeProvider, featureAdapter),
      act: (cubit) => cubit.setThemeMode(AppThemeMode.dark),
      expect: () => const [AppSettingsState(themeMode: AppThemeMode.dark)],
      verify: (_) => verify(() => themeProvider.setThemeMode(AppThemeMode.dark)).called(1),
    );

    blocTest<AppSettingsCubit, AppSettingsState>(
      'onRateTap shows the rate app flow through the adapter',
      build: () => AppSettingsCubit(themeProvider, featureAdapter),
      act: (cubit) => cubit.onRateTap(),
      verify: (_) => verify(() => featureAdapter.showRateApp()).called(1),
    );
  });
}
