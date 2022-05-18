import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:websocket_mobile/common/model/playing_card.dart';
import 'package:websocket_mobile/common/widget/custom_playing_card.dart';
import 'package:websocket_mobile/mobile/game/model/game_provider.dart';

class CardWidget extends StatefulWidget {
  const CardWidget({
    required this.playingCard,
    required this.size,
    required this.isVisible,
    Key? key,
  }) : super(key: key);
  final PlayingCard playingCard;
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

    final String shape = widget.playingCard.shape.name.toLowerCase();
    final String cardName =
        widget.isVisible ? '$shape${widget.playingCard.number}' : 'back';

    return GestureDetector(
      onTap: () {
        final PlayingCard card = PlayingCard(
          widget.playingCard.id,
          widget.playingCard.number,
          widget.playingCard.shape,
          widget.playingCard.rule,
          widget.playingCard.state,
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
