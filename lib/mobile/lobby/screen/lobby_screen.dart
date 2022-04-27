import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:websocket_mobile/mobile/common/service/game_service.dart';
import 'package:websocket_mobile/mobile/common/stream/connected_player_stream_builder.dart';
import 'package:websocket_mobile/mobile/game/model/game_screen_arguments.dart';
import 'package:websocket_mobile/mobile/game/screen/game_screen.dart';
import 'package:websocket_mobile/mobile/lobby/service/websocket_service.dart';
import 'package:websocket_mobile/mobile/user_management/screen/home_screen.dart';
import 'package:websocket_mobile/mobile/user_management/service/user_service.dart';
import 'package:websocket_mobile/mobile/user_management/widget/custom_button.dart';

class LobbyScreen extends StatefulWidget {
  LobbyScreen({
    required this.gameId,
    this.webSocketService,
    Key? key,
  }) : super(key: key);
  final String gameId;
  WebSocketService? webSocketService;

  static const routeName = '/lobby';

  @override
  _LobbyScreenState createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  late WebSocketService webSocketService;
  late Future<bool> isConnected;
  late UserService userService;
  late GameService gameService;
  late Future<void> listPlayers;
  List<String> connectedUsers = [];

  void _checkGameStart() {
    webSocketService.webSocketStream.listen((snapshot) {
      if (snapshot.type == 'game-start') {
        print('received game-start signal');
        Navigator.of(context).pushReplacementNamed(
          GameScreen.routeName,
          arguments: GameScreenArguments(
            webSocketService,
            widget.gameId,
          ),
        );
      }
    });
  }

  @override
  void initState() {
    userService = UserService();
    webSocketService = widget.webSocketService ?? WebSocketService();

    if (kIsWeb) {
      webSocketService.initStompClientOnWeb(widget.gameId);
    } else {
      webSocketService.initStompClient(widget.gameId);
    }

    gameService = GameService();
    listPlayers = gameService.loadConnectedUsers(connectedUsers);
    Future.delayed(Duration.zero, _checkGameStart);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
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
          return Scaffold(
            backgroundColor: kIsWeb ? Colors.green : Colors.brown,
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
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
                            color: Colors.white,
                          ),
                        ),
                      ),
                      FutureBuilder<void>(
                        future: listPlayers,
                        builder: (context, AsyncSnapshot<void> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: ConnectedPlayerStreamBuilder(
                                webSocketService: webSocketService,
                                connectedUsers: connectedUsers,
                              ),
                            );
                          } else {
                            return const Center(
                              child: Text('Loading...'),
                            );
                          }
                        },
                      ),
                      if (!kIsWeb)
                        CustomButton(
                          onPressed: () {
                            webSocketService.leaveGame().then(
                                  (value) => {
                                    webSocketService.deactivate(),
                                    print('Leaving lobby...'),
                                  },
                                );
                            Navigator.pushReplacementNamed(
                              context,
                              HomeScreen.routeName,
                            );
                          },
                          text: 'Leave lobby',
                          color: Colors.red,
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
