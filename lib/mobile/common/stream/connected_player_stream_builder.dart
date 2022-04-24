import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:websocket_mobile/mobile/lobby/model/connection_model.dart';
import 'package:websocket_mobile/mobile/lobby/service/websocket_service.dart';

class ConnectedPlayerStreamBuilder extends StatefulWidget {
  const ConnectedPlayerStreamBuilder({
    required this.webSocketService,
    required this.connectedUsers,
    Key? key,
  }) : super(key: key);
  final WebSocketService webSocketService;
  final List<String> connectedUsers;

  @override
  State<ConnectedPlayerStreamBuilder> createState() =>
      _ConnectedPlayerStreamBuilderState();
}

class _ConnectedPlayerStreamBuilderState
    extends State<ConnectedPlayerStreamBuilder> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<WebSocketEvent>(
      stream: widget.webSocketService.webSocketStream,
      builder: (
        BuildContext context,
        AsyncSnapshot<WebSocketEvent> snapshot,
      ) {
        if (snapshot.hasData && snapshot.data != null) {
          if (snapshot.data!.type == 'join') {
            final String connectedUser = snapshot.data!.message;
            if (!widget.connectedUsers.contains(connectedUser)) {
              widget.connectedUsers.add(connectedUser);
            }
          } else if (snapshot.data!.type == 'leave') {
            final String leavingUser = snapshot.data!.message;
            if (widget.connectedUsers.contains(leavingUser)) {
              widget.connectedUsers.remove(leavingUser);
            }
          }
        }
        if (widget.connectedUsers.isEmpty) {
          return const Center(
            child: Text(
              'No players joined yet!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else {
          return ListView.builder(
            itemCount: widget.connectedUsers.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      hoverColor: Colors.grey,
                      iconColor: const Color.fromRGBO(
                        29,
                        78,
                        210,
                        1.0,
                      ),
                      leading: const Icon(
                        FontAwesomeIcons.userAlt,
                      ),
                      title: Text(
                        widget.connectedUsers[index],
                        style: const TextStyle(
                          color: Color.fromRGBO(
                            29,
                            78,
                            210,
                            1.0,
                          ),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
