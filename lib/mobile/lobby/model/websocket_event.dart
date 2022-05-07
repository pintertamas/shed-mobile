import 'package:websocket_mobile/common/model/card.dart';
import 'package:json_annotation/json_annotation.dart';

part 'websocket_event.g.dart';

@JsonSerializable()
class WebSocketEvent {
  WebSocketEvent({
    required this.type,
    this.uuid,
    this.username,
    this.message,
    this.cards,
  });

  factory WebSocketEvent.fromJson(Map<String, dynamic> json) => _$WebSocketEventFromJson(json);

  Map<String, dynamic> toJson() => _$WebSocketEventToJson(this);

  final String? uuid;
  final String type;
  final String? username;
  final String? message;
  final List<Card>? cards;
}
