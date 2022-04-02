import 'package:flutter/material.dart';
import 'package:websocket_mobile/mobile/user_management/screen/home_screen.dart';
import 'package:websocket_mobile/mobile/user_management/service/user_service.dart';
import 'package:websocket_mobile/mobile/user_management/widget/custom_input_container.dart';

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
    return CustomInputContainer(
      usernameController: usernameController,
      passwordController: passwordController,
      isLogin: false,
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
              (response) async => {
                await userService.login(
                  usernameController.text,
                  passwordController.text,
                ),
                print('response: $response'),
                if (response)
                  Navigator.pushReplacementNamed(
                    context,
                    HomeScreen.routeName,
                  ),
              },
            );
      },
    );
  }
}
