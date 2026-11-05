import 'dart:async';

import 'package:common_ui/common_ui.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../l10n/l10n.dart' as profile;
import '../bloc/app_settings_cubit.dart';
import '../constants/profile_constants.dart';
import '../widgets/settings_menu_row.dart';
import '../widgets/settings_section.dart';

class GeneralAppearancePage extends StatefulWidget {
  const GeneralAppearancePage({super.key});

  @override
  State<GeneralAppearancePage> createState() => _GeneralAppearancePageState();
}

class _GeneralAppearancePageState extends State<GeneralAppearancePage> {
  late final AppSettingsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = ServiceLocator().get<AppSettingsCubit>()..load();
  }

  @override
  void dispose() {
    unawaited(_cubit.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = profile.AppLocalizations.of(context);
    return PageScaffold(
      toolbar: CharToolbar(title: strings.profileSettingsAppearance),
      builder: (context, _) => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: ProfileConstants.mainHorizontalPadding),
        child: BlocBuilder<AppSettingsCubit, AppSettingsState>(
          bloc: _cubit,
          builder: (context, state) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: ProfileConstants.spacing20),
              SettingsSection(
                title: strings.profileSettingsAppMode,
                description: strings.profileSettingsAppearanceDescription,
                children: [
                  SettingsToggleTile(
                    title: strings.profileSettingsThemeSystem,
                    value: state.themeMode == AppThemeMode.system,
                    onChanged: (_) => _cubit.setThemeMode(AppThemeMode.system),
                    semanticsIdentifier: 'settings_theme_system_toggle',
                  ),
                  SettingsToggleTile(
                    title: strings.profileSettingsThemeLight,
                    value: state.themeMode == AppThemeMode.light,
                    onChanged: (_) => _cubit.setThemeMode(AppThemeMode.light),
                    semanticsIdentifier: 'settings_theme_light_toggle',
                  ),
                  SettingsToggleTile(
                    title: strings.profileSettingsThemeDark,
                    value: state.themeMode == AppThemeMode.dark,
                    onChanged: (_) => _cubit.setThemeMode(AppThemeMode.dark),
                    semanticsIdentifier: 'settings_theme_dark_toggle',
                  ),
                ],
              ),
              const SizedBox(height: ProfileConstants.spacing20),
              SettingsMenuRow(
                label: strings.profileRate,
                iconAssetPath: ProfileConstants.icRateApp,
                onPressed: _cubit.onRateTap,
                semanticsIdentifier: 'settings_rate_button',
              ),
              const SizedBox(height: ProfileConstants.spacing30),
            ],
          ),
        ),
      ),
    );
  }
}
