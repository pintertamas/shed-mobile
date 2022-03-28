import 'package:flutter/material.dart';

import 'package:websocket_mobile/mobile/user_management/widget/custom_button.dart';
import 'package:websocket_mobile/mobile/user_management/widget/custom_text_input.dart';

class CustomInputContainer extends StatefulWidget {
  const CustomInputContainer({
    required this.usernameController,
    required this.passwordController,
    required this.isLogin,
    required this.onPressed,
    Key? key,
  }) : super(key: key);
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool isLogin;
  final void Function() onPressed;

  @override
  State<CustomInputContainer> createState() => _CustomInputContainerState();
}

class _CustomInputContainerState extends State<CustomInputContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.brown,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.white70,
                    spreadRadius: 3,
                    offset: Offset(1.5, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTextInput(
                      hint: 'username',
                      controller: widget.usernameController,
                    ),
                    CustomTextInput(
                      hint: 'password',
                      controller: widget.passwordController,
                      isPassword: true,
                    ),
                    if (widget.isLogin)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: TextButton(
                          onPressed: () {
                            print('forgot password');
                          },
                          child: const Text(
                            'Forgot password',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: widget.isLogin ? 0.0 : 20.0),
                      child: CustomButton(
                        onPressed: widget.onPressed,
                        size: MediaQuery.of(context).size.width * 0.5,
                        text: widget.isLogin ? 'Login' : 'Register',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
