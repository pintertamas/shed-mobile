import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:websocket_mobile/mobile/user_management/screen/home_screen.dart';
import 'package:websocket_mobile/mobile/user_management/screen/welcome_screen.dart';
import 'package:websocket_mobile/mobile/user_management/service/otp_service.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  static const routeName = '/loading-screen';

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late OtpService otpService = OtpService();
  late Future<bool> isValid = otpService.checkTokenValidity();

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
        future: isValid,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == true && snapshot.data != null) {
              return const HomeScreen();
            } else {
              return const WelcomeScreen();
            }
          }
          return Center(
            child: Column(
              children: [
                const CircularProgressIndicator(),
                Text(
                  '${snapshot.connectionState}',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
