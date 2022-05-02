import 'package:websocket_mobile/common/model/card.dart';

class WebSocketEvent {
  WebSocketEvent({
    this.type,
    this.username,
    this.message,
    this.validity,
    this.cards,
  });

  final String? type;
  final String? username;
  final String? validity;
  final String? message;
  final List<Card>? cards;
}
