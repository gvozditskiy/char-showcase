import 'survey_screen_model.dart';

class SurveyCoverScreenModel extends BaseSurveyScreenModel {
  SurveyCoverScreenModel({
    required super.key,
    required super.title,
    required super.subtitle,
    super.navigation,
    this.continueButtonText,
  });

  final String? continueButtonText;
}
