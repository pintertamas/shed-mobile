import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:websocket_mobile/common/model/card.dart';
import 'package:websocket_mobile/common/model/card_state.dart';
import 'package:websocket_mobile/common/model/game_cards.dart';

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
    gameCards.cardsInHand = await fetchPlayerCards(State.Hand);
    gameCards.cardsUp = await fetchPlayerCards(State.Visible);
    gameCards.cardsDown = await fetchPlayerCards(State.Invisible);
    return gameCards;
  }

  Future<List<Card>> fetchPlayerCards(State state) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jwtToken = prefs.getString('jwtToken');
    final String username = prefs.getString('username') ?? 'unknown';

    try {
      final response = await dio.get(
        '/cards/player/$username/${state.name}',
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
        return (jsonDecode(response.data.toString()) as List)
            .map((card) => Card.fromJson(card as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioError catch (e) {
      print(e.message);
      print('uri in catch: ${e.requestOptions.uri}');

      return [];
    }
  }
}
