import 'dart:async';
import 'dart:convert';

import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class WebSocketService {
  late StompClient _stompClient;
  String _message = "";

  Future<void> initStompClient(String channel) async {
    stompClient = await StompClient(
      config: StompConfig.SockJS(
        url: 'https://shed-backend.herokuapp.com/shed',
        onConnect: (_) {
          _onConnect(_, channel);
        },
        onDisconnect: _onDisconnect,
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

    _activate();
  }

  void _activate() {
    stompClient.activate();
  }

  void _onConnect(StompFrame frame, String channel) {
    stompClient.subscribe(
      destination: '/topic/${channel}',
      callback: (frame) {
        print("receiving message...");
        var result = json.decode(frame.body!);
        message = result['message'];
        print(result);
      },
    );
    print("connected to " + stompClient.config.url.toString());
  }

  void _onDisconnect(StompFrame frame) {
    print("Disconnected");
  }

  void sendMessage(channel, String message) {
    if (!stompClient.connected) return;
    stompClient.send(
      destination: '/topic/${channel}',
      body: json.encode({
        'message': message
      }), // TODO: It's going to be a JSON containing all the data
    );
    print("Sending message: ${message}");
  }

  void deactivate() {
    stompClient.deactivate();
  }

  StompClient get stompClient => _stompClient;

  String get message => _message;

  set message(String value) {
    _message = value;
  }

  set stompClient(StompClient value) {
    _stompClient = value;
  }
}
