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
  Shape.CLUBS: 'CLUBS',
  Shape.DIAMONDS: 'DIAMONDS',
  Shape.HEARTS: 'HEARTS',
  Shape.SPADES: 'SPADES',
};

const _$RuleEnumMap = {
  Rule.NONE: 'NONE',
  Rule.INVISIBLE: 'INVISIBLE',
  Rule.JOLLY_JOKER: 'JOLLY_JOKER',
  Rule.BURNER: 'BURNER',
  Rule.REDUCER: 'REDUCER',
};
