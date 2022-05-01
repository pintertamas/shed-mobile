import 'package:flutter/cupertino.dart';
import 'package:websocket_mobile/common/model/card.dart';
import 'package:websocket_mobile/common/widget/card_widget.dart';
import 'package:websocket_mobile/mobile/game/model/game_provider.dart';

class CardsOnTablePositionedRow extends StatelessWidget {
  const CardsOnTablePositionedRow({
    required this.cards,
    required this.padding,
    required this.width,
    required this.height,
    required this.provider,
    required this.isVisible,
    required this.top,
    required this.left,
    Key? key,
  }) : super(key: key);
  final double padding;
  final double width;
  final double height;
  final GameProvider provider;
  final List<Card> cards;
  final bool isVisible;
  final double top;
  final double left;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      child: SizedBox(
        height: height / 2,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: cards.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return CardWidget(
              number: cards[index].number,
              shape: cards[index].shape,
              rule: cards[index].rule,
              size: height / 2,
              isVisible: isVisible,
            );
          },
        ),
      ),
    );
  }
}
