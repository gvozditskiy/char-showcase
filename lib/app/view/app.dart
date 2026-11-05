import 'package:cards/l10n/l10n.dart' as cards_l10n;
import 'package:common_ui/common_ui.dart';
import 'package:common_ui/l10n/l10n.dart' as common_ui_l10n;
import 'package:core/core.dart';
import 'package:cyoc/l10n/l10n.dart' as cyoc_l10n;
import 'package:flutter/material.dart';
import 'package:profile/l10n/l10n.dart' as profile_l10n;
import 'package:survey/l10n/l10n.dart' as survey_l10n;

import '../../l10n/l10n.dart';
import '../route/router.dart';

class App extends StatelessWidget {
  const App(this._appRouter, this._localeSettingsProvider, {super.key});

  final AppRouter _appRouter;
  final LocaleSettingsProvider _localeSettingsProvider;

  @override
  Widget build(BuildContext context) {
    return AppStyle(
      child: ValueListenableBuilder<AppThemeMode>(
        valueListenable: ThemeController.instance,
        builder: (context, themeMode, _) => MaterialApp.router(
          routerConfig: _appRouter.getRouter(),
          onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
          localizationsDelegates: const [
            ...AppLocalizations.localizationsDelegates,
            common_ui_l10n.AppLocalizations.delegate,
            cards_l10n.AppLocalizations.delegate,
            cyoc_l10n.AppLocalizations.delegate,
            profile_l10n.AppLocalizations.delegate,
            survey_l10n.AppLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: _localeSettingsProvider.resolvedLocale,
          theme: CharPalette.instance.toThemeData(),
          darkTheme: CharPalette.instance.toThemeData(isDark: true),
          themeMode: themeMode.materialThemeMode,
        ),
      ),
    );
  }
}
