import 'package:flutter/material.dart';
import 'package:websocket_mobile/mobile/user_management/screen/welcome_screen.dart';
import 'package:websocket_mobile/mobile/user_management/service/user_service.dart';
import 'package:websocket_mobile/mobile/user_management/widget/custom_text_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  static const routeName = '/sign-up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Container(
            width: _width,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextInput(
                    hint: 'username',
                    controller: usernameController,
                  ),
                  CustomTextInput(
                    hint: 'password',
                    controller: passwordController,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      print(
                        'Sign up> username: ${usernameController.text} password: ${passwordController.text}',
                      );
                      await userService
                          .register(
                            usernameController.text,
                            passwordController.text,
                          )
                          .then(
                            (response) => {
                              print('response: $response'),
                              if (response)
                                Navigator.pushReplacementNamed(
                                  context,
                                  WelcomeScreen.routeName,
                                ),
                            },
                          );
                    },
                    child: const Text(
                      'Register',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
