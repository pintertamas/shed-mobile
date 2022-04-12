import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextInput extends StatefulWidget {
  CustomTextInput({
    required this.hint,
    required this.controller,
    required this.validator,
    this.isPassword,
    this.keyboardType,
    Key? key,
  }) : super(key: key);
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  bool? isPassword;
  TextInputType? keyboardType;

  @override
  State<CustomTextInput> createState() => _CustomTextInputState();
}

class _CustomTextInputState extends State<CustomTextInput> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(30),
        ],
        validator: widget.validator,
        keyboardType: widget.keyboardType ?? TextInputType.text,
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
          suffixIcon: widget.isPassword ?? false
              ? IconButton(
                  icon: SizedBox(
                    width: 20,
                    child: Center(
                      child: Icon(
                        _isObscure ? Icons.visibility : Icons.visibility_off,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                )
              : Icon(null),
          errorMaxLines: 11,
        ),
        controller: widget.controller,
        obscureText: widget.isPassword != null ? _isObscure : false,
        enableSuggestions: widget.isPassword ?? false,
        autocorrect: widget.isPassword ?? false,
      ),
    );
  }
}
