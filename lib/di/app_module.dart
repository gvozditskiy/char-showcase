import 'package:character_data/character_data.dart';
import 'package:common_ui/common_ui.dart';
import 'package:core/core.dart';
import 'package:navigation/navigation.dart';
import 'package:survey/survey.dart';

import '../app/analytics/analytics_interceptor.dart';
import '../app/analytics/tracker/log_analytics_tracker.dart';
import '../app/handler/rate_app_negative_feedback_handler.dart';
import '../app/handler/rate_app_system_rating_handler.dart';
import '../app/logger/logger_impl.dart';
import '../app/mapper/character_json_mapper.dart';
import '../app/repository/fake_character_repository.dart';
import '../app/repository/rate_app_repository.dart';
import '../app/route/app_navigator.dart';
import '../app/route/router.dart';
import '../app/storage/shared_prefs_provider_impl.dart';
import '../app/usecase/open_email_composer_use_case.dart';

class AppModule {
  AppModule() {
    _setup();
  }

  final _di = ServiceLocator();

  void _setup() {
    _di
      ..registerLazySingleton<Logger>((_) => LoggerImpl())
      ..registerLazySingleton<AppRouter>((_) => AppRouter())
      ..registerLazySingleton<AppNavigator>(
        (_) => MainAppNavigator(_di.get<AppRouter>(), _di.get<Logger>()),
      )
      ..registerLazySingleton<LogAnalyticsTracker>((_) => LogAnalyticsTracker(_di.get<Logger>()))
      ..registerLazySingleton<AnalyticsService>(
        (_) => AnalyticsService(
          trackers: <AnalyticsTracker>{_di.get<LogAnalyticsTracker>()},
          interceptors: {LogInterceptor(_di.get<Logger>())},
        ),
      )
      ..registerLazySingleton<SharedPreferencesProvider>((_) => SharedPreferencesProviderImpl())
      ..registerLazySingleton<LocaleSettingsProvider>((_) => LocaleSettingsProvider())
      ..registerLazySingleton<LocalizedConfigSelector>(
        (_) => LocalizedConfigSelector(_di.get<LocaleSettingsProvider>()),
      )
      ..registerFactory<AppThemeSettingsProvider>(
        (_) => AppThemeSettingsProvider(_di.get<SharedPreferencesProvider>()),
      )
      ..registerLazySingleton<CharacterJsonMapper>((_) => const CharacterJsonMapper())
      ..registerLazySingleton<CharacterRepository>(
        (_) => FakeCharacterRepository(_di.get<CharacterJsonMapper>()),
      )
      ..registerLazySingleton<SurveyConfigParser<SurveyScreenModel>>(
        (_) => BaseSurveyConfigParserImpl(_di.get<Logger>()),
      )
      ..registerLazySingleton<CompletionHandlerProvider>(
        (_) => CompletionHandlerProvider(_di, _di.get<Logger>()),
      )
      ..registerLazySingleton<EventHandlerProvider>(
        (_) => EventHandlerProvider(_di, _di.get<Logger>()),
      );

    for (final type in CompletionHandlerType.values) {
      _di.registerFactory<CompletionHandler>(
        (_) => switch (type) {
          CompletionHandlerType.generic => GenericCompletionHandler(
            _di.get<AnalyticsService>(),
            _di.get<Logger>(),
          ),
        },
        instanceName: type.id,
      );
    }

    _di
      ..registerFactory<SurveyEventHandler>(
        (params) => SurveyAnalyticsEventHandler(
          _di.get<AnalyticsService>(),
          surveyId: params?[AppSurveyConstants.surveyIdParam] as String?,
        ),
        instanceName: SurveyAnalyticsEventHandler.type,
      )
      ..registerLazySingleton<RateAppRepository>(
        (_) => RateAppRepository(_di.get<SharedPreferencesProvider>()),
      )
      ..registerFactory<SurveyEventHandler>(
        (_) => RateAppSystemRatingHandler(
          _di.get<RateAppRepository>(),
          _di.get<AnalyticsService>(),
          _di.get<Logger>(),
        ),
        instanceName: 'rate_app_positive',
      )
      ..registerFactory<SurveyEventHandler>(
        (_) => RateAppNegativeFeedbackHandler(
          _di.get<OpenEmailComposerUseCase>(),
          _di.get<SurveyRepository>(),
          _di.get<RateAppRepository>(),
          _di.get<AnalyticsService>(),
          _di.get<Logger>(),
        ),
        instanceName: 'rate_app_negative_feedback',
      );
  }
}
