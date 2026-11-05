import 'package:core/core.dart';
import 'package:navigation/navigation.dart';
import 'package:survey/survey.dart';

import '../app/usecase/open_email_composer_use_case.dart';
import '../app/usecase/show_rate_app_use_case.dart';

class MainModule {
  MainModule() {
    _setup();
  }

  final _di = ServiceLocator();

  void _setup() {
    _di
      ..registerFactory<OpenEmailComposerUseCase>((_) => const OpenEmailComposerUseCase())
      ..registerFactory<ShowRateAppUseCase>(
        (_) => ShowRateAppUseCase(
          _di.get<AppNavigator>(),
          _di.get<SurveyConfigParser<SurveyScreenModel>>(),
          _di.get<LocalizedConfigSelector>(),
          _di.get<Logger>(),
        ),
      );
  }
}
