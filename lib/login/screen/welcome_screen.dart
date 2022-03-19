import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:websocket_mobile/lobby/screen/browse_games.dart';
import 'package:websocket_mobile/login/widget/custom_text_input.dart';

import '../../lobby/model/screen_arguments.dart';
import '../../lobby/screen/lobby_screen.dart';
import '../../lobby/screen/scan_game_id_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  static const routeName = '/welcome-screen';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  TextEditingController gameIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double _settingsIconGap = MediaQuery.of(context).size.height * 0.015;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: _settingsIconGap,
              right: _settingsIconGap,
              child: IconButton(
                icon: Icon(FontAwesomeIcons.bars),
                onPressed: () {

                },
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, ScanGameIdScreen.routeName);
                    },
                    child: Text(
                      "Scan game QR code",
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                    "Type here the ID that you see under the QR code!"),
                                CustomTextInput(
                                  hint: "Game ID",
                                  controller: gameIdController,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // TODO: check if gameIdController.text.trim() is a valid game ID
                                    Navigator.pushReplacementNamed(context, LobbyScreen.routeName,
                                        arguments: ScreenArguments(gameIdController.text.trim()));
                                  },
                                  child: Text("Join"),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Text(
                      "Join manually",
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, BrowseGamesScreen.routeName);
                    },
                    child: Text("Browse games"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // TODO
                    },
                    child: Text("Statistics (TBA)"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
