import 'package:flutter/material.dart';
import 'package:websocket_mobile/mobile/game/model/game_screen_arguments.dart';
import 'package:websocket_mobile/mobile/game/screen/game_screen.dart';
import 'package:websocket_mobile/mobile/lobby/service/websocket_service.dart';
import 'package:websocket_mobile/mobile/user_management/screen/home_screen.dart';

class LobbyScreen extends StatefulWidget {
  const LobbyScreen({
    required this.gameId,
    Key? key,
  }) : super(key: key);
  final String gameId;

  static const routeName = '/lobby';

  @override
  _LobbyScreenState createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  late WebSocketService webSocketService;
  late Future<bool> isConnected;

  @override
  void initState() {
    webSocketService = WebSocketService();
    webSocketService.initStompClient(widget.gameId);
    super.initState();
  }

  @override
  void dispose() {
    webSocketService.deactivate();
    print('Deactivating websockets...');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: webSocketService.checkConnection(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData || snapshot.data == false) {
          return SafeArea(
            child: Scaffold(
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    CircularProgressIndicator(),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Connecting'),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return MaterialApp(
            home: SafeArea(
              child: Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.gameId,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          webSocketService.sendMessage(widget.gameId, 'hello');
                        },
                        child: const Text(
                          'say hello',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            GameScreen.routeName,
                            arguments: GameScreenArguments(
                              webSocketService,
                              widget.gameId,
                            ),
                          );
                        },
                        child: const Text(
                          'go to game page',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.red),
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              HomeScreen.routeName,
                            );
                          },
                          child: const Text(
                            'Leave lobby',
                          ),
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
}
