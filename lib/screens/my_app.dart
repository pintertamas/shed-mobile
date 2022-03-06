import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StompClient stompClient;
  TextEditingController textEditingController = new TextEditingController();
  String message = "";

  @override
  void initState() {
    stompClient = StompClient(
      config: StompConfig.SockJS(
        url: 'https://192.168.0.34:8443/shed',
        onConnect: onConnect,
        onDisconnect: onDisconnect,
        onStompError: (error) {
          print("stompError: " + error.toString());
        },
        onUnhandledMessage: (error) {
          print("unhandledError: " + error.toString());
        },
        beforeConnect: () async {
          print('waiting to connect...');
          await Future.delayed(Duration(milliseconds: 200));
          print('connecting...');
        },
        onWebSocketError: (dynamic error) => print(error.toString()),
        stompConnectHeaders: {'Authorization': 'Bearer yourToken'},
        webSocketConnectHeaders: {'Authorization': 'Bearer yourToken'},
      ),
    );

    stompClient.activate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.deepPurple,
          body: Center(
            child: Column(
              children: [
                TextField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your message',
                  ),
                ),
                Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.white,
                  child: Text(message == "" ? "No new messages" : message),
                ),
                TextButton(
                  onPressed: _sendMessage,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  child: Text(
                    "Click",
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _sendMessage() {
    String message = textEditingController.text.toString();
    stompClient.send(
      destination: '/topic/asd',
      body: json.encode({'message': message}),
    );
    print("connected: " +
        stompClient.connected.toString() +
        " to " +
        stompClient.config.url.toString());
    print("sending message: " + message);
  }

  void onConnect(StompFrame frame) {
    String gameId = 'asd';
    stompClient.subscribe(
      destination: '/topic/' + gameId,
      callback: (frame) {
        print("receiving message...");
        var result = json.decode(frame.body!);
        message = result['message'];
        setState(() {});
        print(result);
      },
    );

    Timer.periodic(Duration(seconds: 1), (_) {
      stompClient.send(
        destination: 'topic/asd',
        body: json.encode({'a': 123}),
      );
    });
  }

  void onDisconnect(StompFrame frame) {
    print("Disconnecting...");
  }

  @override
  void dispose() {
    stompClient.deactivate();
    super.dispose();
  }
}
