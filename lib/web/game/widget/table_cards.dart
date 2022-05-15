import 'package:flutter/material.dart';
import 'package:websocket_mobile/common/widget/custom_playing_card.dart';

class TableCard extends StatefulWidget {
  const TableCard({
    required this.name,
    Key? key,
  }) : super(key: key);
  final String name;

  @override
  State<TableCard> createState() => _TableCardState();
}

class _TableCardState extends State<TableCard> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.4,
      left: widget.name == 'back' ? MediaQuery.of(context).size.width * 0.425 : null,
      right: widget.name != 'back' ? MediaQuery.of(context).size.width * 0.425 : null,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.075,
        height: MediaQuery.of(context).size.height * 0.2,
        color: Colors.red,
        child: CustomPlayingCard(
          size: 20,
          cardName: widget.name,
        ),
      ),
    );
  }
}
