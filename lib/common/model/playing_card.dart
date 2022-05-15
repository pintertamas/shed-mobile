import 'package:json_annotation/json_annotation.dart';
import 'package:websocket_mobile/common/model/card_state.dart';
import 'package:websocket_mobile/common/model/rule.dart';
import 'package:websocket_mobile/common/model/shape.dart';

part 'playing_card.g.dart';

@JsonSerializable()
class PlayingCard {
  PlayingCard(
    this.id,
    this.number,
    this.shape,
    this.rule,
    this.state,
  );

  factory PlayingCard.fromJson(Map<String, dynamic> json) => _$PlayingCardFromJson(json);

  Map<String, dynamic> toJson() => _$PlayingCardToJson(this);

  @JsonKey(name: 'cardConfigId')
  int id;
  int number;
  Shape shape;
  Rule rule;
  CardState state;
}
