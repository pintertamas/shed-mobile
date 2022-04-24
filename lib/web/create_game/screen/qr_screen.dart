import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:websocket_mobile/mobile/lobby/service/websocket_service.dart';
import 'package:websocket_mobile/mobile/user_management/widget/custom_button.dart';

import 'package:websocket_mobile/web/create_game/widget/connected_players_widget.dart';

class QRScreen extends StatefulWidget {
  const QRScreen({required this.name, Key? key}) : super(key: key);
  final String name;

  static const routeName = '/qr';

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  bool errorLoading = false;
  late WebSocketService webSocketService;

  @override
  void initState() {
    webSocketService = WebSocketService();
    webSocketService.initStompClientOnWeb(widget.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final double qrHeight = height * 0.5;

    return Scaffold(
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
                  data: widget.name,
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
                    widget.name,
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
                      webSocketService.startGame(widget.name);
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
    );
  }
}
