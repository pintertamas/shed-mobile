import 'package:websocket_mobile/common/model/card.dart';
import 'package:json_annotation/json_annotation.dart';

part 'action_request.g.dart';

@JsonSerializable()
class ActionRequest {
  ActionRequest(this.username, this.cards);

  factory ActionRequest.fromJson(Map<String, dynamic> json) => _$ActionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ActionRequestToJson(this);

  String username;
  List<Card> cards;
}
