import 'package:websocket_mobile/common/model/card.dart';

class GameCards {
  GameCards(this.cardsInHand, this.cardsUp, this.cardsDown);

  List<Card> cardsInHand = [];
  List<Card> cardsUp = [];
  List<Card> cardsDown = [];
}
