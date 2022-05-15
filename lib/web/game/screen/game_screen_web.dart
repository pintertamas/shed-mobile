import 'package:flutter/material.dart';
import 'package:websocket_mobile/mobile/lobby/service/websocket_service.dart';
import 'package:websocket_mobile/web/create_game/screen/create_game_screen.dart';

class GameScreenWeb extends StatefulWidget {
  const GameScreenWeb({
    required this.webSocketService,
    Key? key,
  }) : super(key: key);
  final WebSocketService webSocketService;

  static const routeName = '/game-web';

  @override
  State<GameScreenWeb> createState() => _GameScreenWebState();
}

class _GameScreenWebState extends State<GameScreenWeb> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.webSocketService.deactivate();
        Navigator.pushNamed(
          context,
          CreateGameScreen.routeName,
        );
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.brown,
        body: Container(),
      ),
    );
  }
}
