import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:websocket_mobile/mobile/lobby/model/lobby_screen_arguments.dart';
import 'package:websocket_mobile/mobile/lobby/screen/browse_games.dart';
import 'package:websocket_mobile/mobile/lobby/screen/lobby_screen.dart';
import 'package:websocket_mobile/mobile/lobby/screen/scan_game_id_screen.dart';
import 'package:websocket_mobile/mobile/user_management/screen/welcome_screen.dart';
import 'package:websocket_mobile/mobile/user_management/service/user_service.dart';
import 'package:websocket_mobile/mobile/user_management/widget/custom_text_input.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const routeName = '/home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController gameIdController = TextEditingController();
  UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    final double _settingsIconGap = MediaQuery.of(context).size.height * 0.015;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: _settingsIconGap,
              right: _settingsIconGap,
              child: IconButton(
                icon: const Icon(FontAwesomeIcons.bars),
                onPressed: () {},
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
                    child: const Text(
                      'Scan game QR code',
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
                                const Text(
                                  'Type here the ID that you see under the QR code!',
                                ),
                                CustomTextInput(
                                  hint: 'Game ID',
                                  controller: gameIdController,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // TODO: check if gameIdController.text.trim() is a valid game ID
                                    Navigator.pushReplacementNamed(
                                      context,
                                      LobbyScreen.routeName,
                                      arguments: LobbyScreenArguments(
                                        gameIdController.text.trim(),
                                      ),
                                    );
                                  },
                                  child: const Text('Join'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: const Text(
                      'Join manually',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, BrowseGamesScreen.routeName);
                    },
                    child: const Text('Browse games'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // TODO
                    },
                    child: const Text('Statistics (TBA)'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      userService.logout();
                      Navigator.pushReplacementNamed(context, WelcomeScreen.routeName);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                    ),
                    child: const Text('Logout'),
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
