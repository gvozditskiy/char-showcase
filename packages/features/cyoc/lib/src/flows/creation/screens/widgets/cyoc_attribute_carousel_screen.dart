import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/cyoc_character_choice.dart';
import '../../cyoc_creation_cubit.dart';
import 'cyoc_creation_step_layout.dart';
import 'cyoc_selector_carousel.dart';

class CyocAttributeCarouselScreen<T> extends StatelessWidget {
  const CyocAttributeCarouselScreen({
    required this.cubit,
    required this.screenSemanticsIdentifier,
    required this.title,
    required this.options,
    required this.selected,
    required this.onChanged,
    required this.titleOf,
    required this.imageUrlOf,
    required this.idOf,
    required this.semanticsPrefix,
    required this.isCompact,
    super.key,
  });

  final CyocCreationCubit cubit;
  final String screenSemanticsIdentifier;
  final String title;
  final List<T> Function(CyocCharacterChoice choice) options;
  final T? Function(CyocCharacterChoice choice) selected;
  final ValueChanged<T> onChanged;
  final String Function(T value) titleOf;
  final String Function(T value, CyocCharacterChoice choice) imageUrlOf;
  final String Function(T value) idOf;
  final String semanticsPrefix;

  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return AutomationSemantics(
      identifier: screenSemanticsIdentifier,
      child: BlocBuilder<CyocCreationCubit, CyocCreationState>(
        bloc: cubit,
        buildWhen: (previous, current) => previous.choice != current.choice,
        builder: (context, state) {
          return CyocCreationStepLayout(
            contentPadding: const EdgeInsets.only(top: 20),
            children: [
              CyocSelectorCarousel<T>(
                title: title,
                options: options(state.choice),
                selected: selected(state.choice),
                onChanged: onChanged,
                titleOf: titleOf,
                imageUrlOf: (value) => imageUrlOf(value, state.choice),
                semanticsPrefix: semanticsPrefix,
                idOf: idOf,
                isCompact: isCompact,
              ),
            ],
          );
        },
      ),
    );
  }
}
