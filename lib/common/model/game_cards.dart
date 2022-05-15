import 'package:websocket_mobile/common/model/playing_card.dart';

class GameCards {
  GameCards(this.cardsInHand, this.cardsUp, this.cardsDown);

  List<PlayingCard> cardsInHand = [];
  List<PlayingCard> cardsUp = [];
  List<PlayingCard> cardsDown = [];
}
