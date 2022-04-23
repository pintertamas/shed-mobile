import 'package:json_annotation/json_annotation.dart';

part 'card_rule.g.dart';

@JsonSerializable()
class CardRule {
  CardRule(this.number, this.rule);

  int number;
  String rule;

  factory CardRule.fromJson(Map<String, dynamic> json) =>
      _$CardRuleFromJson(json);

  Map<String, dynamic> toJson() => _$CardRuleToJson(this);
}
