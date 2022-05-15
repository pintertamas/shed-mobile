import 'package:flutter/material.dart';
import 'package:websocket_mobile/common/model/card_state.dart';
import 'package:websocket_mobile/common/model/playing_card.dart';
import 'package:websocket_mobile/common/service/card_service.dart';
import 'package:websocket_mobile/common/service/game_service.dart';
import 'package:websocket_mobile/mobile/lobby/service/websocket_service.dart';
import 'package:websocket_mobile/web/create_game/model/player_data.dart';
import 'package:websocket_mobile/web/create_game/screen/create_game_screen.dart';
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
  late Future<void> loadData;

  Future<void> fetchData() async {
    await gameService.loadConnectedUsers(connectedUsers);
    for (final String username in connectedUsers) {
      final List<PlayingCard> cardsUp =
          await cardService.fetchPlayerCards(CardState.Visible);
      final List<PlayingCard> cardsDown =
          await cardService.fetchPlayerCards(CardState.Invisible);
      playerData.add(PlayerData(username, cardsUp, cardsDown));
    }
  }

  @override
  void initState() {
    gameService = GameService();
    cardService = CardService();
    webSocketService = WebSocketService();
    webSocketService.initStompClient('unknown');
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
          return Scaffold(
            backgroundColor: Colors.brown,
            body: Stack(
              children: [
                const TableCard(name: 'back'),
                const TableCard(name: 'diamonds2'),
              ],
            ),
          );
        },
      ),
    );
  }
}
