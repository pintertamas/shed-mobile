import 'package:flutter/material.dart';
import 'package:websocket_mobile/lobby/service/websocket_service.dart';

class LobbyScreen extends StatefulWidget {
  const LobbyScreen({required this.gameId, Key? key, }) : super(key: key);
  final String gameId;

  static const routeName = '/lobby';

  @override
  _LobbyScreenState createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  late WebSocketService webSocketService;

  @override
  void initState() {
    webSocketService = WebSocketService();
    webSocketService.initStompClient(widget.gameId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Center(
            child: Column(
              children: [
                Text(widget.gameId),
                ElevatedButton(
                  onPressed: () {
                    webSocketService.sendMessage(widget.gameId, 'hello');
                  },
                  child: const Text(
                    'say hello',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    webSocketService.deactivate();
    super.dispose();
  }
}
