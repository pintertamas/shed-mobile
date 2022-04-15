import 'package:flutter/material.dart';
import 'package:websocket_mobile/mobile/user_management/widget/custom_button.dart';
import 'package:websocket_mobile/web/create_game/model/qr_screen_arguments.dart';
import 'package:websocket_mobile/web/create_game/screen/qr_screen.dart';
import 'package:websocket_mobile/web/create_game/service/game_service.dart';

class GameConfigWidget extends StatefulWidget {
  const GameConfigWidget({Key? key}) : super(key: key);

  @override
  State<GameConfigWidget> createState() => _GameConfigWidgetState();
}

class _GameConfigWidgetState extends State<GameConfigWidget> {
  double paddingSize = 20.0;
  GameService gameService = GameService();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(paddingSize / 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: paddingSize / 2),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.green.shade50,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: paddingSize / 2),
            child: Center(
              child: CustomButton(
                onPressed: () async {
                  gameService.createGame().then(
                        (gameName) => {
                          print('gameName: $gameName'),
                          if (gameName != '' && gameName != 'error')
                            {
                              Navigator.pushNamed(
                                context,
                                QRScreen.routeName,
                                arguments: QRScreenArguments(gameName),
                              ),
                            },
                        },
                      );
                },
                size: MediaQuery.of(context).size.width * 0.5,
                text: 'Create game',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
