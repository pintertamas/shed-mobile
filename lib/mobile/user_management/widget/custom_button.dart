import 'package:animated_button/animated_button.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  CustomButton({required this.onPressed, required this.text, this.size, Key? key})
      : super(key: key);
  final void Function() onPressed;
  final String text;
  double? size;

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
        width: widget.size ?? MediaQuery.of(context).size.width * 0.8,
        color: Colors.green,
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
