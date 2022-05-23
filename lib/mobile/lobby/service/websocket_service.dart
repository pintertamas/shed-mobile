import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:websocket_mobile/common/model/playing_card.dart';
import 'package:websocket_mobile/common/service/game_service.dart';
import 'package:websocket_mobile/mobile/game/model/action_request.dart';
import 'package:websocket_mobile/mobile/lobby/model/websocket_event.dart';
import 'package:websocket_mobile/mobile/user_management/service/user_service.dart';

class WebSocketService {
  late StompClient stompClient;
  final webSocketStream = BehaviorSubject<WebSocketEvent>();

  Future<void> initStompClient({String? channel}) async {
    final String _channel = channel ?? 'unknown';
    final String jwtToken = await UserService.getJwtToken();
    final String username = await UserService.getUsername();

    stompClient = StompClient(
      config: StompConfig.SockJS(
        url: 'https://shed-backend.herokuapp.com/shed',
        onConnect: (_) {
          _onConnect(_, _channel);
          if (kIsWeb) return;
          webSocketStream.add(
            WebSocketEvent(
              type: 'connect',
              username: username,
            ),
          );
          joinGame(_channel, username);
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
          print('waiting to connect to $_channel...');
          await Future.delayed(const Duration(milliseconds: 200));
          print('connecting...');
        },
        onWebSocketError: (dynamic error) => print('webSocketError: $error'),
        stompConnectHeaders:
            !kIsWeb ? {'Authorization': 'Bearer $jwtToken'} : null,
        webSocketConnectHeaders:
            !kIsWeb ? {'Authorization': 'Bearer $jwtToken'} : null,
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
        final String uuid = result['uuid'].toString();
        final String type = result['type'].toString();
        final String message = result['message'].toString();
        final List<PlayingCard> cards = (jsonDecode(result['cards'].toString())
        as List)
            .map((card) => PlayingCard.fromJson(card as Map<String, dynamic>))
            .toList();

        if (['connect', 'join', 'leave', 'game-start'].contains(type)) {
          print('type: $type');
          webSocketStream.add(
            WebSocketEvent(
              uuid: uuid,
              type: type,
              message: message,
            ),
          );
        } else if (['valid', 'invalid', 'draw'].contains(type)) {
          print('getting username...');
          print('message');
          final String username = result['username'].toString();

          print('type: $type');
          webSocketStream.add(
            WebSocketEvent(
              uuid: uuid,
              type: type,
              message: message,
              username: username,
              cards: cards,
            ),
          );
        }
      },
    );
    print('connected to ${stompClient.config.url}');
  }

  void _onDisconnect(StompFrame frame) {
    print('Disconnected');
  }

  void joinGame(channel, username) {
    if (!stompClient.connected) return;

    if (!kIsWeb) {
      stompClient.send(
        destination: '/app/join-game/$channel/$username',
      );
    }
    print('Join game signal sent...');
  }

  void drawCard(channel, username) {
    if (!stompClient.connected) return;

    if (!kIsWeb) {
      stompClient.send(
        destination: '/app/pick-a-card/$channel/$username',
      );
    }
    print('Join game signal sent...');
  }

  Future<void> leaveGame() async {
    if (!stompClient.connected) return;

    final String username = await UserService.getUsername();
    final String gameName = await GameService.getGameName();

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
    print('Start game signal sent to channel $channel...');
  }

  void sendAction(String channel, String username, List<PlayingCard> selectedCards) {
    if (!stompClient.connected) return;

    if (!kIsWeb) {
      print('sending played cards');
      stompClient.send(
        destination: '/app/throw-a-card/$channel/$username',
        body: jsonEncode(ActionRequest(username, selectedCards).toJson()),
      );
    }
    print(selectedCards.length);
    print('Cards were played...');
  }

  void deactivate() {
    stompClient.deactivate();
  }
}
