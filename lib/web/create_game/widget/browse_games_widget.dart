import 'package:animated_button/animated_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:websocket_mobile/mobile/lobby/model/lobby_screen_arguments.dart';
import 'package:websocket_mobile/mobile/lobby/screen/lobby_screen.dart';
import 'package:websocket_mobile/mobile/lobby/service/websocket_service.dart';
import 'package:websocket_mobile/web/create_game/model/game.dart';
import 'package:websocket_mobile/web/create_game/service/game_service.dart';

class BrowseGamesWidget extends StatefulWidget {
  const BrowseGamesWidget({
    required this.paddingSize,
    required this.buttonWidth,
    required this.buttonHeight,
    Key? key,
  }) : super(key: key);
  final double paddingSize;
  final double buttonWidth;
  final double buttonHeight;

  @override
  State<BrowseGamesWidget> createState() => _BrowseGamesWidgetState();
}

class _BrowseGamesWidgetState extends State<BrowseGamesWidget> {
  late GameService gameService;
  late WebSocketService webSocketService;
  late Future<List<Game>> listOfGames;

  Future<List<Game>> loadGameList() async {
    final List<Game> games = await gameService.getListOfGames();
    for (final Game game in games) {
      if (!games.contains(game)) {
        games.add(game);
      }
    }
    return games;
  }

  Stream<List<Game>> gameStream() async* {
    while (true) {
      await Future.delayed(const Duration(milliseconds: 3000));
      final List<Game> games = await loadGameList();
      yield games;
    }
  }

  @override
  void initState() {
    gameService = GameService();
    webSocketService = WebSocketService();
    listOfGames = loadGameList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(widget.paddingSize / 2),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              bottom: widget.paddingSize / 2,
            ),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    offset: Offset.fromDirection(
                      1.5,
                      5,
                    ),
                    color: const Color.fromRGBO(57, 131, 60, 1.0),
                  ),
                ],
              ),
              child: const Text(
                'Browse games',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: widget.paddingSize / 2,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: StreamBuilder<List<Game>>(
                  stream: gameStream(),
                  builder: (context, AsyncSnapshot<List<Game>> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text(
                          'No games found!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: index.isOdd
                                  ? Colors.green.shade50
                                  : Colors.green.shade100,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                selectedColor: Colors.red,
                                hoverColor: Colors.grey,
                                iconColor: Colors.green,
                                leading: const Icon(FontAwesomeIcons.gamepad),
                                trailing: AnimatedButton(
                                  width: widget.buttonWidth,
                                  height: widget.buttonHeight,
                                  color: Colors.green,
                                  onPressed: () {
                                    webSocketService
                                        .initStompClient(
                                          snapshot.data![index].name,
                                        )
                                        .then(
                                          (value) => {
                                            if (kIsWeb)
                                              Navigator.pushNamed(
                                                context,
                                                LobbyScreen.routeName,
                                                //TODO it should redirect to the actual table screen that needs to be implemented
                                                arguments: LobbyScreenArguments(
                                                  snapshot.data![index].name,
                                                ),
                                              )
                                            else
                                              {
                                                Navigator.pushNamed(
                                                  context,
                                                  LobbyScreen.routeName,
                                                  arguments:
                                                      LobbyScreenArguments(
                                                    snapshot.data![index].name,
                                                  ),
                                                ),
                                              }
                                          },
                                        );
                                  },
                                  child: const Text(
                                    'Join',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  snapshot.data![index].name,
                                ),
                              ),
                            ),
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
            ),
          ),
        ],
      ),
    );
  }
}
