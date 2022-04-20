import 'package:animated_button/animated_button.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  CustomButton({
    required this.onPressed,
    required this.text,
    this.width,
    this.color,
    Key? key,
  }) : super(key: key);
  final void Function() onPressed;
  final String text;
  double? width;
  Color? color;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: AnimatedButton(
        onPressed: widget.onPressed,
        width: widget.width ?? MediaQuery.of(context).size.width * 0.8,
        color: widget.color != null ? widget.color! : Colors.green,
        child: Text(
          widget.text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
