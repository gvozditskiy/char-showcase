import 'package:flutter/widgets.dart';

import '../model/survey_flow_config.dart';
import '../model/survey_screen_model.dart';

typedef SurveyScreenFactory<T extends SurveyScreenModel> =
    Widget Function(BuildContext context, T screenModel, SurveyFlowConfig<T> config);
