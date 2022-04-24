import 'package:flutter/material.dart';
import 'package:websocket_mobile/mobile/common/stream/connected_player_stream_builder.dart';
import 'package:websocket_mobile/mobile/lobby/service/websocket_service.dart';

class ConnectedPlayersWidget extends StatefulWidget {
  const ConnectedPlayersWidget({
    required this.websocketService,
    Key? key,
  }) : super(key: key);
  final WebSocketService websocketService;

  @override
  State<ConnectedPlayersWidget> createState() => _ConnectedPlayersWidgetState();
}

class _ConnectedPlayersWidgetState extends State<ConnectedPlayersWidget> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.05),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.1,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.025,
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 4,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset.fromDirection(
                            1.5,
                            5,
                          ),
                          color: const Color.fromRGBO(57, 131, 60, 1.0),
                        ),
                      ],
                    ),
                    child: const Text(
                      'Browse games',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  width: MediaQuery.of(context).size.width / 4,
                  height: MediaQuery.of(context).size.height * 0.8,
                  color: Colors.green,
                  child: ConnectedPlayerStreamBuilder(
                    webSocketService: widget.websocketService,
                    connectedUsers: [],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
