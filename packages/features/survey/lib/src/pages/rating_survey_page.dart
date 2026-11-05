import 'package:common_ui/common_ui.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../bloc/rating_survey_cubit.dart';
import '../helper/app_survey_constants.dart';
import '../helper/survey_text_template.dart';
import '../model/survey_base_screen_models.dart';

class RatingSurveyPage extends StatefulWidget {
  const RatingSurveyPage({required this.screenModel, super.key});

  final RatingSurveyScreenModel screenModel;

  @override
  State<RatingSurveyPage> createState() => _RatingSurveyPageState();
}

class _RatingSurveyPageState extends State<RatingSurveyPage> {
  late final RatingSurveyCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = ServiceLocator().get<RatingSurveyCubit>(
      params: {AppSurveyConstants.screenModelParam: widget.screenModel},
    );
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.screenModel.title;
    final subtitle = widget.screenModel.subtitle;
    return AutomationSemantics(
      identifier: AutomationId.join(['survey', widget.screenModel.key, 'screen']),
      child: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              if (title != null && title.isNotEmpty)
                Text(
                  SurveyTextTemplate.processStoreName(title),
                  style: context.appStyle.text.h4.copyWith(
                    color: context.palette.textOnSurfacePrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              if (subtitle != null && subtitle.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  SurveyTextTemplate.processStoreName(subtitle),
                  style: context.appStyle.text.p1.copyWith(
                    color: context.palette.textOnSurfaceSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 48),
              _buildEmojisRow(),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmojisRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (final option in widget.screenModel.options)
          ClickDetector(
            semanticsIdentifier: AutomationId.join([
              'survey',
              widget.screenModel.key,
              'rating',
              option.value.toString(),
              'button',
            ]),
            onClick: () => _cubit.onRatingSelected(option.value),
            child: Text(option.emoji, style: const TextStyle(fontSize: 48)),
          ),
      ],
    );
  }
}
