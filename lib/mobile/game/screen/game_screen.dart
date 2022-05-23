import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:websocket_mobile/common/model/game_cards.dart';
import 'package:websocket_mobile/common/service/card_service.dart';
import 'package:websocket_mobile/common/service/game_service.dart';
import 'package:websocket_mobile/common/widget/card_widget.dart';
import 'package:websocket_mobile/mobile/game/model/game_provider.dart';
import 'package:websocket_mobile/mobile/game/widget/cards_on_table_positioned_row.dart';
import 'package:websocket_mobile/mobile/lobby/model/websocket_event.dart';
import 'package:websocket_mobile/mobile/lobby/service/websocket_service.dart';
import 'package:websocket_mobile/mobile/user_management/screen/loading_screen.dart';
import 'package:websocket_mobile/mobile/user_management/service/user_service.dart';
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
  late Future<void> getUsername;
  late String username;
  bool shouldLoad = true;

  String lastUuid = '';
  String errorMessage = '';

  Future<void> setUsername() async {
    username = await UserService.getUsername();
  }

  Future<GameCards> loadData(GameProvider provider) async {
    if (shouldLoad) {
      await UserService.getUsername();
      final GameCards gameCards = await cardService.fetchGameCards();
      shouldLoad = false;
      if (mounted) {
        return provider.setCards(gameCards);
      }
    }
    return GameCards([], [], []);
  }

  @override
  void initState() {
    gameService = GameService();
    cardService = CardService();
    getGameCards = cardService.fetchGameCards();
    getUsername = setUsername();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    if (!mounted) return const Center();
    setState(() {});

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
          future: loadData(Provider.of<GameProvider>(context)),
          builder: (context, futureSnapshot) {
            final game = context.read<GameProvider>();
            if (futureSnapshot.hasData) {
              return StreamBuilder<WebSocketEvent>(
                stream: widget.webSocketService.webSocketStream,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<WebSocketEvent> snapshot,
                ) {
                  if (snapshot.hasData && snapshot.data != null) {
                    if (snapshot.data?.username == username) {
                      if (snapshot.data?.uuid != lastUuid) {
                        shouldLoad = true;
                        lastUuid = snapshot.data?.uuid ?? 'uuid';
                        if (snapshot.data!.type == 'valid') {
                          print('drawn cards:');
                          for (final card in snapshot.data!.cards!) {
                            print(card.toJson());
                          }
                          WidgetsBinding.instance?.addPostFrameCallback(
                            (_) => {
                              game.deletePlayedCards(),
                              getGameCards.then(
                                (value) => {
                                  game.setCards(value),
                                  print('cards were set'),
                                },
                              ),
                            },
                          );
                        } else if (snapshot.data!.type == 'invalid') {
                          game.selectedCards.clear();
                          if (errorMessage !=
                              snapshot.data!.message.toString()) {
                            errorMessage = snapshot.data!.message.toString();
                            print('invalid message: $errorMessage');
                          }
                        }
                      }
                    }
                  }
                  return Consumer<GameProvider>(
                    builder: (context, game, child) {
                      return SafeArea(
                        child: Scaffold(
                          backgroundColor: Colors.brown,
                          body: Center(
                            child: Stack(
                              children: [
                                Positioned(
                                  top: padding,
                                  left: padding,
                                  child: Column(
                                    children: [
                                      CustomButton(
                                        text: 'Play',
                                        width: width / 2 -
                                            height / 2 / 1.4 -
                                            padding * 7,
                                        color: Colors.green,
                                        enabled: !shouldLoad,
                                        onPressed: () {
                                          game.playCards(widget.webSocketService);
                                        },
                                      ),
                                      CustomButton(
                                        text: 'Draw',
                                        width: width / 2 -
                                            height / 2 / 1.4 -
                                            padding * 7,
                                        color: Colors.blue,
                                        enabled: !shouldLoad,
                                        onPressed: () {
                                          //gameService.drawCards(widget.webSocketService);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: padding,
                                  right: padding,
                                  child: CustomButton(
                                    text: 'Leave',
                                    width: width / 2 -
                                        height / 2 / 1.4 -
                                        padding * 7,
                                    color: Colors.red,
                                    enabled: true,
                                    onPressed: () async {
                                      print('leaving game');
                                      gameService
                                          .leaveGame()
                                          .then(
                                            (value) => widget.webSocketService
                                                .deactivate(),
                                          )
                                          .then(
                                            (value) =>
                                                Navigator.pushReplacementNamed(
                                              context,
                                              LoadingScreen.routeName,
                                            ),
                                          );
                                    },
                                  ),
                                ),
                                CardsOnTablePositionedRow(
                                  top: 0,
                                  left: width / 2 -
                                      height / 2 / 1.4 -
                                      padding * 5,
                                  cards: game.cardsDown,
                                  padding: padding,
                                  width: width,
                                  height: height,
                                  isVisible: false,
                                ),
                                CardsOnTablePositionedRow(
                                  top: padding,
                                  left: width / 2 -
                                      height / 2 / 1.4 -
                                      padding * 5,
                                  cards: game.cardsUp,
                                  padding: padding,
                                  width: width,
                                  height: height,
                                  isVisible: true,
                                ),
                                if (game.cardsInHand.isNotEmpty)
                                  Positioned(
                                    top: height / 2,
                                    left: 0,
                                    child: Container(
                                      width: width,
                                      height: height / 2 - padding,
                                      color: Colors.green,
                                      child: ListView.builder(
                                        itemCount: game.cardsInHand.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return CardWidget(
                                            playingCard:
                                                game.cardsInHand[index],
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
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
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
