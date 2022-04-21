import 'package:dio/dio.dart';

import 'package:websocket_mobile/web/create_game/model/game.dart';

class GameService {
  GameService() {
    final options = BaseOptions(
      baseUrl: 'https://shed-backend.herokuapp.com',
      connectTimeout: 5000,
      receiveTimeout: 3000,
    );
    dio = Dio(options);
  }

  late Dio dio;

  Future<String> createGame() async {
    try {
      final response = await dio.post(
        '/game/create',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Credentials': true,
            // Required for cookies, authorization headers with HTTPS
            'Access-Control-Allow-Headers':
                'Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token',
            'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
          },
        ),
        data: {
          'numberOfDecks': 1,
          'numberOfCardsInHand': 3,
          'numberOfPlayers': 5,
          'joker': false,
          'cardRules': [
            {'number': 1, 'rule': 'None'},
            {'number': 2, 'rule': 'Jolly_Joker'},
            {'number': 3, 'rule': 'Invisible'},
            {'number': 4, 'rule': 'None'},
            {'number': 5, 'rule': 'None'},
            {'number': 6, 'rule': 'Reducer'},
            {'number': 7, 'rule': 'None'},
            {'number': 8, 'rule': 'Burner'},
            {'number': 9, 'rule': 'None'},
            {'number': 10, 'rule': 'None'},
            {'number': 11, 'rule': 'None'},
            {'number': 12, 'rule': 'None'},
            {'number': 13, 'rule': 'None'},
            {'number': 14, 'rule': 'None'},
          ],
        },
      );
      print('response: ${response.data}');
      if (response.data == null) return '';

      if (response.statusCode == 200) {
        return response.data['name'].toString();
      } else {
        return '';
      }
    } on DioError catch (e) {
      print(e.error ?? 'Error');
      return 'error';
    }
  }

  Future<List<Game>> getListOfGames() async {
    try {
      final response = await dio.get(
        '/game/list/',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
        queryParameters: {
          'statusValue': 'New',
        },
      );
      if (response.data == null) throw DioError;

      if (response.statusCode == 200) {
        final List<Game> games = (response.data as List)
            .map((x) => Game.fromJson(x as Map<String, dynamic>))
            .toList();
        return games;
      } else {
        throw DioError;
      }
    } on DioError catch (e) {
      print('game list status code: ${e.response!.statusCode}');
      print(e.response!.data);
      return [];
    }
  }
}
