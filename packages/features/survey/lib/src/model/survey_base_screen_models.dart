import 'survey_option_model.dart';
import 'survey_screen_model.dart';

class RatingSurveyScreenModel extends BaseSurveyScreenModel {
  RatingSurveyScreenModel({
    required super.key,
    required super.title,
    required super.subtitle,
    required this.options,
    super.navigation,
  });

  final List<RatingOptionModel> options;
}
