import 'package:flutter/material.dart';

class CreateGameProvider extends ChangeNotifier {
  CreateGameProvider() {
    for (int i = 0; i < 14; i++) {
      rules.add('None');
    }
  }

  bool isVisible = true;
  bool jokers = false;
  int numberOfDecks = 2;
  int numberOfCardsInHand = 3;
  final List<String> _rules = [];
  final List<String> _items = [
    'None',
    'Jolly_Joker',
    'Reducer',
    'Invisible',
    'Burner',
  ];

  List<String> get rules => _rules;

  List<String> get items => _items;
}
