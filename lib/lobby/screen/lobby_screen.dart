import 'package:flutter/material.dart';
import 'package:websocket_mobile/lobby/service/websocket_service.dart';

class LobbyScreen extends StatefulWidget {
  const LobbyScreen({Key? key, required this.gameId}) : super(key: key);
  final String gameId;

  static const routeName = '/lobby';

  @override
  _LobbyScreenState createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
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
    return FutureBuilder(
      future: webSocketService.isConnected(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          print("loading");
          return Center(child: Text("Loading"));
        } else {
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
      },
    );
  }

  @override
  void dispose() {
    webSocketService.deactivate();
    super.dispose();
  }
}
