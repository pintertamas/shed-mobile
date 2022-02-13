import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'color_message.g.dart';

@JsonSerializable()
class ColorMessage {
  final int red;
  final int green;
  final int blue;

  ColorMessage({required this.red, required this.green, required this.blue});

  factory ColorMessage.fromJson(Map<String, dynamic> json) =>
      _$ColorMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ColorMessageToJson(this);
}
