import 'package:websocket_mobile/common/model/card.dart';

class GameEvent {
  GameEvent(this.validity, this.username, this.message, this.cards);

  final String validity;
  final String username;
  final String message;
  final List<Card> cards;
}
