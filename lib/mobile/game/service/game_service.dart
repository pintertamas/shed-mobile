import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:websocket_mobile/mobile/game/model/player.dart';

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

  Future<void> saveGameName(String gameName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('gameName', gameName);
  }

  Future<String> getGameName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('gameName') ?? 'unknown';
  }

  Future<List<Player>> getListOfPlayers(List<String> connectedUsers) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String jwtToken = prefs.getString('jwtToken')!;
    final String gameName = await getGameName();

    try {
      final response = await dio.get(
        '/player/list/',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $jwtToken',
          },
        ),
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
      print('player list status code: ${e.response!.statusCode}');
      print(e.response!.data);
      return [];
    }
  }
}
