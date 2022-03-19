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
    const double _paddingSize = 20.0;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.yellow[100],
        body: Center(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: browseGamesWidget(_paddingSize),
              ),
              Expanded(
                flex: 3,
                child: gameConfigWidget(context, _paddingSize),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
