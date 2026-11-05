import 'package:core/core.dart';
import 'package:navigation/navigation.dart';

import '../bloc/rating_survey_cubit.dart';
import '../bloc/root_bloc.dart';
import '../bloc/survey_cover_cubit.dart';
import '../flow/flow_host.dart';
import '../handler/completion_handler_provider.dart';
import '../handler/event_handler_provider.dart';
import '../helper/app_survey_constants.dart';
import '../model/survey_base_screen_models.dart';
import '../model/survey_flow_config.dart';
import '../model/survey_screen_model.dart';
import '../repository/survey_repository.dart';
import '../route/survey_navigator.dart';

class SurveyBlocModule {
  SurveyBlocModule() {
    _setup();
  }

  final _di = ServiceLocator();

  void _setup() {
    _di
      ..registerFactory<SurveyCoverCubit>((params) {
        final screenModel = params?[AppSurveyConstants.screenModelParam];
        if (screenModel is! BaseSurveyScreenModel) {
          throw ArgumentError('screenModel must be BaseSurveyScreenModel or its subtype');
        }
        return SurveyCoverCubit(_di.get<SurveyNavigator>(), screenModel);
      })
      ..registerFactory<RatingSurveyCubit>(
        (params) => RatingSurveyCubit(
          _di.get<SurveyNavigator>(),
          params?[AppSurveyConstants.screenModelParam] as RatingSurveyScreenModel,
        ),
      )
      ..registerLazySingleton<FlowHostController<SurveyScreenModel>>(
        (_) => FlowHostController<SurveyScreenModel>(),
        dispose: (controller) => (controller as FlowHostController<SurveyScreenModel>).dispose(),
      )
      ..registerLazySingleton<BaseSurveyRootBloc<SurveyScreenModel>>(
        (params) => BaseSurveyRootBloc<SurveyScreenModel>(
          _di.get<AppNavigator>(),
          _di.get<Logger>(),
          params?[AppSurveyConstants.configModelParam] as SurveyFlowConfig<SurveyScreenModel>?,
          _di.get<FlowHostController<SurveyScreenModel>>(),
          _di.get<SurveyRepository>(),
          _di.get<CompletionHandlerProvider>(),
          _di.get<EventHandlerProvider>(),
        ),
        dispose: (bloc) => (bloc as BaseSurveyRootBloc<SurveyScreenModel>).close(),
      );
  }
}
