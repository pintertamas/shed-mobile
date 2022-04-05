import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:websocket_mobile/mobile/game/service/game_service.dart';
import 'package:websocket_mobile/mobile/lobby/model/lobby_screen_arguments.dart';
import 'package:websocket_mobile/mobile/lobby/screen/browse_games.dart';
import 'package:websocket_mobile/mobile/lobby/screen/lobby_screen.dart';
import 'package:websocket_mobile/mobile/lobby/screen/scan_game_id_screen.dart';
import 'package:websocket_mobile/mobile/user_management/screen/welcome_screen.dart';
import 'package:websocket_mobile/mobile/user_management/service/user_service.dart';
import 'package:websocket_mobile/mobile/user_management/widget/custom_button.dart';
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
  GameService gameService = GameService();

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double _settingsIconGap = MediaQuery.of(context).size.height * 0.015;
    return Scaffold(
      backgroundColor: Colors.brown,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: _settingsIconGap,
              right: _settingsIconGap,
              child: IconButton(
                icon: const Icon(
                  FontAwesomeIcons.bars,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomButton(
                    onPressed: () {
                      Navigator.pushNamed(context, ScanGameIdScreen.routeName);
                    },
                    text: 'Scan game QR code',
                  ),
                  CustomButton(
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
                                CustomButton(
                                  onPressed: () {
                                    // TODO: check if gameIdController.text.trim() is a valid game ID
                                    gameService.saveGameName(
                                      gameIdController.text.trim(),
                                    );
                                    Navigator.pushReplacementNamed(
                                      context,
                                      LobbyScreen.routeName,
                                      arguments: LobbyScreenArguments(
                                        gameIdController.text.trim(),
                                      ),
                                    );
                                  },
                                  size: MediaQuery.of(context).size.width * 0.5,
                                  text: 'Join',
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    text: 'Join manually',
                  ),
                  CustomButton(
                    onPressed: () {
                      Navigator.pushNamed(context, BrowseGamesScreen.routeName);
                    },
                    text: 'Browse games',
                  ),
                  CustomButton(
                    onPressed: () {
                      // TODO
                    },
                    text: 'Statistics (TBA)',
                  ),
                  CustomButton(
                    onPressed: () {
                      userService.logout();
                      Navigator.pushReplacementNamed(
                          context, WelcomeScreen.routeName);
                    },
                    isRed: true,
                    text: 'Logout',
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
