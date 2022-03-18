import 'package:flutter/material.dart';
import 'package:websocket_mobile/lobby/service/websocket_service.dart';

class JoinLobbyScreen extends StatefulWidget {
  const JoinLobbyScreen({Key? key}) : super(key: key);

  @override
  _JoinLobbyScreenState createState() => _JoinLobbyScreenState();
}

class _JoinLobbyScreenState extends State<JoinLobbyScreen> {
  late WebSocketService _webSocketService;
  String channel = "asd";

  WebSocketService get webSocketService => _webSocketService;

  set webSocketService(WebSocketService value) {
    _webSocketService = value;
  }

  @override
  void initState() {
    webSocketService = WebSocketService();
    webSocketService.initStompClient(channel);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () {
                webSocketService.sendMessage(channel, "hello");
              },
              child: Text(
                "say hello",
              ),
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
