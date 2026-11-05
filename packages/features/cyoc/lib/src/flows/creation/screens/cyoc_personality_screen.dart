import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/l10n.dart';
import '../../../models/builder_attributes.dart';
import '../cyoc_creation_cubit.dart';
import 'widgets/cyoc_attribute_labels.dart';
import 'widgets/cyoc_creation_step_layout.dart';
import 'widgets/cyoc_selector_carousel.dart';

class CyocPersonalityScreen extends StatelessWidget {
  const CyocPersonalityScreen({required this.cubit, super.key});

  final CyocCreationCubit cubit;

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    final style = context.appStyle;
    return AutomationSemantics(
      identifier: 'cyoc_creation_personality_screen',
      child: BlocBuilder<CyocCreationCubit, CyocCreationState>(
        bloc: cubit,
        builder: (context, state) {
          final selected = state.choice.personality;
          final activeIndex = selected == null ? 0 : CyocPersonality.values.indexOf(selected);
          return CyocCreationStepLayout(
            contentPadding: const EdgeInsets.only(top: 20),
            children: [
              CyocSelectorCarousel<CyocPersonality>(
                title: strings.cyocCreationPersonalityTitle,
                options: CyocPersonality.values,
                selected: state.choice.personality,
                onChanged: cubit.updatePersonality,
                titleOf: (value) => value.label(strings),
                imageUrlOf: (value) => cubit.assetUrl(
                  value.assetKey(gender: state.choice.gender, style: state.choice.style),
                ),
                semanticsPrefix: 'cyoc_creation_personality',
                idOf: (value) => value.assetSlug,
                titleGap: style.spacing.space5,
                isCompact: true,
              ),
              SizedBox(height: style.spacing.space5),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: style.spacing.space5),
                child: Center(
                  child: CharDotsIndicator(
                    total: CyocPersonality.values.length,
                    activeIndex: activeIndex,
                    activeColor: style.palette.iconOnSurfacePrimary,
                    inactiveColor: style.palette.surfaceLight,
                  ),
                ),
              ),
              SizedBox(height: style.spacing.space5),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: style.spacing.space5),
                child: IndexedStack(
                  index: activeIndex,
                  alignment: Alignment.topCenter,
                  children: [
                    for (final personality in CyocPersonality.values)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            personality.label(strings),
                            textAlign: TextAlign.center,
                            style: style.text.subtitle2.copyWith(
                              color: style.palette.textOnSurfacePrimary,
                            ),
                          ),
                          Text(
                            personality.description(strings),
                            textAlign: TextAlign.center,
                            style: style.text.p2.copyWith(
                              color: style.palette.textOnSurfaceSecondary,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
