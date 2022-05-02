import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:websocket_mobile/common/model/game_cards.dart';
import 'package:websocket_mobile/common/service/card_service.dart';
import 'package:websocket_mobile/common/service/game_service.dart';
import 'package:websocket_mobile/common/widget/card_widget.dart';
import 'package:websocket_mobile/mobile/game/model/game_provider.dart';
import 'package:websocket_mobile/mobile/game/widget/cards_on_table_positioned_row.dart';
import 'package:websocket_mobile/mobile/lobby/model/connection_model.dart';
import 'package:websocket_mobile/mobile/lobby/service/websocket_service.dart';
import 'package:websocket_mobile/mobile/user_management/screen/loading_screen.dart';
import 'package:websocket_mobile/mobile/user_management/widget/custom_button.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({
    required this.webSocketService,
    required this.gameId,
    Key? key,
  }) : super(key: key);
  final WebSocketService webSocketService;
  final String gameId;

  static const routeName = '/game';

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameService gameService;
  late CardService cardService;
  static const padding = 20.0;
  late Future<GameCards> getGameCards;

  @override
  void initState() {
    gameService = GameService();
    cardService = CardService();
    getGameCards = cardService.fetchGameCards();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    final provider = Provider.of<GameProvider>(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Visibility(
      visible: MediaQuery.of(context).orientation != Orientation.portrait,
      child: WillPopScope(
        onWillPop: () async {
          print('leaving game');
          gameService
              .leaveGame()
              .then((value) => widget.webSocketService.deactivate())
              .then(
                (value) => Navigator.pushReplacementNamed(
                  context,
                  LoadingScreen.routeName,
                ),
              );
          return true;
        },
        child: FutureBuilder<GameCards>(
          future: getGameCards.then((value) => provider.setCards(value)),
          builder: (context, snapshot) {
            return StreamBuilder<WebSocketEvent>(
              stream: widget.webSocketService.webSocketStream,
              builder: (
                BuildContext context,
                AsyncSnapshot<WebSocketEvent> snapshot,
              ) {
                if (snapshot.hasData && snapshot.data != null) {
                  if (snapshot.data!.type == 'played') {
                    provider.playCards(widget.webSocketService);
                  } else if (snapshot.data!.type == 'invalid') {
                    provider.selectedCards.clear();
                  }
                }
                return SafeArea(
                  child: Scaffold(
                    backgroundColor: Colors.brown,
                    body: Center(
                      child: Stack(
                        children: [
                          Positioned(
                            top: padding,
                            left: padding,
                            child: CustomButton(
                              text: 'Play',
                              width: width / 2 - height / 2 / 1.4 - padding * 7,
                              color: Colors.green,
                              enabled: true,
                              onPressed: () {
                                provider.playCards(widget.webSocketService);
                                setState(() {});
                              },
                            ),
                          ),
                          Positioned(
                            top: padding,
                            right: padding,
                            child: CustomButton(
                              text: 'Leave',
                              width: width / 2 - height / 2 / 1.4 - padding * 7,
                              color: Colors.red,
                              enabled: true,
                              onPressed: () async {
                                print('leaving game');
                                gameService
                                    .leaveGame()
                                    .then(
                                      (value) =>
                                          widget.webSocketService.deactivate(),
                                    )
                                    .then(
                                      (value) => Navigator.pushReplacementNamed(
                                        context,
                                        LoadingScreen.routeName,
                                      ),
                                    );
                              },
                            ),
                          ),
                          CardsOnTablePositionedRow(
                            top: 0,
                            left: width / 2 - height / 2 / 1.4 - padding * 5,
                            cards: provider.cardsDown,
                            padding: padding,
                            width: width,
                            height: height,
                            isVisible: false,
                          ),
                          CardsOnTablePositionedRow(
                            top: padding,
                            left: width / 2 - height / 2 / 1.4 - padding * 5,
                            cards: context.read<GameProvider>().cardsUp,
                            padding: padding,
                            width: width,
                            height: height,
                            isVisible: true,
                          ),
                          if (context
                              .read<GameProvider>()
                              .cardsInHand
                              .isNotEmpty)
                            Positioned(
                              top: height / 2,
                              left: 0,
                              child: Container(
                                width: width,
                                height: height / 2 - padding,
                                color: Colors.green,
                                child: ListView.builder(
                                  itemCount: context
                                      .read<GameProvider>()
                                      .cardsInHand
                                      .length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return CardWidget(
                                      id: context
                                          .read<GameProvider>()
                                          .cardsInHand[index]
                                          .id,
                                      number: context
                                          .read<GameProvider>()
                                          .cardsInHand[index]
                                          .number,
                                      shape: context
                                          .read<GameProvider>()
                                          .cardsInHand[index]
                                          .shape,
                                      rule: context
                                          .read<GameProvider>()
                                          .cardsInHand[index]
                                          .rule,
                                      state: context
                                          .read<GameProvider>()
                                          .cardsInHand[index]
                                          .state,
                                      size: height / 2,
                                      isVisible: true,
                                    );
                                  },
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    widget.webSocketService.deactivate();
    super.dispose();
  }
}
