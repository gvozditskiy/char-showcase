import 'dart:async';

import 'package:common_ui/common_ui.dart';
import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:navigation/navigation.dart';

import 'app/route/router.dart';
import 'app/view/app.dart';
import 'di/component/main_component.dart';
import 'l10n/l10n.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      MainComponent.init();
      final di = ServiceLocator();
      FlutterError.onError = (details) {
        di.get<Logger>().e(
          details.exceptionAsString(),
          error: details,
          stackTrace: details.stack,
          fatal: true,
        );
      };
      di.onScopeChanged = (changedScopeName, {required bool pushed}) => di.get<Logger>().d(
        '[DI SCOPE] ${pushed ? 'pushed new scope $changedScopeName' : 'scope $changedScopeName popped. Current scope is ${di.currentScopeName}'}',
      );
      await di.get<SharedPreferencesProvider>().init();
      di.get<AppThemeSettingsProvider>().init();
      di.get<LocaleSettingsProvider>().init(AppLocalizations.supportedLocales);
      di.get<AppNavigator>().init();
      runApp(App(di.get<AppRouter>(), di.get<LocaleSettingsProvider>()));
    },
    (error, stackTrace) {
      ServiceLocator().get<Logger>().e(error.toString(), stackTrace: stackTrace);
    },
  );
}
