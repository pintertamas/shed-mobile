import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:websocket_mobile/screens/my_app.dart';

import 'my_http_override.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}