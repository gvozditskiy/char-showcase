import 'package:navigation/navigation.dart';

class SurveyPath extends PathInfo {
  const SurveyPath(super.path, super.name);

  static const screen = SurveyPath('/survey', 'survey_screen');
}
