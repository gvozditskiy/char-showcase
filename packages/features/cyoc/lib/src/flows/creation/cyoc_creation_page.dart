import 'package:common_ui/common_ui.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../l10n/l10n.dart';
import '../../flow/cyoc_flow_host.dart';
import '../../flow/cyoc_flow_step.dart';
import '../../models/builder_attributes.dart';
import '../../route/cyoc_navigation_source.dart';
import '../../route/cyoc_paths.dart';
import '../../widgets/cyoc_continue_footer.dart';
import 'cyoc_creation_cubit.dart';
import 'cyoc_creation_step.dart';
import 'screens/cyoc_gender_style_age_screen.dart';
import 'screens/cyoc_generation_screen.dart';
import 'screens/cyoc_hair_eye_screen.dart';
import 'screens/cyoc_name_relationship_screen.dart';
import 'screens/cyoc_personality_screen.dart';
import 'screens/cyoc_photo_preview_screen.dart';
import 'screens/cyoc_your_choice_screen.dart';
import 'screens/widgets/cyoc_attribute_carousel_screen.dart';
import 'screens/widgets/cyoc_attribute_labels.dart';
import 'screens/widgets/cyoc_generate_button.dart';

class CyocCreationPage extends StatefulWidget {
  const CyocCreationPage({required this.source, super.key});

  final CyocNavigationSource source;

  @override
  State<CyocCreationPage> createState() => _CyocCreationPageState();
}

class _CyocCreationPageState extends State<CyocCreationPage> {
  late final CyocCreationCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = ServiceLocator().get<CyocCreationCubit>(
      params: {CyocPath.cyocSourceParam: widget.source},
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CyocCreationCubit, CyocCreationState>(
      bloc: _cubit,
      listenWhen: (previous, current) => previous.toast != current.toast,
      listener: _handleToast,
      child: CyocFlowHost(
        controller: _cubit.flow,
        title: context.l10n.cyocCreationToolbarTitle,
        onExit: _cubit.onExitRequested,
        onBack: _cubit.back,
        bodyFactory: (context, step) =>
            _CyocCreationStepBody(cubit: _cubit, step: step as CyocCreationStep),
        footerFactory: _footer,
      ),
    );
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _handleToast(BuildContext context, CyocCreationState state) {
    final text = switch (state.toast) {
      CyocCreationToast.none => null,
      CyocCreationToast.generationFailed => context.l10n.cyocCreationGenerationFailedToast,
      CyocCreationToast.creationFailed => context.l10n.cyocCreationCreateFailedToast,
    };
    if (text == null) {
      return;
    }
    context.showToast(text);
    _cubit.onToastShown();
  }

  PreferredSizeWidget? _footer(BuildContext context, CyocFlowStep step) {
    return switch (step as CyocCreationStep) {
      CyocCreationStep.yourChoice => PreferredSize(
        preferredSize: Size.fromHeight(ThemedButtonSize.m.height),
        child: CyocGenerateFooterButton(cubit: _cubit),
      ),
      CyocCreationStep.genderStyleAge => CyocContinueFooter(
        onContinue: _cubit.next,
        semanticsIdentifier: 'cyoc_creation_gender_style_age_continue_button',
      ),
      CyocCreationStep.ethnicity => CyocContinueFooter(
        onContinue: _cubit.next,
        semanticsIdentifier: 'cyoc_creation_ethnicity_continue_button',
      ),
      CyocCreationStep.bodyType => CyocContinueFooter(
        onContinue: _cubit.next,
        semanticsIdentifier: 'cyoc_creation_body_type_continue_button',
      ),
      CyocCreationStep.hairEye => CyocContinueFooter(
        onContinue: _cubit.next,
        semanticsIdentifier: 'cyoc_creation_hair_eye_continue_button',
      ),
      CyocCreationStep.personality => CyocContinueFooter(
        onContinue: _cubit.next,
        semanticsIdentifier: 'cyoc_creation_personality_continue_button',
      ),
      CyocCreationStep.generation => null,
      CyocCreationStep.photoPreview => PreferredSize(
        preferredSize: Size.fromHeight(ThemedButtonSize.m.height),
        child: CyocPhotoPreviewButtons(cubit: _cubit),
      ),
      CyocCreationStep.nameRelationship => CyocNameRelationshipFooter(cubit: _cubit),
    };
  }
}

class _CyocCreationStepBody extends StatelessWidget {
  const _CyocCreationStepBody({required this.cubit, required this.step});

  final CyocCreationCubit cubit;
  final CyocCreationStep step;

  @override
  Widget build(BuildContext context) {
    return switch (step) {
      CyocCreationStep.genderStyleAge => CyocGenderStyleAgeScreen(cubit: cubit),
      CyocCreationStep.ethnicity => CyocAttributeCarouselScreen<CyocEthnicity>(
        cubit: cubit,
        screenSemanticsIdentifier: 'cyoc_creation_ethnicity_screen',
        title: context.l10n.cyocCreationEthnicityTitle,
        options: (choice) => CyocEthnicity.valuesFor(choice.gender),
        selected: (choice) => choice.ethnicity,
        onChanged: cubit.updateEthnicity,
        titleOf: (value) => value.label(context.l10n),
        imageUrlOf: (value, choice) =>
            cubit.assetUrl(value.assetKey(gender: choice.gender, style: choice.style)),
        idOf: (value) => value.assetSlug,
        semanticsPrefix: 'cyoc_creation_ethnicity',
        isCompact: false,
      ),
      CyocCreationStep.bodyType => CyocAttributeCarouselScreen<CyocBodyType>(
        cubit: cubit,
        screenSemanticsIdentifier: 'cyoc_creation_body_type_screen',
        title: context.l10n.cyocCreationBodyTypeTitle,
        options: (choice) => CyocBodyType.valuesFor(choice.gender),
        selected: (choice) => choice.bodyType,
        onChanged: cubit.updateBodyType,
        titleOf: (value) => value.label(context.l10n),
        imageUrlOf: (value, choice) =>
            cubit.assetUrl(value.assetKey(gender: choice.gender, style: choice.style)),
        idOf: (value) => value.assetSlug,
        semanticsPrefix: 'cyoc_creation_body_type',
        isCompact: false,
      ),
      CyocCreationStep.hairEye => CyocHairEyeScreen(cubit: cubit),
      CyocCreationStep.personality => CyocPersonalityScreen(cubit: cubit),
      CyocCreationStep.yourChoice => CyocYourChoiceScreen(cubit: cubit),
      CyocCreationStep.generation => const CyocGenerationScreen(),
      CyocCreationStep.photoPreview => CyocPhotoPreviewScreen(cubit: cubit),
      CyocCreationStep.nameRelationship => CyocNameRelationshipScreen(cubit: cubit),
    };
  }
}
