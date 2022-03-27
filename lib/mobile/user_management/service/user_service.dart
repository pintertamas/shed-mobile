import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  UserService() {
    final options = BaseOptions(
      baseUrl: 'https://shed-backend.herokuapp.com',
      connectTimeout: 5000,
      receiveTimeout: 3000,
    );
    dio = Dio(options);
  }

  late Dio dio;

  Future<bool> register(String username, String password) async {
    try {
      final response = await dio.post(
        '/register',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'username': username,
          'password': password,
        },
      );
      if (response.data == null) return false;

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      print(e.response!.statusCode ?? 'Error');
      return false;
    }
  }

  Future<bool> login(String username, String password) async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    try {
      final response = await dio.post(
        '/login',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'username': username,
          'password': password,
        },
      );
      if (response.data == null) return false;

      print('body: ${response.data}');
      print(response.statusCode);
      final String jwtToken = response.data!['jwtToken'] as String;
      await prefs.setString('jwtToken', jwtToken);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      print(e.response!.statusCode ?? 'Error');
      return false;
    }
  }

  Future<void> logout() async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('jwtToken', '');
  }

  Future<bool> checkTokenValidity() async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    final String jwtToken = prefs.getString('jwtToken')!;

    try {
      final response = await dio.get(
        '/check-token-validity',
        options: Options(
          headers: {
            'Authorization': 'Bearer $jwtToken',
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.data == null) return false;

      print('token: $jwtToken');
      print('body: ${response.data}');

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      print(e.response!.statusCode ?? 'Error');
      return false;
    }
  }
}
