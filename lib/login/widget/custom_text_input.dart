import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  const CustomTextInput({Key? key, required this.hint, required this.controller}) : super(key: key);
  final String hint;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: hint,
        ),
        controller: controller,
      ),
    );
  }
}
