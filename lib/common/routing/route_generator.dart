import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:websocket_mobile/mobile/game/model/game_provider.dart';
import 'package:websocket_mobile/mobile/game/model/game_screen_arguments.dart';
import 'package:websocket_mobile/mobile/game/screen/game_screen.dart';
import 'package:websocket_mobile/mobile/lobby/model/lobby_screen_arguments.dart';
import 'package:websocket_mobile/mobile/lobby/screen/lobby_screen.dart';
import 'package:websocket_mobile/mobile/user_management/model/otp_screen_arguments.dart';
import 'package:websocket_mobile/mobile/user_management/screen/loading_screen.dart';
import 'package:websocket_mobile/mobile/user_management/screen/otp_screen.dart';
import 'package:websocket_mobile/mobile/user_management/widget/custom_button.dart';
import 'package:websocket_mobile/web/create_game/model/qr_screen_arguments.dart';
import 'package:websocket_mobile/web/create_game/screen/create_game_screen.dart';
import 'package:websocket_mobile/web/create_game/screen/qr_screen.dart';
import 'package:websocket_mobile/web/game/model/game_screen_arguments_web.dart';
import 'package:websocket_mobile/web/game/screen/game_screen_web.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case OtpScreen.routeName:
        final args = settings.arguments as OtpScreenArguments?;

        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return OtpScreen(
              text: args!.text,
              username: args.username,
              password: args.password,
              email: args.email,
              requestType: args.requestType,
            );
          },
        );
      case LobbyScreen.routeName:
        final args = settings.arguments as LobbyScreenArguments?;

        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return LobbyScreen(
              gameId: args!.gameId,
              webSocketService: args.webSocketService,
            );
          },
        );
      case GameScreen.routeName:
        final args = settings.arguments as GameScreenArguments?;

        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return ChangeNotifierProvider<GameProvider>(
              create: (_) => GameProvider(),
              child: GameScreen(
                webSocketService: args!.webSocketService,
                gameId: args.gameId,
              ),
            );
          },
        );
      case QRScreen.routeName:
        final args = settings.arguments as QRScreenArguments?;

        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return ChangeNotifierProvider<GameProvider>(
              create: (_) => GameProvider(),
              child: QRScreen(
                gameName: args!.gameName,
                webSocketService: args.webSocketService,
              ),
            );
          },
        );
      case GameScreenWeb.routeName:
        final args = settings.arguments as GameScreenArgumentsWeb?;

        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return GameScreenWeb(
                webSocketService: args!.webSocketService,
            );
          },
        );
      default:
        return errorRoute();
    }
  }
}

Route<dynamic> errorRoute() {
  return MaterialPageRoute(
    builder: (context) {
      return Scaffold(
        backgroundColor: Colors.green,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Center(
              child: Text(
                '404\nNOT FOUND',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                ),
              ),
            ),
            CustomButton(
              onPressed: () {
                kIsWeb
                    ? Navigator.pushReplacementNamed(
                        context,
                        CreateGameScreen.routeName,
                      )
                    : Navigator.pushReplacementNamed(
                        context,
                        LoadingScreen.routeName,
                      );
              },
              text: 'Go back to the home page',
              color: Colors.red,
              width: MediaQuery.of(context).size.width / 3,
            )
          ],
        ),
      );
    },
  );
}
