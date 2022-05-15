import 'package:flutter/material.dart';

class CustomPlayingCard extends StatefulWidget {
  const CustomPlayingCard({
    required this.cardName,
    required this.size,
    Key? key,
  }) : super(key: key);
  final String cardName;
  final double size;

  @override
  State<CustomPlayingCard> createState() => _CustomPlayingCardState();
}

class _CustomPlayingCardState extends State<CustomPlayingCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size,
      width: widget.size / 1.4,
      //color: Colors.red,
      child: Image.asset(
        'assets/cards/${widget.cardName}.png',
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
