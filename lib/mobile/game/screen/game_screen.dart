import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:websocket_mobile/mobile/lobby/service/websocket_service.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({
    required this.webSocketService,
    required this.gameId,
    Key? key,
  }) : super(key: key);
  final WebSocketService webSocketService;
  final String gameId;

  static const routeName = '/game';

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              widget.webSocketService.sendMessage(widget.gameId, 'hola');
            },
            child: const Text('Send a hola'),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.webSocketService.deactivate();
    super.dispose();
  }
}
