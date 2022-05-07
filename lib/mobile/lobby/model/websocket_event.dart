import 'package:websocket_mobile/common/model/card.dart';

class WebSocketEvent {
  WebSocketEvent({
    required this.type,
    this.username,
    this.message,
    this.cards,
  });

  final String type;
  final String? username;
  final String? message;
  final List<Card>? cards;
}
