import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:websocket_mobile/common/routing/route_generator.dart';
import 'package:websocket_mobile/mobile/lobby/screen/browse_games.dart';
import 'package:websocket_mobile/mobile/lobby/screen/scan_game_id_screen.dart';
import 'package:websocket_mobile/mobile/user_management/screen/forgot_password_screen.dart';
import 'package:websocket_mobile/mobile/user_management/screen/home_screen.dart';
import 'package:websocket_mobile/mobile/user_management/screen/loading_screen.dart';
import 'package:websocket_mobile/mobile/user_management/screen/login_screen.dart';
import 'package:websocket_mobile/mobile/user_management/screen/sign_up_screen.dart';
import 'package:websocket_mobile/mobile/user_management/screen/welcome_screen.dart';
import 'package:websocket_mobile/my_http_override.dart';
import 'package:websocket_mobile/web/create_game/screen/create_game_screen.dart';
import 'package:websocket_mobile/web/create_game/screen/qr_screen.dart';
import 'package:websocket_mobile/web/game/game_screen_web.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute:
          kIsWeb ? CreateGameScreen.routeName : LoadingScreen.routeName,
      routes: {
        // mobile screens
        WelcomeScreen.routeName: (context) => const WelcomeScreen(),
        LoadingScreen.routeName: (context) => const LoadingScreen(),
        //OtpScreen.routeName: (context) => const OtpScreen(),
        SignUpScreen.routeName: (context) => const SignUpScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        ForgotPasswordScreen.routeName: (context) =>
            const ForgotPasswordScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
        BrowseGamesScreen.routeName: (context) => const BrowseGamesScreen(),
        ScanGameIdScreen.routeName: (context) => const ScanGameIdScreen(),

        // web screens
        CreateGameScreen.routeName: (context) => const CreateGameScreen(),
        QRScreen.routeName: (context) => const QRScreen(),
        GameScreenWeb.routeName: (context) => const GameScreenWeb(),
      },
      onGenerateRoute: RouteGenerator.generateRoute,
    ),
  );
}
