import 'package:flutter/material.dart';
import 'package:websocket_mobile/web/create_game/widget/browse_games_widget.dart';

class BrowseGamesScreen extends StatefulWidget {
  const BrowseGamesScreen({Key? key}) : super(key: key);

  static const routeName = '/browse';

  @override
  State<BrowseGamesScreen> createState() => _BrowseGamesScreenState();
}

class _BrowseGamesScreenState extends State<BrowseGamesScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.brown,
        body: BrowseGamesWidget(
          paddingSize: 20.0,
          buttonWidth: MediaQuery.of(context).size.width * 0.3,
          buttonHeight: MediaQuery.of(context).size.width * 0.1,
        ),
      ),
    );
  }
}
