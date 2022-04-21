import 'package:flutter/material.dart';

import 'package:websocket_mobile/web/create_game/widget/browse_games_widget.dart';
import 'package:websocket_mobile/web/create_game/widget/game_config_widget.dart';

class CreateGameScreen extends StatefulWidget {
  const CreateGameScreen({Key? key}) : super(key: key);

  static const routeName = '/create';

  @override
  State<CreateGameScreen> createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends State<CreateGameScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.brown,
        body: Center(
          child: Row(
            children: const [
              Expanded(
                flex: 2,
                child: BrowseGamesWidget(paddingSize: 20.0),
              ),
              Expanded(
                flex: 3,
                child: GameConfigWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
