// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebSocketEvent _$WebSocketEventFromJson(Map<String, dynamic> json) =>
    WebSocketEvent(
      type: json['type'] as String,
      uuid: json['uuid'] as String?,
      username: json['username'] as String?,
      message: json['message'] as String?,
      cards: (json['cards'] as List<dynamic>?)
          ?.map((e) => PlayingCard.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WebSocketEventToJson(WebSocketEvent instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'type': instance.type,
      'username': instance.username,
      'message': instance.message,
      'cards': instance.cards,
    };
