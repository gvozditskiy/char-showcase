import 'package:character_data/character_data.dart';
import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';

class CharacterFeedAvatar extends StatelessWidget {
  const CharacterFeedAvatar({required this.character, this.dimension = 58, super.key});

  final CharacterModel character;
  final double dimension;

  @override
  Widget build(BuildContext context) {
    final image = character.avatar?.image ?? '';
    return SizedBox.square(
      dimension: dimension,
      child: ClipOval(
        child: image.isNotEmpty
            ? Image.asset(image, fit: BoxFit.cover)
            : ColoredBox(color: context.palette.surfaceTranslucentFixedBlack),
      ),
    );
  }
}
