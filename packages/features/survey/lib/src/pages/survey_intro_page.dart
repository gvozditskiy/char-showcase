import 'package:common_ui/common_ui.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../bloc/survey_cover_cubit.dart';
import '../helper/app_survey_constants.dart';
import '../helper/survey_text_template.dart';
import '../model/survey_screen_models.dart';

class SurveyIntroPage extends StatefulWidget {
  const SurveyIntroPage({required this.screenModel, this.buttonText, super.key});

  final SurveyCoverScreenModel screenModel;
  final String? buttonText;

  @override
  State<SurveyIntroPage> createState() => _SurveyIntroPageState();
}

class _SurveyIntroPageState extends State<SurveyIntroPage> {
  late final SurveyCoverCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = ServiceLocator().get<SurveyCoverCubit>(
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
    final styles = context.appStyle.text;
    final palette = context.palette;
    final title = SurveyTextTemplate.processStoreName(widget.screenModel.title ?? '');
    final subtitle = widget.screenModel.subtitle;
    return AutomationSemantics(
      identifier: _automationId('screen'),
      child: PageScaffold(
        floatingFooter: ThemedButton(
          size: ThemedButtonSize.m,
          theme: ThemedButtonTheme.primary(context),
          text: widget.buttonText ?? context.l10n.surveyStartNow,
          semanticsIdentifier: _automationId('continue_button'),
          onPressed: _cubit.onContinueTap,
        ),
        builder: (context, _) => SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Icon(Icons.favorite_rounded, size: 120, color: palette.iconOnSurfaceAccent),
                const SizedBox(height: 40),
                Text(
                  title,
                  style: styles.h5.copyWith(color: palette.textOnSurfacePrimary),
                  textAlign: TextAlign.center,
                ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      SurveyTextTemplate.processStoreName(subtitle),
                      style: styles.subtitle2.copyWith(color: palette.textOnSurfacePrimary),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _automationId(String suffix) =>
      AutomationId.join(['survey', widget.screenModel.key, suffix]);
}
