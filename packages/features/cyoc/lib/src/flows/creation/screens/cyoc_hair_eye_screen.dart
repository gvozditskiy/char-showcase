import 'package:character_data/character_data.dart';
import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/l10n.dart';
import '../../../models/builder_attributes.dart';
import '../cyoc_creation_cubit.dart';
import 'widgets/cyoc_attribute_labels.dart';
import 'widgets/cyoc_color_swatch_selector.dart';
import 'widgets/cyoc_creation_step_layout.dart';
import 'widgets/cyoc_selector_carousel.dart';

class CyocHairEyeScreen extends StatelessWidget {
  const CyocHairEyeScreen({required this.cubit, super.key});

  final CyocCreationCubit cubit;

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    final style = context.appStyle;
    return AutomationSemantics(
      identifier: 'cyoc_creation_hair_eye_screen',
      child: BlocBuilder<CyocCreationCubit, CyocCreationState>(
        bloc: cubit,
        builder: (context, state) {
          return CyocCreationStepLayout(
            contentPadding: const EdgeInsets.only(top: 20),
            children: [
              CyocSelectorCarousel<CyocHairStyle>(
                title: strings.cyocCreationHairStyleTitle,
                options: CyocHairStyle.valuesFor(state.choice.gender),
                selected: state.choice.hairStyle,
                onChanged: cubit.updateHairStyle,
                titleOf: (value) => value.label(strings),
                imageUrlOf: (value) => cubit.assetUrl(
                  value.assetKey(gender: state.choice.gender, style: state.choice.style),
                ),
                semanticsPrefix: 'cyoc_creation_hair_style',
                idOf: (value) => value.assetSlug,
                titleGap: style.spacing.space3,
                isCompact: true,
              ),
              if (state.choice.gender == CharacterGender.male) ...[
                SizedBox(height: style.spacing.space3),
                CyocSelectorCarousel<CyocFacialHair>(
                  title: strings.cyocCreationFacialHairTitle,
                  options: CyocFacialHair.values,
                  selected: state.choice.facialHair,
                  onChanged: cubit.updateFacialHair,
                  titleOf: (value) => value.label(strings),
                  imageUrlOf: (value) => cubit.assetUrl(value.assetKey(style: state.choice.style)),
                  semanticsPrefix: 'cyoc_creation_facial_hair',
                  idOf: (value) => value.assetSlug,
                  titleGap: style.spacing.space3,
                  isCompact: true,
                ),
              ],
              SizedBox(height: style.spacing.space3),
              CyocColorSwatchSelector<CyocHairColor>(
                title: strings.cyocCreationHairColorTitle,
                options: CyocHairColor.values,
                selected: state.choice.hairColor,
                onChanged: cubit.updateHairColor,
                titleOf: (value) => value.label(strings),
                imageUrlOf: (value) => cubit.assetUrl(value.assetKey(style: state.choice.style)),
                semanticsPrefix: 'cyoc_creation_hair_color',
                idOf: (value) => value.assetSlug,
                titleGap: style.spacing.space3,
              ),
              SizedBox(height: style.spacing.space3),
              CyocColorSwatchSelector<CyocEyeColor>(
                title: strings.cyocCreationEyeColorTitle,
                options: CyocEyeColor.values,
                selected: state.choice.eyeColor,
                onChanged: cubit.updateEyeColor,
                titleOf: (value) => value.label(strings),
                imageUrlOf: (value) => cubit.assetUrl(value.assetKey(style: state.choice.style)),
                semanticsPrefix: 'cyoc_creation_eye_color',
                idOf: (value) => value.assetSlug,
                titleGap: style.spacing.space3,
              ),
            ],
          );
        },
      ),
    );
  }
}
