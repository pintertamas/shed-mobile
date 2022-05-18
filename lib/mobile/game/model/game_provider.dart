import 'package:flutter/cupertino.dart';
import 'package:websocket_mobile/common/model/card_state.dart';
import 'package:websocket_mobile/common/model/game_cards.dart';
import 'package:websocket_mobile/common/model/playing_card.dart';
import 'package:websocket_mobile/common/service/game_service.dart';
import 'package:websocket_mobile/mobile/lobby/service/websocket_service.dart';
import 'package:websocket_mobile/mobile/user_management/service/user_service.dart';

class GameProvider with ChangeNotifier {
  final List<PlayingCard> _cardsInHand = [];
  final List<PlayingCard> _cardsUp = [];
  final List<PlayingCard> _cardsDown = [];

  final List<PlayingCard> _selectedCards = [];

  List<PlayingCard> get cardsInHand => _cardsInHand;

  List<PlayingCard> get cardsUp => _cardsUp;

  List<PlayingCard> get cardsDown => _cardsDown;

  List<PlayingCard> get selectedCards => _selectedCards;

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

  bool containsCard(List<PlayingCard> cards, PlayingCard card) {
    for (final PlayingCard _card in cards) {
      if (_card.id == card.id) return true;
    }
    return false;
  }

  void selectCard(PlayingCard newCard) {
    if (containsCard(selectedCards, newCard)) {
      selectedCards.remove(newCard);
    } else if (cardsInHand.isNotEmpty) {
      if (newCard.state == CardState.Hand) {
        if (selectedCards.isNotEmpty) {
          selectedCards.clear();
        }
        selectedCards.add(newCard);
      } else if (newCard.state != CardState.Hand) {
        if (newCard.state == CardState.Invisible) {
          notifyListeners();
          return;
        }
        for (final PlayingCard card in cardsInHand) {
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
    print('length of selected cards: ${selectedCards.length}');

    for (final card in selectedCards) {
      print('1) length of cards in hand: ${cardsInHand.length}');
      removeCardsFromListOfCards(card, cardsInHand);
      removeCardsFromListOfCards(card, cardsUp);
      removeCardsFromListOfCards(card, cardsDown);
      print('2) length of cards in hand: ${cardsInHand.length}');
    }
    selectedCards.clear();
    notifyListeners();
  }

  void removeCardsFromListOfCards(PlayingCard card, List<PlayingCard> cards) {
    for(int i = 0; i < cards.length; i++) {
      if (cards[i].id == card.id) {
        cards.remove(cards[i]);
        print('removing card no. ${card.number} from $cards');
      }
    }
    notifyListeners();
  }
}
