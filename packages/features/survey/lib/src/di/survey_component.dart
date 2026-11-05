import 'package:core/core.dart';

import '../bloc/root_bloc.dart';
import '../model/survey_screen_model.dart';
import '../route/survey_navigator.dart';
import 'survey_bloc_module.dart';
import 'survey_usecase_module.dart';

abstract final class SurveyComponent {
  static const scope = 'survey';
  static final _di = ServiceLocator();

  static void init() {
    _di.retainScope(
      scopeName: scope,
      register: () {
        SurveyUseCaseModule();
        SurveyBlocModule();
        _di.registerFactory<SurveyNavigator>(
          (_) => _di.get<BaseSurveyRootBloc<SurveyScreenModel>>(),
        );
      },
    );
  }

  static void dispose() {
    _di.releaseScope(scopeName: scope);
  }
}
