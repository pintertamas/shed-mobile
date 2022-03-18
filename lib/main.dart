import 'dart:io';

import 'package:flutter/material.dart';
import 'package:websocket_mobile/lobby/model/ScreenArguments.dart';
import 'package:websocket_mobile/login/screen/login_screen.dart';
import 'package:websocket_mobile/lobby/screen/join_lobby_screen.dart';

import 'lobby/screen/scan_game_id_screen.dart';
import 'my_http_override.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(
    MaterialApp(
      initialRoute: LoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (context) => const LoginScreen(),
        ScanGameIdScreen.routeName: (context) => const ScanGameIdScreen(),
        //JoinLobbyScreen.routeName: (context) => JoinLobbyScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == JoinLobbyScreen.routeName) {
          final args = settings.arguments as ScreenArguments;

          return MaterialPageRoute(
            builder: (context) {
              return JoinLobbyScreen(
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
