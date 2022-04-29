import 'package:websocket_mobile/mobile/lobby/service/websocket_service.dart';

class LobbyScreenArguments {
  LobbyScreenArguments({required this.gameId, this.webSocketService});

  final String gameId;
  final WebSocketService? webSocketService;
}
