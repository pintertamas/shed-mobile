import 'package:websocket_mobile/mobile/lobby/service/websocket_service.dart';

class GameScreenArguments {
  GameScreenArguments({required this.webSocketService, required this.gameId});

  final WebSocketService webSocketService;
  final String gameId;
}
