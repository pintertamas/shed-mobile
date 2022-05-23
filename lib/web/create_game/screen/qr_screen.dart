import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:websocket_mobile/mobile/lobby/screen/lobby_screen.dart';
import 'package:websocket_mobile/mobile/lobby/service/websocket_service.dart';
import 'package:websocket_mobile/mobile/user_management/widget/custom_button.dart';
import 'package:websocket_mobile/web/create_game/screen/create_game_screen.dart';
import 'package:websocket_mobile/web/game/model/game_screen_arguments_web.dart';
import 'package:websocket_mobile/web/game/screen/game_screen_web.dart';

class QRScreen extends StatefulWidget {
  const QRScreen({
    required this.gameName,
    this.webSocketService,
    Key? key,
  }) : super(key: key);
  final String gameName;
  final WebSocketService? webSocketService;

  static const routeName = '/qr';

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  bool errorLoading = false;
  late WebSocketService webSocketService;
  late bool isLoading;
  bool enabled = true;

  @override
  void initState() {
    webSocketService = WebSocketService();
    webSocketService.initStompClient(channel: widget.gameName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final double qrHeight = height * 0.5;
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
                child: Padding(
                  padding: EdgeInsets.all(
                    MediaQuery.of(context).size.height * 0.05,
                  ),
                  child: SingleChildScrollView(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 4,
                        height: MediaQuery.of(context).size.height * 0.8,
                        color: Colors.green,
                        child: LobbyScreen(
                          gameId: widget.gameName,
                          webSocketService: webSocketService,
                        ),
                      ),
                    ),
                  ),
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
                        data: widget.gameName,
                        version: QrVersions.auto,
                        size: qrHeight,
                        foregroundColor: Colors.black,
                        errorStateBuilder: (cxt, err) {
                          print('qr error: $err');
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
                      widget.gameName,
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
                        webSocketService.startGame(widget.gameName);
                        Navigator.pushReplacementNamed(
                          context,
                          GameScreenWeb.routeName,
                          arguments: GameScreenArgumentsWeb(
                            webSocketService: webSocketService,
                          ),
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
  }
}
