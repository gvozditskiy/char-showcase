import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/l10n.dart';
import '../../../models/cyoc_photo_style.dart';
import '../cyoc_creation_cubit.dart';
import 'widgets/cyoc_attribute_selectors.dart';
import 'widgets/cyoc_creation_step_layout.dart';
import 'widgets/cyoc_section_header.dart';
import 'widgets/cyoc_selector_card.dart';

class CyocGenderStyleAgeScreen extends StatelessWidget {
  const CyocGenderStyleAgeScreen({required this.cubit, super.key});

  final CyocCreationCubit cubit;

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    final style = context.appStyle;
    return AutomationSemantics(
      identifier: 'cyoc_creation_gender_style_age_screen',
      child: BlocBuilder<CyocCreationCubit, CyocCreationState>(
        bloc: cubit,
        builder: (context, state) {
          return CyocCreationStepLayout(
            contentPadding: const EdgeInsets.only(top: 20),
            children: [
              CyocSectionHeader(title: strings.genderTitle),
              SizedBox(height: style.spacing.space1),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: style.spacing.space5),
                child: CyocGenderSelector(
                  selected: state.choice.gender,
                  onSelected: cubit.updateGender,
                ),
              ),
              SizedBox(height: style.spacing.space4),
              CyocSectionHeader(title: strings.cyocCreationStyleTitle),
              SizedBox(height: style.spacing.space1),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: style.spacing.space5),
                child: Row(
                  children: [
                    for (final photoStyle in CyocPhotoStyle.values) ...[
                      if (photoStyle != CyocPhotoStyle.values.first)
                        SizedBox(width: style.spacing.space3),
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: CyocSelectorCard.aspectRatio,
                          child: CyocSelectorCard<CyocPhotoStyle>(
                            width: null,
                            height: null,
                            value: photoStyle,
                            selected: photoStyle == state.choice.style,
                            onChanged: cubit.updateStyle,
                            title: switch (photoStyle) {
                              CyocPhotoStyle.realistic => strings.cyocCreationStyleRealistic,
                              CyocPhotoStyle.anime => strings.cyocCreationStyleAnime,
                            },
                            imageUrl: cubit.assetUrl(
                              photoStyle.assetKey(gender: state.choice.gender),
                            ),
                            semanticsIdentifier: 'cyoc_creation_style_${photoStyle.assetSlug}',
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: style.spacing.space4),
              CyocSectionHeader(title: strings.ageTitle),
              SizedBox(height: style.spacing.space1),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: style.spacing.space5),
                child: CyocAgeSlider(age: state.choice.age, onChanged: cubit.updateAge),
              ),
            ],
          );
        },
      ),
    );
  }
}
