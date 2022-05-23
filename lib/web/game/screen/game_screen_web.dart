import 'package:flutter/material.dart';
import 'package:websocket_mobile/common/model/card_state.dart';
import 'package:websocket_mobile/common/model/card_type.dart';
import 'package:websocket_mobile/common/model/playing_card.dart';
import 'package:websocket_mobile/common/service/card_service.dart';
import 'package:websocket_mobile/common/service/game_service.dart';
import 'package:websocket_mobile/mobile/lobby/model/websocket_event.dart';
import 'package:websocket_mobile/mobile/lobby/service/websocket_service.dart';
import 'package:websocket_mobile/web/create_game/model/player_data.dart';
import 'package:websocket_mobile/web/create_game/screen/create_game_screen.dart';
import 'package:websocket_mobile/web/game/model/table_cards.dart';
import 'package:websocket_mobile/web/game/widget/table_cards.dart';

class GameScreenWeb extends StatefulWidget {
  const GameScreenWeb({
    required this.webSocketService,
    Key? key,
  }) : super(key: key);
  final WebSocketService webSocketService;

  static const routeName = '/game-web';

  @override
  State<GameScreenWeb> createState() => _GameScreenWebState();
}

class _GameScreenWebState extends State<GameScreenWeb> {
  late WebSocketService webSocketService;
  late GameService gameService;
  late CardService cardService;
  List<String> connectedUsers = [];
  List<PlayerData> playerData = [];
  late TableCards tableCards = TableCards([], []);

  late Future<void> loadData;

  Future<void> fetchData() async {
    await gameService.loadConnectedUsers(connectedUsers);
    print(connectedUsers.toString());
    for (final String username in connectedUsers) {
      final List<PlayingCard> cardsUp = await cardService
          .fetchCards(CardType.Player, CardState.Visible, username: username);
      final List<PlayingCard> cardsDown = await cardService
          .fetchCards(CardType.Player, CardState.Invisible, username: username);
      playerData.add(PlayerData(username, cardsUp, cardsDown));
    }
    try {
      final List<PlayingCard> tableCardsPick =
          await cardService.fetchCards(CardType.Table, CardState.Pick);
      final List<PlayingCard> tableCardsThrow =
          await cardService.fetchCards(CardType.Table, CardState.Throw);

      tableCards = TableCards(tableCardsPick, tableCardsThrow);

      print('table cards pick length: ${tableCards.picks.length}');
      print('table cards throw length: ${tableCards.throws.length}');
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    gameService = GameService();
    cardService = CardService();
    webSocketService = WebSocketService();
    webSocketService.initStompClient();
    loadData = fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        webSocketService.deactivate();
        Navigator.pushNamed(
          context,
          CreateGameScreen.routeName,
        );
        return true;
      },
      child: FutureBuilder<void>(
        future: loadData,
        builder: (context, snapshot) {
          tableCards.picks.toString();
          if (snapshot.connectionState == ConnectionState.done) {
            return StreamBuilder<WebSocketEvent>(
                stream: widget.webSocketService.webSocketStream,
                builder: (
                    BuildContext context,
                    AsyncSnapshot<WebSocketEvent> snapshot,
                    ) {
                  if (snapshot.hasData && snapshot.data != null) {
                    if (snapshot.data!.type == 'valid') {
                      print('valid card received');
                    } else if (snapshot.data!.type == 'invalid') {
                      print('invalid card received');
                    }
                    else {
                      print(snapshot.data?.type);
                    }
                  }
                return Scaffold(
                  backgroundColor: Colors.brown,
                  body: Stack(
                    children: [
                      TableCard(
                        name: 'back',
                        isEmpty: tableCards.throws.isNotEmpty,
                      ),
                      TableCard(
                        name:
                            '${tableCards.picks.first.shape.name.toLowerCase()}${tableCards.picks.first.number}',
                        isEmpty: tableCards.picks.isNotEmpty,
                      ),
                    ],
                  ),
                );
              }
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
