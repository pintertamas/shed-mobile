import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:platform_device_id/platform_device_id.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _deviceId;
  late StompClient stompClient;
  TextEditingController textEditingController = new TextEditingController();
  String message = "";

  Future<void> initPlatformState() async {
    String? deviceId;
    deviceId = await PlatformDeviceId.getDeviceId;

    if (!mounted) return;

    setState(() {
      _deviceId = deviceId;
      print("deviceId->$_deviceId");
    });
  }

  @override
  void initState() {
    initPlatformState();
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
            child: Container(
              height: 200,
              width: double.infinity,
              color: Colors.white,
              child: Center(
                child: Text(message == "" ? "No new messages" : message),
              ),
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
        destination: '/topic/asd',
        body: json.encode({
          'message': _deviceId.toString() +
              " says: " +
              Random.secure().nextInt(100).toString()
        }),
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
