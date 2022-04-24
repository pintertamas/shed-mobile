import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:websocket_mobile/mobile/common/provider/connected_player_provider.dart';
import 'package:websocket_mobile/mobile/common/stream/connected_player_stream_builder.dart';
import 'package:websocket_mobile/mobile/game/model/game_screen_arguments.dart';
import 'package:websocket_mobile/mobile/game/model/player.dart';
import 'package:websocket_mobile/mobile/game/screen/game_screen.dart';
import 'package:websocket_mobile/mobile/game/service/game_service.dart';
import 'package:websocket_mobile/mobile/lobby/service/websocket_service.dart';
import 'package:websocket_mobile/mobile/user_management/screen/home_screen.dart';
import 'package:websocket_mobile/mobile/user_management/service/user_service.dart';
import 'package:websocket_mobile/mobile/user_management/widget/custom_button.dart';

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
  late UserService userService;
  late GameService gameService;
  late Future<void> listPlayers;
  late ConnectedPlayerProvider provider;

  Future<void> loadConnectedUsers() async {
    final List<Player> players =
        await gameService.getListOfPlayers(provider.connectedUsers);
    for (final Player player in players) {
      if (!provider.connectedUsers.contains(player.username)) {
        provider.connectedUsers.add(player.username);
      }
    }
  }

  void _checkGameStart() {
    webSocketService.webSocketStream.listen((snapshot) {
      if (snapshot.type == 'game-start') {
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
    webSocketService = WebSocketService();
    webSocketService.initStompClient(widget.gameId);
    gameService = GameService();
    listPlayers = loadConnectedUsers();
    Future.delayed(Duration.zero, _checkGameStart);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<ConnectedPlayerProvider>(context);

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
            backgroundColor: Colors.brown,
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
                                connectedUsers: provider.connectedUsers,
                              ),
                            );
                          } else {
                            return const Center(
                              child: Text('Loading...'),
                            );
                          }
                        },
                      ),
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
