import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:websocket_mobile/common/error_handling/error_message_popup.dart';
import 'package:websocket_mobile/mobile/user_management/screen/home_screen.dart';
import 'package:websocket_mobile/mobile/user_management/service/user_service.dart';
import 'package:websocket_mobile/mobile/user_management/widget/custom_input_container.dart';

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
  bool enabled = true;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomInputContainer(
      usernameController: usernameController,
      passwordController: passwordController,
      isLogin: true,
      enabled: enabled,
      onPressed: () async {
        if (!enabled) return;
        setState(() {
          enabled = false;
        });
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
                userService.saveUsername(usernameController.text),
                print('response: $response'),
                if (response)
                  {
                    Navigator.pushReplacementNamed(
                      context,
                      HomeScreen.routeName,
                    ),
                  }
                else
                  {
                    setState(() {
                      enabled = true;
                    }),
                    errorMessagePopup(
                      context,
                      'The username/password combination is incorrect!',
                    ),
                  }
              },
            )
            .whenComplete(
              () => {
                setState(
                  () {
                    enabled = true;
                  },
                ),
              },
            );
      },
    );
  }
}
