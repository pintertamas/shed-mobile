import 'package:flutter/material.dart';
import 'package:websocket_mobile/lobby/screen/scan_game_id_screen.dart';
import 'package:websocket_mobile/login/widget/custom_text_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    //double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Container(
            width: _width,
            color: Colors.grey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextInput(
                    hint: "username",
                    controller: usernameController,
                  ),
                  CustomTextInput(
                    hint: "password",
                    controller: passwordController,
                  ),
                  TextButton(
                    onPressed: () {
                      print("forgot password");
                    },
                    child: Text(
                      "Forgot password",
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      print(
                        "Login> username: ${usernameController.text} password: ${passwordController.text}",
                      );
                        Navigator.pushNamed(context, ScanGameIdScreen.routeName);
                    },
                    child: Text(
                      "Login",
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      print("Sign up");
                    },
                    child: Text(
                      "Sign up",
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
