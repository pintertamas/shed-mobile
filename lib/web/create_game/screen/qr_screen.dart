import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:websocket_mobile/mobile/common/service/game_service.dart';
import 'package:websocket_mobile/mobile/lobby/service/websocket_service.dart';
import 'package:websocket_mobile/mobile/user_management/screen/loading_screen.dart';
import 'package:websocket_mobile/mobile/user_management/widget/custom_button.dart';
import 'package:websocket_mobile/web/create_game/screen/create_game_screen.dart';

import 'package:websocket_mobile/web/create_game/widget/connected_players_widget.dart';

class QRScreen extends StatefulWidget {
  const QRScreen({Key? key}) : super(key: key);

  static const routeName = '/qr';

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  bool errorLoading = false;
  late WebSocketService webSocketService;
  late Future<String> loadGameName;

  Future<String> getGameName() async {
    return GameService.getGameName();
  }

  @override
  void initState() {
    webSocketService = WebSocketService();
    loadGameName = getGameName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final double qrHeight = height * 0.5;

    return FutureBuilder<String>(
      future: loadGameName,
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          final String gameName = snapshot.data ?? 'unknown game';
          webSocketService.initStompClientOnWeb(gameName);

          return WillPopScope(
            onWillPop: () async {
              Navigator.pushNamed(
                context,
                CreateGameScreen.routeName,
              );
              return true;
            },
            child: Scaffold(
              backgroundColor: Colors.brown,
              body: Stack(
                children: [
                  if (width >= height * 1.5)
                    ConnectedPlayersWidget(
                      websocketService: webSocketService,
                    ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        QrImage(
                          data: gameName,
                          version: QrVersions.auto,
                          size: qrHeight,
                          errorStateBuilder: (cxt, err) {
                            print(err.toString());
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(30.0),
                                  child: Icon(
                                    FontAwesomeIcons.exclamationCircle,
                                    color: Colors.red,
                                    size: qrHeight / 4,
                                  ),
                                ),
                                Text(
                                  'Uh oh! Something went wrong... Try again in a few minutes!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: qrHeight / 25,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        const Text(
                          'To manually join a game, type the following:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SelectableText(
                            gameName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: CustomButton(
                            onPressed: () {
                              webSocketService.startGame(gameName);
                            },
                            text: 'Start game',
                            width: MediaQuery.of(context).size.width * 0.3,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const LoadingScreen();
        }
      },
    );
  }
}
