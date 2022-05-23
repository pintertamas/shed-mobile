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

  bool isEveryCardSelected() {
    for (final PlayingCard card in _cardsInHand) {
      if (!containsCard(_selectedCards, card)) return false;
    }
    return true;
  }

  void selectNewCard(PlayingCard newCard) {
    if (_selectedCards.isNotEmpty &&
        newCard.number != _selectedCards.first.number) {
      _selectedCards.clear();
      _selectedCards.add(newCard);
    } else {
      _selectedCards.add(newCard);
    }
  }

  void selectCard(PlayingCard newCard) {
    if (containsCard(_selectedCards, newCard)) {
      _selectedCards.remove(newCard);
    } else if (newCard.state == CardState.Hand) {
      selectNewCard(newCard);
    } else if (newCard.state == CardState.Visible) {
      if (_cardsInHand.isNotEmpty || !isEveryCardSelected()) {
        return;
      } else {
        selectNewCard(newCard);
      }
    } else if (newCard.state == CardState.Invisible) {
      if (_cardsInHand.isNotEmpty || _cardsUp.isNotEmpty) {
        return;
      }
      _selectedCards.clear();
      _selectedCards.add(newCard);
    }
    notifyListeners();
  }

  Future<void> playCards(WebSocketService webSocketService) async {
    final String username = await UserService.getUsername();
    final String channel = await GameService.getGameName();

    webSocketService.sendAction(
      channel,
      username,
      _selectedCards,
    );
  }

  void deletePlayedCards() {
    print('length of selected cards: ${_selectedCards.length}');
    for (final card in _selectedCards) {
      print('1) length of cards in hand: ${_cardsInHand.length}');
      removeCardsFromListOfCards(card, _cardsInHand);
      removeCardsFromListOfCards(card, _cardsUp);
      removeCardsFromListOfCards(card, _cardsDown);
      print('2) length of cards in hand: ${_cardsInHand.length}');
    }
    notifyListeners();
  }

  void removeCardsFromListOfCards(PlayingCard card, List<PlayingCard> cards) {
    for (int i = 0; i < cards.length; i++) {
      if (cards[i].id == card.id) {
        cards.remove(cards[i]);
        print('removing card no. ${card.number} from $cards');
        notifyListeners();
      }
    }
  }
}
