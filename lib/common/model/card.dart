import 'package:json_annotation/json_annotation.dart';
import 'package:websocket_mobile/common/model/card_state.dart';
import 'package:websocket_mobile/common/model/rule.dart';
import 'package:websocket_mobile/common/model/shape.dart';

part 'card.g.dart';

@JsonSerializable()
class Card {
  Card(
    this.id,
    this.number,
    this.shape,
    this.rule,
    this.state,
  );

  factory Card.fromJson(Map<String, dynamic> json) => _$CardFromJson(json);

  Map<String, dynamic> toJson() => _$CardToJson(this);

  @JsonKey(name: 'cardConfigId')
  int id;
  int number;
  Shape shape;
  Rule rule;
  CardState state;
}
