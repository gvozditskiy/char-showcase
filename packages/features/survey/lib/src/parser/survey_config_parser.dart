import '../model/survey_flow_config.dart';
import '../model/survey_screen_model.dart';

// ignore_for_file: one_member_abstracts

abstract interface class SurveyConfigParser<T extends SurveyScreenModel> {
  Future<SurveyFlowConfig<T>?> parse(Map<String, dynamic> json);
}
