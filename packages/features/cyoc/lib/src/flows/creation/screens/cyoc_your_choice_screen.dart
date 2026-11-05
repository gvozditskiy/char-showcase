import 'package:character_data/character_data.dart';
import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/l10n.dart';
import '../../../models/character_gender_asset_slug.dart';
import '../../../models/cyoc_character_choice.dart';
import '../../../models/cyoc_photo_style.dart';
import '../cyoc_creation_cubit.dart';
import 'widgets/cyoc_attribute_labels.dart';
import 'widgets/cyoc_creation_step_layout.dart';
import 'widgets/cyoc_section_header.dart';
import 'widgets/cyoc_selector_card.dart';

class CyocYourChoiceScreen extends StatelessWidget {
  const CyocYourChoiceScreen({required this.cubit, super.key});

  final CyocCreationCubit cubit;

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    final style = context.appStyle;
    return AutomationSemantics(
      identifier: 'cyoc_creation_your_choice_screen',
      child: BlocBuilder<CyocCreationCubit, CyocCreationState>(
        bloc: cubit,
        buildWhen: (previous, current) => previous.choice != current.choice,
        builder: (context, state) {
          final choice = state.choice;
          return CyocCreationStepLayout(
            contentPadding: const EdgeInsets.only(top: 20),
            children: [
              CyocSectionHeader(title: strings.cyocCreationYourChoiceTitle),
              SizedBox(height: style.spacing.space1),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: style.spacing.space5),
                child: _ChoiceCardsGrid(cards: _choiceCards(strings, choice, cubit.assetUrl)),
              ),
            ],
          );
        },
      ),
    );
  }

  String _styleLabel(AppLocalizations strings, CyocPhotoStyle style) {
    return switch (style) {
      CyocPhotoStyle.realistic => strings.cyocCreationStyleRealistic,
      CyocPhotoStyle.anime => strings.cyocCreationStyleAnime,
    };
  }

  List<CyocChoiceCard> _choiceCards(
    AppLocalizations strings,
    CyocCharacterChoice choice,
    String Function(String key) resolveAssetUrl,
  ) {
    final ethnicity = choice.ethnicity;
    final bodyType = choice.bodyType;
    final hairStyle = choice.hairStyle;
    final hairColor = choice.hairColor;
    final eyeColor = choice.eyeColor;
    final facialHair = choice.facialHair;
    final personality = choice.personality;
    return [
      CyocChoiceCard(
        title: switch (choice.gender) {
          CharacterGender.female => strings.genderFemale,
          CharacterGender.male => strings.genderMale,
          CharacterGender.nonBinary => strings.genderNonBinary,
          _ => strings.genderUnspecified,
        },
        imageUrl: resolveAssetUrl(choice.gender.assetKey),
        semanticsIdentifier: 'cyoc_creation_choice_gender',
      ),
      CyocChoiceCard(
        title: _styleLabel(strings, choice.style),
        imageUrl: resolveAssetUrl(choice.style.assetKey(gender: choice.gender)),
        semanticsIdentifier: 'cyoc_creation_choice_style',
      ),
      CyocChoiceCard(
        title: strings.cyocCreationChoiceAgeYears(choice.age),
        image: const CyocAgeCardArt(),
        semanticsIdentifier: 'cyoc_creation_choice_age',
      ),
      if (ethnicity != null)
        CyocChoiceCard(
          title: ethnicity.label(strings),
          imageUrl: resolveAssetUrl(ethnicity.assetKey(gender: choice.gender, style: choice.style)),
          semanticsIdentifier: 'cyoc_creation_choice_ethnicity',
        ),
      if (bodyType != null)
        CyocChoiceCard(
          title: bodyType.label(strings),
          imageUrl: resolveAssetUrl(bodyType.assetKey(gender: choice.gender, style: choice.style)),
          semanticsIdentifier: 'cyoc_creation_choice_body_type',
        ),
      if (hairStyle != null)
        CyocChoiceCard(
          title: hairStyle.label(strings),
          imageUrl: resolveAssetUrl(hairStyle.assetKey(gender: choice.gender, style: choice.style)),
          semanticsIdentifier: 'cyoc_creation_choice_hair_style',
        ),
      if (hairColor != null)
        CyocChoiceCard(
          title: hairColor.label(strings),
          imageUrl: resolveAssetUrl(hairColor.assetKey(style: choice.style)),
          semanticsIdentifier: 'cyoc_creation_choice_hair_color',
        ),
      if (eyeColor != null)
        CyocChoiceCard(
          title: eyeColor.label(strings),
          imageUrl: resolveAssetUrl(eyeColor.assetKey(style: choice.style)),
          semanticsIdentifier: 'cyoc_creation_choice_eye_color',
        ),
      if (facialHair != null)
        CyocChoiceCard(
          title: facialHair.label(strings),
          imageUrl: resolveAssetUrl(facialHair.assetKey(style: choice.style)),
          semanticsIdentifier: 'cyoc_creation_choice_facial_hair',
        ),
      if (personality != null)
        CyocChoiceCard(
          title: personality.label(strings),
          imageUrl: resolveAssetUrl(
            personality.assetKey(gender: choice.gender, style: choice.style),
          ),
          semanticsIdentifier: 'cyoc_creation_choice_personality',
        ),
    ];
  }
}

class _ChoiceCardsGrid extends StatelessWidget {
  const _ChoiceCardsGrid({required this.cards});

  final List<CyocChoiceCard> cards;

  static const _cardsPerRow = 3;

  @override
  Widget build(BuildContext context) {
    final gap = context.appStyle.spacing.space1;
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - gap * (_cardsPerRow - 1)) / _cardsPerRow;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [for (final card in cards) SizedBox(width: cardWidth, child: card)],
        );
      },
    );
  }
}
