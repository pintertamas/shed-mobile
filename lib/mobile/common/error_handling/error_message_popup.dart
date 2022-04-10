import 'package:flutter/material.dart';

Future errorMessagePopup(BuildContext context, String errorMessage) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.red,
        content: Text(
          errorMessage,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      );
    },
  );
}
