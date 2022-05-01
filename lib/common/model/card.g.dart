// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Card _$CardFromJson(Map<String, dynamic> json) => Card(
      json['number'] as int,
      $enumDecode(_$ShapeEnumMap, json['shape']),
      $enumDecode(_$RuleEnumMap, json['rule']),
    );

Map<String, dynamic> _$CardToJson(Card instance) => <String, dynamic>{
      'number': instance.number,
      'shape': _$ShapeEnumMap[instance.shape],
      'rule': _$RuleEnumMap[instance.rule],
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
