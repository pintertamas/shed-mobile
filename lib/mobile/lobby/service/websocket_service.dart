import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class WebSocketService {
  late StompClient stompClient;

  Future<void> initStompClient(String channel) async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    final String jwtToken = prefs.getString('jwtToken')!;

    stompClient = StompClient(
      config: StompConfig.SockJS(
        url: 'https://shed-backend.herokuapp.com/shed',
        onConnect: (_) {
          _onConnect(_, channel);
        },
        onDisconnect: _onDisconnect,
        onStompError: (StompFrame error) {
          print('stompError: $error');
        },
        onUnhandledMessage: (StompFrame error) {
          print('unhandledError: $error');
        },
        beforeConnect: () async {
          print('waiting to connect...');
          await Future.delayed(const Duration(milliseconds: 200));
          print('connecting...');
        },
        onWebSocketError: (dynamic error) => print(error.toString()),
        stompConnectHeaders: {'Authorization': 'Bearer $jwtToken'},
        webSocketConnectHeaders: {'Authorization': 'Bearer $jwtToken'},
      ),
    );

    _activate();
  }

  Future<void> initStompClientOnWeb() async {
    stompClient = StompClient(
      config: StompConfig.SockJS(
        url: 'https://shed-backend.herokuapp.com/shed',
        onDisconnect: _onDisconnect,
        onStompError: (StompFrame error) {
          print('stompError: $error');
        },
        onUnhandledMessage: (StompFrame error) {
          print('unhandledError: $error');
        },
        beforeConnect: () async {
          print('waiting to connect...');
          await Future.delayed(const Duration(milliseconds: 200));
          print('connecting...');
        },
        onWebSocketError: (dynamic error) => print(error.toString()),
      ),
    );

    _activate();
  }

  Stream<bool> checkConnection() async* {
    while (true) {
      await Future.delayed(const Duration(milliseconds: 100));
      yield stompClient.connected;
    }
  }

  void _activate() {
    stompClient.activate();
  }

  void _onConnect(StompFrame frame, String channel) {
    stompClient.subscribe(
      destination: '/topic/$channel',
      callback: (StompFrame frame) {
        print('receiving message...');
        final dynamic result = json.decode(frame.body!);
        final String message = result['message'].toString();
        final String gameName = result['gameName'].toString();
        print(message);
        print(gameName);
      },
    );
    print('connected to ${stompClient.config.url}');
  }

  void _onDisconnect(StompFrame frame) {
    print('Disconnected');
  }

  void sendMessage(channel, String message) {
    if (!stompClient.connected) return;
    stompClient.send(
      destination: '/topic/$channel',
      body: json.encode({
        'message': message
      }), // TODO: It's going to be a JSON containing all the data
    );
    print('Sending message: $message');
  }

  void startGame(channel) {
    if (!stompClient.connected) return;
    stompClient.send(
      destination: '/app/start-game/$channel',
    );
    print('Start game signal sent...');
  }

  void deactivate() {
    stompClient.deactivate();
  }
}
