import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:websocket_mobile/common/error_handling/error_message_popup.dart';
import 'package:websocket_mobile/mobile/user_management/model/otp_request_type.dart';
import 'package:websocket_mobile/mobile/user_management/service/otp_service.dart';
import 'package:websocket_mobile/mobile/user_management/service/user_service.dart';
import 'package:websocket_mobile/mobile/user_management/widget/custom_button.dart';

import 'package:websocket_mobile/mobile/user_management/widget/otp_digit_container.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({
    required this.text,
    required this.email,
    required this.password,
    required this.requestType,
    this.username,
    Key? key,
  }) : super(key: key);
  final String text;
  final String? username;
  final String password;
  final String email;
  final OtpRequestType requestType;

  static const routeName = '/otp';

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpController = TextEditingController();
  UserService userService = UserService();
  OtpService otpService = OtpService();
  late DateTime lastTimeSinceResend;
  late int secondsUntilNextRefresh;
  Timer? _timer;

  @override
  void initState() {
    lastTimeSinceResend = DateTime.now();
    secondsUntilNextRefresh = 0;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) => setState(
        () {},
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    if (_timer!.isActive) {
      _timer?.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    secondsUntilNextRefresh =
        60 - DateTime.now().difference(lastTimeSinceResend).inSeconds;

    return Scaffold(
      backgroundColor: Colors.brown,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.width * 0.4,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: EdgeInsets.all(
                    MediaQuery.of(context).size.width * 0.1,
                  ),
                  child: const FittedBox(
                    child: Center(
                      child: Icon(
                        FontAwesomeIcons.unlockAlt,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text:
                          'You are almost there!\nType here the one time password sent to ',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: widget.email,
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' to ${widget.text}',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              OtpDigitContainer(
                otpController: otpController,
                username: widget.username,
                email: widget.email,
                password: widget.password,
                requestType: widget.requestType,
              ),
              Padding(
                padding: const EdgeInsets.all(
                  20.0,
                ),
                child: Center(
                  child: Column(
                    children: [
                      CustomButton(
                        text: (secondsUntilNextRefresh > 0)
                            ? '$secondsUntilNextRefresh'
                            : 'Resend code',
                        enabled: !(secondsUntilNextRefresh > 0),
                        width: MediaQuery.of(context).size.width * 0.3,
                        onPressed: () {
                          if (DateTime.now()
                                  .difference(lastTimeSinceResend)
                                  .inSeconds >
                              60) {
                            lastTimeSinceResend = DateTime.now();
                            otpService.generateOtp(widget.email).then(
                                  (value) => {
                                    if (!value)
                                      {
                                        errorMessagePopup(
                                          context,
                                          'Something went wrong.\n'
                                          'We could not send a new one time password to the given email address.\n'
                                          'Please check if you entered your address correctly!',
                                        ),
                                      }
                                  },
                                );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
