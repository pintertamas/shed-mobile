import 'package:websocket_mobile/common/model/card.dart';

class PlayMessage {
  PlayMessage(this.username, this.cards);

  String username;
  List<Card> cards;
}
