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
    final SharedPreferences prefs = await SharedPreferences.getInstance();

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
      print(e.response?.statusCode ?? 'Error');
      return false;
    }
  }

  Future<void> saveUsername(String username) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
  }

  Future<String> getUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username')??'unknown';
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwtToken', '');
  }

  Future<bool> checkTokenValidity() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jwtToken = prefs.getString('jwtToken');
    print(jwtToken);

    if (jwtToken == null || jwtToken == '') return false;

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
    } on Exception catch (e) {
      print(e.toString());
      return false;
    }
  }
}
