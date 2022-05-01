import 'package:flutter/cupertino.dart';
import 'package:websocket_mobile/mobile/common/model/card.dart';
import 'package:websocket_mobile/mobile/common/model/rule.dart';
import 'package:websocket_mobile/mobile/common/model/shape.dart';

class GameProvider extends ChangeNotifier {
  List<Card> cardsInHand = [
    Card(6, Shape.DIAMONDS, Rule.NONE),
    Card(7, Shape.DIAMONDS, Rule.JOLLY_JOKER),
    Card(8, Shape.DIAMONDS, Rule.BURNER),
    Card(9, Shape.DIAMONDS, Rule.INVISIBLE),
    Card(10, Shape.DIAMONDS, Rule.REDUCER),
    Card(10, Shape.HEARTS, Rule.REDUCER),
    Card(10, Shape.CLUBS, Rule.REDUCER),
    Card(10, Shape.SPADES, Rule.REDUCER),
  ];
  List<Card> cardsUp = [
    Card(11, Shape.DIAMONDS, Rule.NONE),
    Card(12, Shape.DIAMONDS, Rule.JOLLY_JOKER),
    Card(13, Shape.DIAMONDS, Rule.BURNER),
  ];
  List<Card> cardsDown = [
    Card(2, Shape.DIAMONDS, Rule.NONE),
    Card(3, Shape.DIAMONDS, Rule.JOLLY_JOKER),
    Card(4, Shape.DIAMONDS, Rule.BURNER),
  ];

  List<Card> selectedCards = [];

  void selectCard(Card newCard) {
    for (final card in selectedCards) {
      if (card.number == newCard.number) {
        selectedCards.add(newCard);
      } else {
        selectedCards.clear();
        selectedCards.add(newCard);
      }
    }
    notifyListeners();
  }

  void removeCardFromHand(Card card) {
    cardsInHand.remove(card);
    notifyListeners();
  }

  void removeCardFromTableDown(Card card) {
    cardsDown.remove(card);
    notifyListeners();
  }

  void removeCardFromTableUp(Card card) {
    cardsUp.remove(card);
    notifyListeners();
  }
}
