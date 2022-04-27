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

  Future<bool> checkAvailability(
    String username,
    String email,
  ) async {
    try {
      final response = await dio.get(
        '/check-availability',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
        queryParameters: {
          'username': username,
          'email': email,
        },
      );
      if (response.data == null) return false;

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      print('error: ${e.response!.statusCode ?? e.message}');
      return false;
    }
  }

  Future<bool> register(
    String username,
    String password,
    String email,
    int otp,
  ) async {
    try {
      final response = await dio.post(
        '/register',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
        queryParameters: {
          'otp': otp,
        },
        data: {'username': username, 'password': password, 'email': email},
      );
      if (response.data == null) return false;

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      print('error: ${e.response!.statusCode ?? 'Error'}');
      return false;
    }
  }

  Future<bool> login(
    String username,
    String password,
  ) async {
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
      print('error: ${response.statusCode ?? 'Error'}');
      final String jwtToken = response.data!['jwtToken'] as String;
      await prefs.setString('jwtToken', jwtToken);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      print('error: ${e.response!.statusCode ?? 'Error'}');
      return false;
    }
  }

  Future<void> saveUsername(String username) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
  }

  Future<String> getUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? 'unknown';
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwtToken', '');
  }

  Future<bool> changePassword(
    String email,
    int otp,
    String newPassword,
  ) async {
    try {
      final response = await dio.put(
        '/users/change-password',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'email': email,
          'otp': otp,
          'password': newPassword,
        },
      );
      if (response.data == null) return false;

      print('response data: ${response.data}');

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      print('error: ${e.response!.statusCode ?? 'Error'}');
      return false;
    } on Exception catch (e) {
      print('error: $e');
      return false;
    }
  }
}
