import 'package:flutter/material.dart';
import 'package:websocket_mobile/mobile/user_management/model/otp_request_type.dart';
import 'package:websocket_mobile/mobile/user_management/model/otp_screen_arguments.dart';
import 'package:websocket_mobile/mobile/user_management/screen/otp_screen.dart';
import 'package:websocket_mobile/mobile/user_management/service/otp_service.dart';
import 'package:websocket_mobile/mobile/user_management/service/validation_service.dart';
import 'package:websocket_mobile/mobile/user_management/widget/custom_text_input.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  static const routeName = '/forgot-password';

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  OtpService otpService = OtpService();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              CustomTextInput(
                hint: 'email',
                controller: emailController,
                validator: ValidationService.none(),
              ),
              CustomTextInput(
                hint: 'New password',
                controller: passwordController,
                validator: ValidationService.none(),
              ),
              CustomTextInput(
                hint: 'Confirm password',
                controller: passwordController,
                validator: ValidationService.none(),
              ),
              ElevatedButton(
                onPressed: () {
                  otpService
                      .generateOtp(
                        emailController.text,
                      )
                      .then(
                        (value) => {
                          Navigator.pushNamed(
                            context,
                            OtpScreen.routeName,
                            arguments: OtpScreenArguments(
                              email: emailController.text,
                              password: passwordController.text,
                              requestType: OtpRequestType.forgotPass,
                            ),
                          ),
                        },
                      );
                },
                child: const Text(
                  'forgot pass',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
