import 'package:navigation/navigation.dart';

class CardsPath extends PathInfo {
  const CardsPath(super.path, super.name);

  static const characterIdParam = 'characterId';

  static const cardsMain = CardsPath('/cards', 'cards_deck');
  static const cardDetails = CardsPath('/card-details', 'card_details');
}
