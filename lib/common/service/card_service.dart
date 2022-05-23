import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:websocket_mobile/common/model/card_state.dart';
import 'package:websocket_mobile/common/model/card_type.dart';
import 'package:websocket_mobile/common/model/game_cards.dart';
import 'package:websocket_mobile/common/model/playing_card.dart';
import 'package:websocket_mobile/common/service/game_service.dart';
import 'package:websocket_mobile/mobile/user_management/service/user_service.dart';

class CardService {
  CardService() {
    final options = BaseOptions(
      baseUrl: 'https://shed-backend.herokuapp.com',
      contentType: 'application/json',
      connectTimeout: 5000,
      receiveTimeout: 3000,
    );
    dio = Dio(options);
  }

  late Dio dio;

  Future<GameCards> fetchGameCards() async {
    final GameCards gameCards = GameCards([], [], []);
    gameCards.cardsInHand = await fetchCards(CardType.Player, CardState.Hand);
    gameCards.cardsUp = await fetchCards(CardType.Player, CardState.Visible);
    gameCards.cardsDown = await fetchCards(CardType.Player, CardState.Invisible);
    return gameCards;
  }

  Future<List<PlayingCard>> fetchCards(
    CardType type,
    CardState state, {
    String? username,
  }) async {
    final String jwtToken = await UserService.getJwtToken();
    final String _username = username ?? await UserService.getUsername();
    final String gameName = await GameService.getGameName();

    final uri = type == CardType.Player
        ? '/cards/player/$_username/${state.name}'
        : '/cards/table/$gameName/${state.name}';

    final Options playerOptions = Options(
      responseType: ResponseType.plain,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
    );

    final Options tableOptions = Options(
      responseType: ResponseType.plain,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    try {
      final response = await dio.get(
        uri,
        options: type == CardType.Player ? playerOptions : tableOptions,
      );
      print(response.requestOptions.uri);

      if (response.statusCode == 200) {
        final List<PlayingCard> cards = (jsonDecode(response.data.toString())
                as List)
            .map((card) => PlayingCard.fromJson(card as Map<String, dynamic>))
            .toList();
        for (final PlayingCard card in cards) {
          card.state = state;
        }
        return cards;
      }
      return [];
    } on DioError catch (e) {
      print(e.message);
      print('uri in catch: ${e.requestOptions.uri}');

      return [];
    }
  }
}
