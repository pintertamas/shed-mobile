import 'package:flutter/cupertino.dart';
import 'package:websocket_mobile/common/model/card.dart';
import 'package:websocket_mobile/common/model/card_state.dart';
import 'package:websocket_mobile/common/model/game_cards.dart';
import 'package:websocket_mobile/common/service/game_service.dart';
import 'package:websocket_mobile/mobile/lobby/service/websocket_service.dart';
import 'package:websocket_mobile/mobile/user_management/service/user_service.dart';

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
    if (selectedCards.contains(newCard)) {
      selectedCards.remove(newCard);
    } else if (cardsInHand.isNotEmpty) {
      if (selectedCards.isEmpty && newCard.state == CardState.Hand) {
        selectedCards.add(newCard);
      }
      if (newCard.state != CardState.Hand) {
        if (newCard.state == CardState.Invisible) {
          notifyListeners();
          return;
        }
        for (final Card card in cardsInHand) {
          if (!selectedCards.contains(card)) {
            notifyListeners();
            return;
          }
        }
        if (selectedCards.first.number == newCard.number) {
          selectedCards.add(newCard);
        }
      }
    } else if (cardsUp.isNotEmpty) {
      if (newCard.state == CardState.Invisible) {
        notifyListeners();
        return;
      } else if (selectedCards.isEmpty && newCard.state == CardState.Visible) {
        selectedCards.add(newCard);
      }
    } else if (selectedCards.isNotEmpty &&
        selectedCards.first.number == newCard.number) {
      selectedCards.add(newCard);
    } else {
      selectedCards.clear();
      selectedCards.add(newCard);
    }
    notifyListeners();
  }

  Future<void> playCards(WebSocketService webSocketService) async {
    final String username = await UserService.getUsername();
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
