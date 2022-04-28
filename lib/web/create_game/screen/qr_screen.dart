import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:websocket_mobile/mobile/common/service/game_service.dart';
import 'package:websocket_mobile/mobile/lobby/screen/lobby_screen.dart';
import 'package:websocket_mobile/mobile/lobby/service/websocket_service.dart';
import 'package:websocket_mobile/mobile/user_management/screen/loading_screen.dart';
import 'package:websocket_mobile/mobile/user_management/widget/custom_button.dart';
import 'package:websocket_mobile/web/create_game/screen/create_game_screen.dart';
import 'package:websocket_mobile/web/game/game_screen_web.dart';

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
  late bool isLoading;
  bool enabled = true;

  Future<String> getGameName() async {
    final String gameName = await GameService.getGameName();
    if (!isLoading) {
      await webSocketService.initStompClientOnWeb(gameName);
      isLoading = true;
    }
    return gameName;
  }

  @override
  void initState() {
    isLoading = false;
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

          return WillPopScope(
            onWillPop: () async {
              webSocketService.deactivate();
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
                  Visibility(
                    visible: width >= height * 1.5,
                    child: Positioned(
                      top: 0,
                      left: 0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).size.height *
                                      0.025,
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width / 4,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset.fromDirection(
                                          1.5,
                                          5,
                                        ),
                                        color: const Color.fromRGBO(
                                          57,
                                          131,
                                          60,
                                          1.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  child: const Text(
                                    'Connected players',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(
                              MediaQuery.of(context).size.height * 0.05,
                            ),
                            child: SingleChildScrollView(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 4,
                                  height:
                                      MediaQuery.of(context).size.height * 0.8,
                                  color: Colors.green,
                                  child: LobbyScreen(
                                    gameId: gameName,
                                    webSocketService: webSocketService,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: QrImage(
                              data: gameName,
                              version: QrVersions.auto,
                              size: qrHeight,
                              foregroundColor: Colors.black,
                              errorStateBuilder: (cxt, err) {
                                print('qr error: $err');
                                return Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                          ),
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
                            enabled: enabled,
                            onPressed: () {
                              if (!enabled) return;
                              setState(() {
                                enabled = false;
                              });
                              webSocketService.startGame(gameName);
                              Navigator.pushReplacementNamed(
                                context,
                                GameScreenWeb.routeName,
                              );
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
