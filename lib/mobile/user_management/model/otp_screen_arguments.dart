import 'package:websocket_mobile/mobile/user_management/model/otp_request_type.dart';

class OtpScreenArguments {
  OtpScreenArguments({
    required this.text,
    required this.email,
    required this.requestType,
    required this.password,
    this.username,
  });

  final String text;
  final String? username;
  final String password;
  final String email;
  final OtpRequestType requestType;
}
