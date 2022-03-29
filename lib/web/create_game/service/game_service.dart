import 'package:dio/dio.dart';

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
}
