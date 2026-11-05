import 'package:equatable/equatable.dart';

import 'character.dart';

class CharacterFeedModel extends Equatable {
  const CharacterFeedModel({required this.characters, required this.nextCursor});

  final List<CharacterModel> characters;
  final String? nextCursor;

  @override
  List<Object?> get props => [characters, nextCursor];
}
