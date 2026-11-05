import 'package:flutter/widgets.dart';

import '../model/survey_base_screen_models.dart';
import '../model/survey_flow_config.dart';
import '../model/survey_screen_model.dart';
import '../model/survey_screen_models.dart';
import '../pages/rating_survey_page.dart';
import '../pages/survey_intro_page.dart';

class BaseSurveyScreenFactory {
  const BaseSurveyScreenFactory();

  Widget build(
    BuildContext context,
    SurveyScreenModel screenModel,
    SurveyFlowConfig<SurveyScreenModel> config,
  ) {
    return switch (screenModel) {
      RatingSurveyScreenModel() => RatingSurveyPage(screenModel: screenModel),
      SurveyCoverScreenModel() => SurveyIntroPage(
        screenModel: screenModel,
        buttonText: screenModel.continueButtonText ?? config.introButtonText,
      ),
      _ => throw UnimplementedError('Screen type ${screenModel.runtimeType} not supported'),
    };
  }
}
