import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:websocket_mobile/common/model/card.dart';
import 'package:websocket_mobile/common/model/game_cards.dart';
import 'package:websocket_mobile/common/service/game_service.dart';
import 'package:websocket_mobile/mobile/lobby/service/websocket_service.dart';

class GameProvider extends ChangeNotifier {
  final List<Card> _cardsInHand = [];
  final List<Card> _cardsUp = [];
  final List<Card> _cardsDown = [];

  final List<Card> _selectedCards = [];

  List<Card> get cardsInHand => _cardsInHand;

  List<Card> get cardsUp => _cardsUp;

  List<Card> get cardsDown => _cardsDown;

  List<Card> get selectedCards => _selectedCards;

  GameCards setCards(GameCards gameCards) {
    _cardsInHand.clear();
    _cardsUp.clear();
    _cardsDown.clear();
    _cardsInHand.addAll(gameCards.cardsInHand);
    _cardsUp.addAll(gameCards.cardsUp);
    _cardsDown.addAll(gameCards.cardsDown);
    notifyListeners();
    return gameCards;
  }

  void selectCard(Card newCard) {
    if (selectedCards.isEmpty) selectedCards.add(newCard);
    if (selectedCards.first.number == newCard.number) {
      selectedCards.add(newCard);
    } else {
      selectedCards.clear();
      selectedCards.add(newCard);
    }
    notifyListeners();
  }

  Future<void> playCards(WebSocketService webSocketService) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String username = prefs.getString('username') ?? 'unknown';
    final String channel = await GameService.getGameName();

    webSocketService.sendAction(
      channel,
      username,
      selectedCards,
    );
  }

  void deletePlayedCards() {
    for (final card in selectedCards) {
      removeCardFromHand(card);
      removeCardFromTableUp(card);
      removeCardFromTableDown(card);
    }
    selectedCards.clear();
    notifyListeners();
  }

  void removeCardFromHand(Card card) {
    _cardsInHand.remove(card);
    notifyListeners();
  }

  void removeCardFromTableDown(Card card) {
    _cardsDown.remove(card);
    notifyListeners();
  }

  void removeCardFromTableUp(Card card) {
    _cardsUp.remove(card);
    notifyListeners();
  }
}
