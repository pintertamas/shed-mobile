import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:websocket_mobile/common/model/card_state.dart';
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
    gameCards.cardsInHand = await fetchPlayerCards(CardState.Hand);
    gameCards.cardsUp = await fetchPlayerCards(CardState.Visible);
    gameCards.cardsDown = await fetchPlayerCards(CardState.Invisible);
    return gameCards;
  }

  Future<List<PlayingCard>> fetchPlayerCards(
    CardState state, {
    String? username,
  }) async {
    final String jwtToken = await UserService.getJwtToken();
    final String _username = username ?? await UserService.getUsername();

    try {
      final response = await dio.get(
        '/cards/player/$_username/${state.name}',
        options: Options(
          responseType: ResponseType.plain,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwtToken',
          },
        ),
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

  Future<List<PlayingCard>> fetchTableCards(
    CardState state,
  ) async {
    final String gameName = await GameService.getGameName();

    try {
      final response = await dio.get(
        '/cards/table/$gameName/${state.name}',
        options: Options(
          responseType: ResponseType.plain,
          headers: {
            'Content-Type': 'application/json',
          },
        ),
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
