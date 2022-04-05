import 'dart:async';
import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:websocket_mobile/mobile/lobby/model/connection_model.dart';

class WebSocketService {
  late StompClient stompClient;
  final webSocketStream = BehaviorSubject<WebSocketEvent>();

  Future<void> initStompClient(String channel) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String jwtToken = prefs.getString('jwtToken')!;
    final String username = prefs.getString('username')!;

    stompClient = StompClient(
      config: StompConfig.SockJS(
        url: 'https://shed-backend.herokuapp.com/shed',
        onConnect: (_) {
          _onConnect(_, channel);
          webSocketStream.add(WebSocketEvent('connect', username));
          joinGame(channel, username);
        },
        onDisconnect: (frame) {
          //leaveGame(channel, username); // here we are already disconnected
          _onDisconnect(frame);
        },
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

  Future<void> initStompClientOnWeb(String channel) async {
    stompClient = StompClient(
      config: StompConfig.SockJS(
        url: 'https://shed-backend.herokuapp.com/shed',
        onConnect: (frame) {
          _onConnect(frame, channel);
        },
        onDisconnect: (frame) {
          _onDisconnect(frame);
        },
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

  Stream<WebSocketEvent> getWebSocketStream() {
    return webSocketStream;
  }

  void _onConnect(StompFrame frame, String channel) {
    stompClient.subscribe(
      destination: '/topic/$channel',
      callback: (StompFrame frame) {
        print('receiving message...');
        final dynamic result = json.decode(frame.body!);
        final String type = result['type'].toString();
        final String message = result['message'].toString();
        print('type: $type');
        webSocketStream.add(WebSocketEvent(type, message));
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

  void joinGame(channel, username) {
    if (!stompClient.connected) return;

    stompClient.send(
      destination: '/app/join-game/$channel/$username',
    );
    print('Join game signal sent...');
  }

  Future<void> leaveGame() async {
    if (!stompClient.connected) return;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String username = prefs.getString('username')!;
    final String gameName = prefs.getString('gameName')!;

    stompClient.send(
      destination: '/app/leave-game/$gameName/$username',
    );
    print('Leave game signal sent...');
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
