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
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context);
    final bool isSelected =
        !provider.containsCard(provider.selectedCards, widget.playingCard);

    final String shape = widget.playingCard.shape.name.toLowerCase();
    final String cardName =
        widget.isVisible ? '$shape${widget.playingCard.number}' : 'back';

    return GestureDetector(
      onTap: () {
        final PlayingCard card = widget.playingCard;
        provider.selectCard(card);
        print('selectedCards:');
        for (final PlayingCard card in provider.selectedCards) {
          print(card.toJson());
        }
      },
      child: AnimatedContainer(
        duration: const Duration(microseconds: 250),
        child: CustomPlayingCard(
          cardName: cardName,
          size: isSelected ? widget.size : widget.size * 1.15,
        ),
      ),
    );
  }
}
