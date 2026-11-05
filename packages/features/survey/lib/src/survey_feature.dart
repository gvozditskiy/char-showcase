import 'package:common_ui/common_ui.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';

import 'di/survey_component.dart';
import 'factory/base_survey_screen_factory.dart';
import 'model/survey_flow_config.dart';
import 'model/survey_screen_model.dart';
import 'pages/survey_root_page.dart';
import 'route/survey_paths.dart';

abstract final class SurveyFeature {
  static CharShellRoute getSurveyRoute() {
    return CharShellRoute(
      parentNavigatorKey: NavigatorKey.shellNavigatorKey,
      screenBuilder: (context, state, child) =>
          Scoped(onInit: SurveyComponent.init, onDispose: SurveyComponent.dispose, child: child),
      routes: [
        CharRoute(
          pathInfo: SurveyPath.screen,
          screenBuilder: (context, state) {
            final config = state.extra;
            if (config is! SurveyFlowConfig<SurveyScreenModel>) {
              ServiceLocator().get<Logger>().e(
                '[SurveyFeature] Survey screen opened without a config: ${state.extra.runtimeType}',
              );
              return const SizedBox.shrink();
            }
            return SurveyRootPage(
              config: config,
              screenFactory: const BaseSurveyScreenFactory().build,
            );
          },
        ),
      ],
    );
  }

  static bool openSurvey(AppNavigator navigator, SurveyFlowConfig<SurveyScreenModel> config) {
    if (_isSurveyOpen(config)) {
      return false;
    }
    navigator.push(SurveyPath.screen, extra: config);
    return true;
  }

  static bool _isSurveyOpen(SurveyFlowConfig<SurveyScreenModel> config) {
    final di = ServiceLocator();
    final isOpen = di.containsScope(scopeName: SurveyComponent.scope);
    if (isOpen) {
      di.get<Logger>().w(
        '[SurveyFeature] Survey ${config.surveyId} skipped, another survey is already open',
      );
    }
    return isOpen;
  }
}
