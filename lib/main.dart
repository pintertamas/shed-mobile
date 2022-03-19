import 'dart:io';

import 'package:flutter/material.dart';
import 'package:websocket_mobile/lobby/model/ScreenArguments.dart';
import 'package:websocket_mobile/login/screen/login_screen.dart';
import 'package:websocket_mobile/lobby/screen/lobby_screen.dart';
import 'package:websocket_mobile/login/screen/welcome_screen.dart';

import 'lobby/screen/scan_game_id_screen.dart';
import 'my_http_override.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: LoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (context) => const LoginScreen(),
        WelcomeScreen.routeName: (context) => const WelcomeScreen(),
        ScanGameIdScreen.routeName: (context) => const ScanGameIdScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == LobbyScreen.routeName) {
          final args = settings.arguments as ScreenArguments;

          return MaterialPageRoute(
            builder: (context) {
              return LobbyScreen(
                gameId: args.gameId,
              );
            },
          );
        }
        return null;
      },
    ),
  );
}
