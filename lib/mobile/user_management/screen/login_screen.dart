import 'package:flutter/material.dart';
import 'package:websocket_mobile/mobile/user_management/screen/home_screen.dart';
import 'package:websocket_mobile/mobile/user_management/service/user_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'username',
                    ),
                    controller: usernameController,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'password',
                    ),
                    controller: passwordController,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                  ),
                  TextButton(
                    onPressed: () {
                      print('forgot password');
                    },
                    child: const Text(
                      'Forgot password',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      print(
                        'Login> username: ${usernameController.text} password: ${passwordController.text}',
                      );
                      await userService
                          .login(
                            usernameController.text,
                            passwordController.text,
                          )
                          .then(
                            (response) => {
                              print('response: $response'),
                              if (response)
                                Navigator.pushReplacementNamed(
                                  context,
                                  HomeScreen.routeName,
                                ),
                            },
                          );
                    },
                    child: const Text(
                      'Login',
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
