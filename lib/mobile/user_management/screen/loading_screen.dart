import 'package:flutter/material.dart';
import 'package:websocket_mobile/mobile/user_management/screen/home_screen.dart';
import 'package:websocket_mobile/mobile/user_management/screen/welcome_screen.dart';
import 'package:websocket_mobile/mobile/user_management/service/user_service.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  static const routeName = '/loading-screen';

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late UserService userService = UserService();
  late Future<bool> isValid = userService.checkTokenValidity();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
        future: isValid,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == true) {
              return const HomeScreen();
            } else {
              return const WelcomeScreen();
            }
          }
          return const Center(
            child: Text(
              'Loading',
            ),
          );
        },
      ),
    );
  }
}
