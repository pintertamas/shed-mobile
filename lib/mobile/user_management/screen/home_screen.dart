import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:websocket_mobile/mobile/game/service/game_service.dart';
import 'package:websocket_mobile/mobile/lobby/screen/browse_games.dart';
import 'package:websocket_mobile/mobile/lobby/screen/scan_game_id_screen.dart';
import 'package:websocket_mobile/mobile/user_management/screen/welcome_screen.dart';
import 'package:websocket_mobile/mobile/user_management/service/user_service.dart';
import 'package:websocket_mobile/mobile/user_management/widget/custom_button.dart';
import 'package:websocket_mobile/mobile/user_management/widget/show_join_game_popup.dart';

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
  final formKey = GlobalKey<FormState>();

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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          ScanGameIdScreen.routeName,
                        );
                      },
                      text: 'Scan QR code',
                    ),
                    CustomButton(
                      onPressed: () {
                        showJoinGamePopup(
                          context: context,
                          formKey: formKey,
                          gameIdController: gameIdController,
                          gameService: gameService,
                        );
                      },
                      text: 'Join manually',
                    ),
                    CustomButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          BrowseGamesScreen.routeName,
                        );
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
                          context,
                          WelcomeScreen.routeName,
                        );
                      },
                      isRed: true,
                      text: 'Logout',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
