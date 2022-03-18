import 'package:flutter/material.dart';
import 'package:websocket_mobile/lobby/service/websocket_service.dart';

class JoinLobbyScreen extends StatefulWidget {
  const JoinLobbyScreen({Key? key, required this.gameId}) : super(key: key);
  final String gameId;

  static const routeName = '/join-lobby';

  @override
  _JoinLobbyScreenState createState() => _JoinLobbyScreenState();
}

class _JoinLobbyScreenState extends State<JoinLobbyScreen> {
  late WebSocketService _webSocketService;

  WebSocketService get webSocketService => _webSocketService;

  set webSocketService(WebSocketService value) {
    _webSocketService = value;
  }

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
                    webSocketService.sendMessage(widget.gameId, "hello");
                  },
                  child: Text(
                    "say hello",
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
