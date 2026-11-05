import 'package:core/core.dart';

import '../repository/survey_repository.dart';

class SurveyUseCaseModule {
  SurveyUseCaseModule() {
    _setup();
  }

  final _di = ServiceLocator();

  void _setup() {
    _di.registerLazySingleton<SurveyRepository>((_) => SurveyRepository());
  }
}
