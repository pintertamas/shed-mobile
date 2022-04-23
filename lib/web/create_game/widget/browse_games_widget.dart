import 'package:animated_button/animated_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:websocket_mobile/web/create_game/service/game_service.dart';

import '../model/game.dart';

class BrowseGamesWidget extends StatefulWidget {
  const BrowseGamesWidget({required this.paddingSize, Key? key})
      : super(key: key);
  final double paddingSize;

  @override
  State<BrowseGamesWidget> createState() => _BrowseGamesWidgetState();
}

class _BrowseGamesWidgetState extends State<BrowseGamesWidget> {
  late GameService gameService;
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
                    if (snapshot.hasData) {
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  height:
                                      MediaQuery.of(context).size.width * 0.025,
                                  color: Colors.green,
                                  onPressed: () {},
                                  child: const Text(
                                    'Join',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
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
