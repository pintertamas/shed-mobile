// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playing_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayingCard _$PlayingCardFromJson(Map<String, dynamic> json) => PlayingCard(
      json['cardConfigId'] as int,
      json['number'] as int,
      $enumDecode(_$ShapeEnumMap, json['shape']),
      $enumDecode(_$RuleEnumMap, json['rule']),
      $enumDecode(_$CardStateEnumMap, json['state']),
    );

Map<String, dynamic> _$PlayingCardToJson(PlayingCard instance) =>
    <String, dynamic>{
      'cardConfigId': instance.id,
      'number': instance.number,
      'shape': _$ShapeEnumMap[instance.shape],
      'rule': _$RuleEnumMap[instance.rule],
      'state': _$CardStateEnumMap[instance.state],
    };

const _$ShapeEnumMap = {
  Shape.Clubs: 'Clubs',
  Shape.Diamonds: 'Diamonds',
  Shape.Hearts: 'Hearts',
  Shape.Spades: 'Spades',
};

const _$RuleEnumMap = {
  Rule.None: 'None',
  Rule.Invisible: 'Invisible',
  Rule.Jolly_Joker: 'Jolly_Joker',
  Rule.Burner: 'Burner',
  Rule.Reducer: 'Reducer',
};

const _$CardStateEnumMap = {
  CardState.Hand: 'Hand',
  CardState.Visible: 'Visible',
  CardState.Invisible: 'Invisible',
};
