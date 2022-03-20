import 'package:http/http.dart' as http;

class UserService {
  UserService() {}

  static const String _baseUrl = 'http://shed-backend.herokuapp.com';

  /*void register(String username, String password) async {
    try {
      final response = await dio.get(
        '$_baseUrl/register',
        queryParameters: {
          'username': username,
          'password': password,
        },
      );
      print(response);
    } catch (e) {
      print(e);
    }
  }*/

  Future<bool> login(String username, String password) async {
    final Uri url = Uri.parse('$_baseUrl/login');

    try {
      final response = await http.post(
        url,
        body: {
          'username': username,
          'password': password,
        },
      );
      print('body: ${response.body}');

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
