import 'package:character_data/character_data.dart';
import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';

import '../../../../../l10n/l10n.dart';
import '../../../../models/cyoc_character_choice.dart';
import '../../../../models/cyoc_relationship_type.dart';

const creationGenders = [CharacterGender.female, CharacterGender.male, CharacterGender.nonBinary];

class CyocGenderSelector extends StatelessWidget {
  const CyocGenderSelector({required this.selected, required this.onSelected, super.key});

  final CharacterGender selected;
  final ValueChanged<CharacterGender> onSelected;

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    final style = context.appStyle;
    return Wrap(
      spacing: style.spacing.space1,
      runSpacing: style.spacing.space1,
      children: [
        for (final gender in creationGenders)
          CyocPillSelector(
            icon: switch (gender) {
              CharacterGender.female => Icons.female_rounded,
              CharacterGender.male => Icons.male_rounded,
              _ => Icons.transgender_rounded,
            },
            label: switch (gender) {
              CharacterGender.female => strings.genderFemale,
              CharacterGender.male => strings.genderMale,
              CharacterGender.nonBinary => strings.genderNonBinary,
              _ => strings.genderUnspecified,
            },
            selected: gender == selected,
            onTap: () => onSelected(gender),
            semanticsIdentifier: 'cyoc_creation_gender_${gender.name}',
          ),
      ],
    );
  }
}

class CyocPillSelector extends StatelessWidget {
  const CyocPillSelector({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.semanticsIdentifier,
    this.icon,
    super.key,
  });

  final IconData? icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final String semanticsIdentifier;

  static const double iconSize = 16;
  static const double checkSize = 12;
  static const double horizontalPadding = 12;
  static const double verticalPadding = 8;
  static const double labelGap = 5;
  static const double checkTickSize = 9;

  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;
    final palette = context.palette;
    final iconData = icon;
    return AutomationSemantics(
      identifier: semanticsIdentifier,
      button: true,
      selected: selected,
      enabled: true,
      child: ClickDetector(
        onClick: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: palette.surfaceWhite,
                borderRadius: style.radii.pillAll,
                border: Border.all(
                  color: selected ? palette.outlineFixedAccent : palette.surfaceExtraLight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (iconData != null) ...[
                      Icon(iconData, size: iconSize, color: palette.iconOnSurfacePrimary),
                      const SizedBox(width: labelGap),
                    ],
                    Text(
                      label,
                      style: style.text.subtitle3.copyWith(color: palette.textOnSurfacePrimary),
                    ),
                  ],
                ),
              ),
            ),
            if (selected)
              const Positioned(
                right: 0,
                top: 0,
                child: CheckMark(selected: true, size: checkSize, tickSize: checkTickSize),
              ),
          ],
        ),
      ),
    );
  }
}

class CyocRelationshipSelector extends StatelessWidget {
  const CyocRelationshipSelector({required this.selected, required this.onSelected, super.key});

  final CyocRelationshipType? selected;
  final ValueChanged<CyocRelationshipType> onSelected;

  static const double _itemSpacing = 8;

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final relationship in CyocRelationshipType.values) ...[
          if (relationship != CyocRelationshipType.values.first)
            const SizedBox(height: _itemSpacing),
          CyocListSelector(
            emoji: relationship.emoji,
            label: switch (relationship) {
              CyocRelationshipType.strangers => strings.cyocCreationRelationshipStrangers,
              CyocRelationshipType.friends => strings.cyocCreationRelationshipFriends,
              CyocRelationshipType.friendsWithBenefits =>
                strings.cyocCreationRelationshipFriendsWithBenefits,
              CyocRelationshipType.dating => strings.cyocCreationRelationshipDating,
              CyocRelationshipType.affair => strings.cyocCreationRelationshipAffair,
              CyocRelationshipType.married => strings.cyocCreationRelationshipMarried,
            },
            selected: relationship == selected,
            onTap: () => onSelected(relationship),
            semanticsIdentifier: 'cyoc_creation_relationship_${relationship.name}',
          ),
        ],
      ],
    );
  }
}

class CyocListSelector extends StatelessWidget {
  const CyocListSelector({
    required this.emoji,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.semanticsIdentifier,
    super.key,
  });

  final String emoji;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final String semanticsIdentifier;

  static const double height = 60;
  static const double emojiSize = 30;
  static const double emojiFontSize = 28;
  static const double horizontalPadding = 20;
  static const double contentGap = 16;
  static const double borderRadius = 25;

  @override
  Widget build(BuildContext context) {
    final style = context.appStyle;
    final palette = context.palette;
    return AutomationSemantics(
      identifier: semanticsIdentifier,
      button: true,
      selected: selected,
      enabled: true,
      child: ClickDetector(
        onClick: onTap,
        child: SizedBox(
          height: height,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: palette.surfaceWhite,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: selected ? palette.outlineFixedAccent : palette.outlineDefault,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Row(
                children: [
                  SizedBox(
                    width: emojiSize,
                    height: emojiSize,
                    child: Center(
                      child: Text(
                        emoji,
                        style: const TextStyle(
                          fontSize: emojiFontSize,
                          height: emojiSize / emojiFontSize,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: contentGap),
                  Expanded(
                    child: Text(
                      label,
                      style: style.text.subtitle2.copyWith(color: palette.textOnSurfacePrimary),
                    ),
                  ),
                  const SizedBox(width: contentGap),
                  CheckMark(selected: selected, unselectedBorderColor: palette.outlineDefault),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CyocAgeSlider extends StatefulWidget {
  const CyocAgeSlider({required this.age, required this.onChanged, super.key});

  final int age;
  final ValueChanged<int> onChanged;

  static const int minAge = CyocCharacterChoice.minAge;
  static const int maxAge = CyocCharacterChoice.maxAge;
  static const double sliderHeight = 24;
  static const double trackHeight = 6;
  static const double thumbSize = 18;

  @override
  State<CyocAgeSlider> createState() => _CyocAgeSliderState();
}

class _CyocAgeSliderState extends State<CyocAgeSlider> {
  late int _age = widget.age;

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    final style = context.appStyle;
    final labelStyle = style.text.p1.copyWith(color: style.palette.textOnSurfacePrimary);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text('${CyocAgeSlider.minAge}', style: labelStyle),
            SizedBox(width: style.spacing.space2),
            Expanded(
              child: CharSlider(
                height: CyocAgeSlider.sliderHeight,
                trackHeight: CyocAgeSlider.trackHeight,
                thumbSize: CyocAgeSlider.thumbSize,
                fillFromStart: true,
                thumbStyle: CharSliderThumbStyle.accentElevated,
                min: CyocAgeSlider.minAge,
                max: CyocAgeSlider.maxAge,
                divisions: CyocAgeSlider.maxAge - CyocAgeSlider.minAge + 1,
                value: _age.toDouble(),
                onChanged: (value) {
                  final next = value.round();
                  if (next != _age) {
                    setState(() => _age = next);
                  }
                },
                onDragEnd: (value) {
                  setState(() => _age = value);
                  widget.onChanged(value);
                },
                onDragStart: () {},
                onDragCancel: () {},
              ),
            ),
            SizedBox(width: style.spacing.space2),
            Text(strings.cyocCreationAgeMax, style: labelStyle),
          ],
        ),
        SizedBox(height: style.spacing.space2),
        Text(
          _age >= CyocAgeSlider.maxAge
              ? strings.cyocCreationAgeMax
              : strings.cyocCreationAgeYearsOld(_age),
          textAlign: TextAlign.center,
          style: style.text.subtitle2.copyWith(color: style.palette.textOnSurfacePrimary),
        ),
      ],
    );
  }
}
