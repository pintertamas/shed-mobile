import 'package:flutter/cupertino.dart';
import 'package:websocket_mobile/common/model/playing_card.dart';
import 'package:websocket_mobile/common/model/card_state.dart';
import 'package:websocket_mobile/common/model/rule.dart';
import 'package:websocket_mobile/common/model/shape.dart';
import 'package:websocket_mobile/common/widget/custom_playing_card.dart';
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
    required this.provider,
    Key? key,
  }) : super(key: key);
  final int id;
  final int number;
  final Shape shape;
  final Rule rule;
  final CardState state;
  final double size;
  final bool isVisible;
  final GameProvider provider;

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  double top = 200;

  @override
  Widget build(BuildContext context) {
    //final provider = Provider.of<GameProvider>(context);
    final provider = widget.provider;
    final String shape = widget.shape.name.toLowerCase();
    final String cardName =
        widget.isVisible ? '$shape${widget.number}' : 'back';

    return GestureDetector(
      onTap: () {
        final PlayingCard card = PlayingCard(
          widget.id,
          widget.number,
          widget.shape,
          widget.rule,
          widget.state,
        );
        provider.selectCard(card);
        print('selectedCards:');
        for (final PlayingCard card in provider.selectedCards) {
          print(card.toJson());
        }
      },
      child: CustomPlayingCard(
        cardName: cardName,
        size: widget.size,
      ),
    );
  }
}
