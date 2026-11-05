part of 'card_details_cubit.dart';

enum CardDetailsToastType { none, likeError }

class CardDetailsState extends Equatable {
  const CardDetailsState({
    this.character,
    this.toastType = CardDetailsToastType.none,
    this.processing = false,
    this.loadingInfo = false,
  });

  final CharacterModel? character;
  final CardDetailsToastType toastType;
  final bool processing;
  final bool loadingInfo;

  @override
  List<Object?> get props => [character, toastType, processing, loadingInfo];

  CardDetailsState copyWith({
    CharacterModel? character,
    CardDetailsToastType? toastType,
    bool? processing,
    bool? loadingInfo,
  }) {
    return CardDetailsState(
      character: character ?? this.character,
      toastType: toastType ?? this.toastType,
      processing: processing ?? this.processing,
      loadingInfo: loadingInfo ?? this.loadingInfo,
    );
  }
}
