import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:websocket_mobile/mobile/game/model/player.dart';
import 'package:websocket_mobile/mobile/user_management/service/user_service.dart';

import 'package:websocket_mobile/web/create_game/model/game.dart';

class GameService {
  GameService() {
    final options = BaseOptions(
      baseUrl: 'https://shed-backend.herokuapp.com',
      contentType: 'application/json',
      connectTimeout: 5000,
      receiveTimeout: 3000,
    );
    dio = Dio(options);
  }

  late Dio dio;

  Future<void> saveGameName(String gameName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('gameName', gameName);
  }

  static Future<String> getGameName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('gameName') ?? 'unknown';
  }

  Future<void> loadConnectedUsers(List<String> connectedUsers) async {
    final List<Player> players = await getListOfPlayers(connectedUsers);
    for (final Player player in players) {
      if (!connectedUsers.contains(player.username)) {
        connectedUsers.add(player.username);
      }
    }
  }

  Future<String> createGame({
    required bool visible,
    required int numberOfDecks,
    required int numberOfCardsInHand,
    required bool joker,
    required dynamic cardRules,
  }) async {
    print('cardRules: $cardRules');
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
          'visible': visible,
          'numberOfDecks': numberOfDecks,
          'numberOfCardsInHand': numberOfCardsInHand,
          'joker': joker,
          'cardRules': cardRules,
        },
      );
      print('response data: ${response.data}');
      if (response.data == null) return '';

      if (response.statusCode == 200) {
        return response.data['name'].toString();
      } else {
        return '';
      }
    } on DioError catch (e) {
      print('error: ${e.error ?? 'Error'}');
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
      print('game list status code: ${e.response?.statusCode}');
      print('response data: ${e.response!.data ?? 'Error'}');
      return [];
    }
  }

  Future<List<Player>> getListOfPlayers(List<String> connectedUsers) async {
    final String jwtToken = await UserService.getJwtToken();
    final String gameName = await getGameName();
    print('Connecting to $gameName');

    final Options webOptions = Options(
      headers: {
        'Content-Type': 'application/json',
      },
    );

    final Options options = Options(
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
    );

    try {
      final response = await dio.get(
        '/player/list/',
        options: kIsWeb ? webOptions : options,
        queryParameters: {
          'gameName': gameName,
        },
      );
      if (response.data == null) throw DioError;

      if (response.statusCode == 200) {
        final List<Player> players = (response.data as List)
            .map((x) => Player.fromJson(x as Map<String, dynamic>))
            .toList();
        return players;
      } else {
        throw DioError;
      }
    } on DioError catch (e) {
      print('error: ${e.message}');
      print('player list status code: ${e.response?.statusCode}');
      print('response data: ${e.response!.data}');
      return [];
    }
  }

  Future<bool> isGameExist(String gameName) async {
    try {
      final response = await dio.get(
        '/game/',
        options: Options(
          responseType: ResponseType.plain,
          headers: {
            'Content-Type': 'application/json',
          },
        ),
        queryParameters: {
          'gameName': gameName,
        },
      );

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on DioError {
      return false;
    }
  }

  Future<String> isPlayerInExistingGame() async {
    final String username = await UserService.getUsername();

    try {
      final response = await dio.get(
        '/player/check-already-in-game/$username',
        options: Options(
          responseType: ResponseType.plain,
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      print(response.requestOptions.uri);

      if (response.statusCode == 200) {
        return response.data.toString();
      }
      return '';
    } on DioError catch (e) {
      print(e.message);
      print('uri in catch: ${e.requestOptions.uri}');

      return '';
    }
  }

  Future<String> leaveGame() async {
    final String jwtToken = await UserService.getJwtToken();
    final String username = await UserService.getUsername();

    try {
      final response = await dio.delete(
        '/player/disconnect/$username',
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
        return response.data.toString();
      }
      return '';
    } on DioError catch (e) {
      print(e.message);
      print('uri in catch: ${e.requestOptions.uri}');

      return '';
    }
  }
}
