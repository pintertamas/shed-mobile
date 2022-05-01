import 'package:json_annotation/json_annotation.dart';
import 'package:websocket_mobile/mobile/common/model/rule.dart';
import 'package:websocket_mobile/mobile/common/model/shape.dart';

part 'card.g.dart';

@JsonSerializable()
class Card {
  Card(this.number, this.shape, this.rule);

  factory Card.fromJson(Map<String, dynamic> json) => _$CardFromJson(json);

  Map<String, dynamic> toJson() => _$CardToJson(this);

  int number;
  Shape shape;
  Rule rule;
}
