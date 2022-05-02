import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:websocket_mobile/common/model/card.dart';
import 'package:websocket_mobile/common/model/card_state.dart';
import 'package:websocket_mobile/common/model/rule.dart';
import 'package:websocket_mobile/common/model/shape.dart';
import 'package:websocket_mobile/mobile/game/model/game_provider.dart';

class CardWidget extends StatefulWidget {
  const CardWidget({
    required this.id,
    required this.number,
    required this.shape,
    required this.rule,
    required this.state,
    required this.size,
    required this.isVisible,
    Key? key,
  }) : super(key: key);
  final int id;
  final int number;
  final Shape shape;
  final Rule rule;
  final CardState state;
  final double size;
  final bool isVisible;

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  double top = 200;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context);
    final String shape = widget.shape.name.toLowerCase();
    final String cardName =
        widget.isVisible ? '$shape${widget.number}' : 'back';

    return GestureDetector(
      onTap: () {
        final Card card = Card(
          widget.id,
          widget.number,
          widget.shape,
          widget.rule,
          widget.state,
        );
        provider.selectCard(card);
        print('selectedCards:');
        for (final Card card in provider.selectedCards) {
          print(card.toJson());
        }
      },
      child: SizedBox(
        height: widget.size,
        width: widget.size / 1.4,
        //color: Colors.red,
        child: Image.asset(
          'assets/cards/$cardName.png',
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}
