import 'package:flutter/material.dart';

class GameScreenWeb extends StatefulWidget {
  const GameScreenWeb({Key? key}) : super(key: key);

  static const routeName = '/game-web';

  @override
  State<GameScreenWeb> createState() => _GameScreenWebState();
}

class _GameScreenWebState extends State<GameScreenWeb> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      body: Container(),
    );
  }
}
