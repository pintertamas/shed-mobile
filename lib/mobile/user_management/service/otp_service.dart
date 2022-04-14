import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:websocket_mobile/mobile/user_management/screen/home_screen.dart';
import 'package:websocket_mobile/mobile/user_management/service/user_service.dart';

class OtpService {
  static UserService userService = UserService();

  OtpService() {
    final options = BaseOptions(
      baseUrl: 'https://shed-backend.herokuapp.com',
      connectTimeout: 5000,
      receiveTimeout: 3000,
    );
    dio = Dio(options);
  }

  late Dio dio;

  Future<bool> generateOtp(String email) async {
    try {
      final response = await dio.post(
        '/generate-otp',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
        data: email,
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

  static Future<bool> register({
    required String username,
    required String password,
    required String email,
    required TextEditingController otpController,
    required BuildContext context,
  }) async {
    bool result = false;
    await userService
        .register(
          username,
          password,
          email,
          int.parse(otpController.text.trim()),
        )
        .then(
          (response) async => {
            result = response,
            if (response)
              {
                await userService
                    .login(
                      username,
                      password,
                    )
                    .then(
                      (response) => {
                        result = response,
                        if (response)
                          {
                            Navigator.pushReplacementNamed(
                              context,
                              HomeScreen.routeName,
                            ),
                          },
                      },
                    ),
              }
          },
        );
    return result;
  }

  static Future<bool> changePassword({
    required String email,
    required int otp,
    required String password,
    required BuildContext context,
  }) async {
    bool result = true;
    userService
        .changePassword(
      email,
      otp,
      password,
    )
        .then(
      (value) {
        result = value;
        if (value) {
          Navigator.pushReplacementNamed(
            context,
            HomeScreen.routeName,
          );
        }
      },
    );
    return result;
  }
}
