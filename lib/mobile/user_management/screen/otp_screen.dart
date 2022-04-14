import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:websocket_mobile/mobile/user_management/model/otp_request_type.dart';
import 'package:websocket_mobile/mobile/user_management/service/otp_service.dart';
import 'package:websocket_mobile/mobile/user_management/service/user_service.dart';
import 'package:websocket_mobile/mobile/user_management/service/validation_service.dart';
import 'package:websocket_mobile/mobile/user_management/widget/custom_text_input.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({
    required this.email,
    required this.password,
    required this.requestType,
    this.username,
    Key? key,
  }) : super(key: key);
  final String? username;
  final String password;
  final String email;
  final OtpRequestType requestType;

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
                  if (widget.requestType == OtpRequestType.register) {
                    OtpService.register(
                      username: widget.username!,
                      password: widget.password,
                      email: widget.email,
                      otpController: otpController,
                      context: context,
                    );
                  } else if (widget.requestType == OtpRequestType.forgotPass) {
                    OtpService.changePassword(
                      email: widget.email,
                      otp: int.parse(otpController.text.trim()),
                      password: widget.password,
                      context: context,
                    );
                  }
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
