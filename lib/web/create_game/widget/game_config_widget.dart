import 'package:flutter/material.dart';
import 'package:websocket_mobile/web/create_game/model/qr_screen_arguments.dart';
import 'package:websocket_mobile/web/create_game/screen/qr_screen.dart';

Widget gameConfigWidget(BuildContext context, double paddingSize) => Padding(
      padding: EdgeInsets.all(paddingSize / 2),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black26,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(paddingSize),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: paddingSize / 2),
                  child: Container(
                    color: Colors.green.shade100,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: paddingSize / 2),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: create game
                      const String gameName = 'Canoodle_Gobemouche';
                      Navigator.pushNamed(
                        context,
                        QRScreen.routeName,
                        arguments: QRScreenArguments(gameName),
                      );
                    },
                    child: const Text(
                      'Create game',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
