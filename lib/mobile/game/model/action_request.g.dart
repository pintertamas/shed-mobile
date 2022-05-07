// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActionRequest _$ActionRequestFromJson(Map<String, dynamic> json) =>
    ActionRequest(
      json['username'] as String,
      (json['cards'] as List<dynamic>)
          .map((e) => Card.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ActionRequestToJson(ActionRequest instance) =>
    <String, dynamic>{
      'username': instance.username,
      'cards': instance.cards,
    };
