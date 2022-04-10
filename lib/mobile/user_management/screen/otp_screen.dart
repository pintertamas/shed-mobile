import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:websocket_mobile/mobile/user_management/screen/home_screen.dart';
import 'package:websocket_mobile/mobile/user_management/service/user_service.dart';
import 'package:websocket_mobile/mobile/user_management/service/validation_service.dart';
import 'package:websocket_mobile/mobile/user_management/widget/custom_text_input.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({
    required this.username,
    required this.password,
    required this.email,
    Key? key,
  }) : super(key: key);
  final String username;
  final String password;
  final String email;

  static const routeName = '/otp';

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otpController = TextEditingController();
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
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextInput(
                hint: 'otp',
                keyboardType: TextInputType.number,
                controller: otpController,
                validator: ValidationService.validateOtp(otpController.text),
              ),
              ElevatedButton(
                onPressed: () async {
                  await userService
                      .register(
                        widget.username,
                        widget.password,
                        widget.email,
                        int.parse(otpController.text.trim()),
                      )
                      .then(
                        (response) async => {
                          await userService.login(
                            widget.username,
                            widget.password,
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
                child: const Text(
                  'validate',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
