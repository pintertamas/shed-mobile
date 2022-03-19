import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:websocket_mobile/mobile/game/model/game_screen_arguments.dart';
import 'package:websocket_mobile/mobile/game/screen/game_screen.dart';
import 'package:websocket_mobile/mobile/lobby/model/lobby_screen_arguments.dart';
import 'package:websocket_mobile/mobile/lobby/screen/browse_games.dart';
import 'package:websocket_mobile/mobile/lobby/screen/lobby_screen.dart';
import 'package:websocket_mobile/mobile/lobby/screen/scan_game_id_screen.dart';
import 'package:websocket_mobile/mobile/login/screen/login_screen.dart';
import 'package:websocket_mobile/mobile/login/screen/welcome_screen.dart';
import 'package:websocket_mobile/my_http_override.dart';
import 'package:websocket_mobile/web/create_game/model/qr_screen_arguments.dart';
import 'package:websocket_mobile/web/create_game/screen/create_game_screen.dart';
import 'package:websocket_mobile/web/create_game/screen/qr_screen.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: kIsWeb ? CreateGameScreen.routeName : LoginScreen.routeName,
      routes: {
        // mobile screens
        LoginScreen.routeName: (context) => const LoginScreen(),
        WelcomeScreen.routeName: (context) => const WelcomeScreen(),
        BrowseGamesScreen.routeName: (context) => const BrowseGamesScreen(),
        ScanGameIdScreen.routeName: (context) => const ScanGameIdScreen(),

        // web screens
        CreateGameScreen.routeName: (context) => const CreateGameScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == LobbyScreen.routeName) {
          final args = settings.arguments as LobbyScreenArguments?;

          return MaterialPageRoute(
            builder: (context) {
              return LobbyScreen(
                gameId: args!.gameId,
              );
            },
          );
        } else if (settings.name == GameScreen.routeName) {
          final args = settings.arguments as GameScreenArguments?;

          return MaterialPageRoute(
            builder: (context) {
              return GameScreen(
                webSocketService: args!.webSocketService,
                gameId: args.gameId,
              );
            },
          );
        }
        // web
        else if (settings.name == QRScreen.routeName) {
          final args = settings.arguments as QRScreenArguments?;

          return MaterialPageRoute(
            builder: (context) {
              return QRScreen(
                name: args!.name,
              );
            },
          );
        }
        return null;
      },
    ),
  );
}
