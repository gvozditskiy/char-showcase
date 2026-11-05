import 'package:character_data/character_data.dart';
import 'package:equatable/equatable.dart';

class CyocGenerationResult extends Equatable {
  const CyocGenerationResult({required this.generationId, required this.avatar});

  final String generationId;
  final AvatarModel avatar;

  String get avatarUrl => avatar.image ?? '';

  @override
  List<Object?> get props => [generationId, avatar];
}
