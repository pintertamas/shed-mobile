import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:websocket_mobile/mobile/common/error_handling/error_message_popup.dart';
import 'package:websocket_mobile/mobile/user_management/otp_screen_arguments.dart';
import 'package:websocket_mobile/mobile/user_management/screen/otp_screen.dart';
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
  TextEditingController emailController = TextEditingController();
  UserService userService = UserService();

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
      emailController: emailController,
      isLogin: false,
      onPressed: () async {
        print(
          'Sign up>\nusername: ${usernameController.text}\n'
          'password: ${passwordController.text}\n'
          'email: ${emailController.text}',
        );
        await userService
            .checkAvailability(
              usernameController.text,
              emailController.text,
            )
            .then(
              (response) async => {
                if (response)
                  {
                    userService
                        .generateOtp(
                          emailController.text,
                        )
                        .then(
                          (response) async => {
                            if (response)
                              Navigator.pushReplacementNamed(
                                context,
                                OtpScreen.routeName,
                                arguments: OtpScreenArguments(
                                  usernameController.text.trim(),
                                  passwordController.text.trim(),
                                  emailController.text.trim(),
                                ),
                              ),
                          },
                        ),
                  }
                else
                  {
                    errorMessagePopup(
                      context,
                      'This username or email is already in use',
                    ),
                  }
              },
            );
      },
    );
  }
}
