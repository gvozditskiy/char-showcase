part of 'cyoc_creation_cubit.dart';

enum CyocCreationToast { none, generationFailed, creationFailed }

class CyocCreationState extends Equatable {
  const CyocCreationState({
    this.choice = const CyocCharacterChoice(),
    this.relationship,
    this.generation = const CyocGenerationProgress(),
    this.processing = false,
    this.toast = CyocCreationToast.none,
  });

  final CyocCharacterChoice choice;
  final CyocRelationshipType? relationship;
  final CyocGenerationProgress generation;
  final bool processing;
  final CyocCreationToast toast;

  CyocGenerationResult? get result => generation.result;

  bool get canCreateCharacter =>
      choice.name.trim().isNotEmpty && relationship != null && generation.hasResult;

  CyocCreationState copyWith({
    CyocCharacterChoice? choice,
    CyocRelationshipType? relationship,
    CyocGenerationProgress? generation,
    bool? processing,
    CyocCreationToast? toast,
  }) {
    return CyocCreationState(
      choice: choice ?? this.choice,
      relationship: relationship ?? this.relationship,
      generation: generation ?? this.generation,
      processing: processing ?? this.processing,
      toast: toast ?? this.toast,
    );
  }

  @override
  List<Object?> get props => [choice, relationship, generation, processing, toast];
}
