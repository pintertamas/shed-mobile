import 'package:websocket_mobile/common/model/playing_card.dart';

class PlayerData {
  PlayerData(this.username, this.cardsUp, this.cardsDown);

  final String username;
  final List<PlayingCard> cardsUp;
  final List<PlayingCard> cardsDown;
}
