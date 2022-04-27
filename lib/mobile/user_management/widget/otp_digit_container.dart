import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:websocket_mobile/mobile/common/error_handling/error_message_popup.dart';

import 'package:websocket_mobile/mobile/user_management/model/otp_request_type.dart';
import 'package:websocket_mobile/mobile/user_management/service/otp_service.dart';

class OtpDigitContainer extends StatefulWidget {
  const OtpDigitContainer({
    required this.otpController,
    required this.email,
    required this.password,
    required this.requestType,
    this.username,
    Key? key,
  }) : super(key: key);
  final TextEditingController otpController;
  final String? username;
  final String email;
  final String password;
  final OtpRequestType requestType;

  @override
  State<OtpDigitContainer> createState() => _OtpDigitContainerState();
}

class _OtpDigitContainerState extends State<OtpDigitContainer> {
  bool isSuccessful = true;

  @override
  Widget build(BuildContext context) {
    return Pinput(
      length: 6,
      controller: widget.otpController,
      defaultPinTheme: PinTheme(
        width: MediaQuery.of(context).size.width * 0.12,
        height: MediaQuery.of(context).size.width * 0.12,
        textStyle: const TextStyle(
          fontSize: 30,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2.5,
            color: const Color.fromRGBO(30, 60, 87, 1),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onChanged: (value) {
        if (value.length == 6) {
          if (widget.requestType == OtpRequestType.register) {
            OtpService.register(
              username: widget.username!,
              password: widget.password,
              email: widget.email,
              otpController: widget.otpController,
              context: context,
            ).then(
              (value) => {
                isSuccessful = value,
              },
            );
          } else if (widget.requestType == OtpRequestType.forgotPass) {
            OtpService.changePassword(
              email: widget.email,
              otp: int.parse(widget.otpController.text.trim()),
              password: widget.password,
              context: context,
            ).then(
                  (value) => {
                isSuccessful = value,
              },
            );
          }
          if (!isSuccessful) {
            errorMessagePopup(
              context,
              'Wrong one time password, or the email that you have entered is invalid',
            );
          }
        }
      },
    );
  }
}
