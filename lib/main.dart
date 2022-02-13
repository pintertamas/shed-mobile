import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:websocket_mobile/model/color_message.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final WebSocketChannel channel = IOWebSocketChannel.connect(
      "wss://demo.piesocket.com/v3/channel_1?api_key=oCdCMcMPQpbvNjUIzqtvF1d2X2okWpDQj4AwARJuAgtjhzKxVEjQU6IdCjwm&notify_self");
  Color bgColor = Colors.white;

  @override
  void initState() {
    channel.stream.listen((message) {
      print("message: " + message.toString());

      try {
        Map<String, dynamic> decoded = jsonDecode("""$message""");
        print("Decoded: $decoded");

        if (decoded.keys.contains('info')) return;

        ColorMessage randomColor = ColorMessage.fromJson(decoded);
        bgColor = Color.fromRGBO(
          randomColor.red,
          randomColor.green,
          randomColor.blue,
          1,
        );
      } catch (e) {
        print("Error: $e");
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor:
            Color.fromRGBO(bgColor.red, bgColor.green, bgColor.blue, 1),
        body: Center(
          child: TextButton(
            onPressed: _sendMessage,
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.greenAccent),
            ),
            child: Text(
              "Hello",
              textDirection: TextDirection.ltr,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _sendMessage() {
    Random random = Random();
    ColorMessage cm = ColorMessage(
      red: random.nextInt(255),
      green: random.nextInt(255),
      blue: random.nextInt(255),
    );
    channel.sink.add(jsonEncode(cm.toJson()));
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}
