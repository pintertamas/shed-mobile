import 'dart:io';

import 'package:flutter/material.dart';
import 'package:websocket_mobile/login/screen/login_screen.dart';
import 'package:websocket_mobile/lobby/screen/join_lobby_screen.dart';

import 'lobby/screen/scan_game_id_screen.dart';
import 'my_http_override.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(
    MaterialApp(
      initialRoute: '/join-lobby',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/scan-game-id': (context) => const ScanGameIdScreen(),
        '/join-lobby': (context) => const JoinLobbyScreen(),
      },
    ),
  );
}
