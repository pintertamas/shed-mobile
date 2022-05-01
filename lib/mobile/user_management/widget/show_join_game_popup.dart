import 'package:flutter/material.dart';
import 'package:websocket_mobile/common/error_handling/error_message_popup.dart';
import 'package:websocket_mobile/common/service/game_service.dart';
import 'package:websocket_mobile/mobile/lobby/model/lobby_screen_arguments.dart';
import 'package:websocket_mobile/mobile/lobby/screen/lobby_screen.dart';
import 'package:websocket_mobile/mobile/user_management/service/validation_service.dart';
import 'package:websocket_mobile/mobile/user_management/widget/custom_button.dart';
import 'package:websocket_mobile/mobile/user_management/widget/custom_text_input.dart';

Future showJoinGamePopup({
  required BuildContext context,
  required GlobalKey<FormState> formKey,
  required TextEditingController gameIdController,
  required GameService gameService,
}) =>
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
              Form(
                key: formKey,
                child: CustomTextInput(
                  hint: 'Game name',
                  controller: gameIdController,
                  validator: ValidationService.validateGameId(
                    gameIdController.text,
                  ),
                ),
              ),
              CustomButton(
                onPressed: () async {
                  bool gameExists = true;
                  if (formKey.currentState!.validate()) {
                    // TODO: check if gameIdController.text.trim() is a valid game ID
                    await gameService
                        .isGameExist(gameIdController.text.trim())
                        .then(
                          (value) => {
                            if (!value)
                              {
                                errorMessagePopup(
                                  context,
                                  'Game not found with this name\n${gameIdController.text.trim()}',
                                ),
                                gameExists = false,
                              }
                          },
                        );
                    if (!gameExists) return;
                    gameService
                        .saveGameName(
                          gameIdController.text.trim(),
                        )
                        .then(
                          (value) => {
                            Navigator.pushReplacementNamed(
                              context,
                              LobbyScreen.routeName,
                              arguments: LobbyScreenArguments(
                                gameId: gameIdController.text.trim(),
                              ),
                            ),
                          },
                        );
                  }
                },
                width: MediaQuery.of(context).size.width * 0.5,
                text: 'Join',
              ),
            ],
          ),
        );
      },
    );
