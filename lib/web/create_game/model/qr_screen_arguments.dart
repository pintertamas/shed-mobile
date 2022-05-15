import 'package:websocket_mobile/mobile/lobby/service/websocket_service.dart';

class QRScreenArguments {
  QRScreenArguments({required this.gameName, this.webSocketService});

  final String gameName;
  final WebSocketService? webSocketService;
}
