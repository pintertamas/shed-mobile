import 'package:flutter/material.dart';

class CustomTextInput extends StatefulWidget {
  CustomTextInput({
    required this.hint,
    required this.controller,
    this.isPassword,
    Key? key,
  }) : super(key: key);
  final String hint;
  final TextEditingController controller;
  bool? isPassword;

  @override
  State<CustomTextInput> createState() => _CustomTextInputState();
}

class _CustomTextInputState extends State<CustomTextInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        cursorColor: Colors.brown,
        decoration: InputDecoration(
          hintText: widget.hint,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.brown,
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green,
              width: 2,
            ),
          ),
          border: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),
        ),
        controller: widget.controller,
        obscureText: widget.isPassword ?? false,
        enableSuggestions: widget.isPassword ?? false,
        autocorrect: widget.isPassword ?? false,
      ),
    );
  }
}
