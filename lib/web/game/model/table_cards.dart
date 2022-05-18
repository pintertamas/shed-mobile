import 'package:websocket_mobile/common/model/playing_card.dart';

class TableCards {
  TableCards(this.picks, this.throws);

  final List<PlayingCard> picks;
  final List<PlayingCard> throws;
}
