import 'package:common_ui/common_ui.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/root_bloc.dart';
import '../factory/base_survey_screen_factory.dart';
import '../flow/flow_host.dart';
import '../flow/survey_screen_factory.dart';
import '../helper/app_survey_constants.dart';
import '../model/survey_flow_config.dart';
import '../model/survey_screen_model.dart';

class SurveyRootPage extends StatefulWidget {
  const SurveyRootPage({required this.config, this.screenFactory, super.key});

  final SurveyFlowConfig<SurveyScreenModel>? config;
  final SurveyScreenFactory<SurveyScreenModel>? screenFactory;

  @override
  State<SurveyRootPage> createState() => _SurveyRootPageState();
}

class _SurveyRootPageState extends State<SurveyRootPage> {
  late final BaseSurveyRootBloc<SurveyScreenModel> _bloc;
  late final FlowHostController<SurveyScreenModel> _flowController;

  @override
  void initState() {
    super.initState();
    final di = ServiceLocator();
    _flowController = di.get<FlowHostController<SurveyScreenModel>>();
    _bloc = di.get<BaseSurveyRootBloc<SurveyScreenModel>>(
      params: {AppSurveyConstants.configModelParam: widget.config},
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final config = widget.config;
    final screenFactory = widget.screenFactory ?? const BaseSurveyScreenFactory().build;

    final flow = config == null
        ? const SizedBox.shrink()
        : FlowHost<SurveyScreenModel>(
            controller: _flowController,
            config: config,
            screenFactory: screenFactory,
          );

    return CharPopScope(
      interceptBack: true,
      onPopInvoked: (_, _) => _onBack(),
      child: Stack(
        children: [
          const Positioned.fill(child: CharBackground()),
          Positioned.fill(
            child: CharPadding(
              CharPadding.of(context, includeMedia: false) + const EdgeInsets.only(top: 69),
              child: flow,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: BlocBuilder<BaseSurveyRootBloc<SurveyScreenModel>, RootState>(
              bloc: _bloc,
              buildWhen: (previous, current) =>
                  previous.currentScreenNumber != current.currentScreenNumber ||
                  previous.totalScreenNumber != current.totalScreenNumber,
              builder: (context, state) => CharToolbar(
                height: 44,
                padding: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.8, 1],
                    colors: [
                      palette.surfaceTranslucentWhite,
                      palette.surfaceTranslucentWhite.withAlphaPercent(0),
                    ],
                  ),
                ),
                onBackClick: state.currentScreenNumber > 1 ? _onBack : null,
                onCloseClick: () => _bloc.add(const RootScreenClosePressedEvent()),
                titleWidget: SizedBox(
                  width: 175,
                  child: CharLinearProgressBar(progress: _progress(state)),
                ),
                bottom: const PreferredSize(
                  preferredSize: Size.fromHeight(25),
                  child: SizedBox(height: 25),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onBack() => _bloc.add(RootScreenBackPressedEvent(screenKey: _flowController.currentKey));

  double _progress(RootState state) {
    final progress = state.currentScreenNumber / state.totalScreenNumber;
    return progress.isNaN ? 0 : progress;
  }
}
