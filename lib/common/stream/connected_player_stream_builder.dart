import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:websocket_mobile/mobile/lobby/model/websocket_event.dart';
import 'package:websocket_mobile/mobile/lobby/service/websocket_service.dart';

class ConnectedPlayerStreamBuilder extends StatefulWidget {
  const ConnectedPlayerStreamBuilder({
    required this.webSocketService,
    this.connectedUsers,
    Key? key,
  }) : super(key: key);
  final WebSocketService webSocketService;
  final List<String>? connectedUsers;

  @override
  State<ConnectedPlayerStreamBuilder> createState() =>
      _ConnectedPlayerStreamBuilderState();
}

class _ConnectedPlayerStreamBuilderState
    extends State<ConnectedPlayerStreamBuilder> {
  late final List<String> connectedUsers;

  @override
  void initState() {
    connectedUsers = widget.connectedUsers ?? [];
    super.initState();
  }

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
            final String connectedUser = snapshot.data!.message!;
            if (!connectedUsers.contains(connectedUser)) {
              connectedUsers.add(connectedUser);
            }
          } else if (snapshot.data!.type == 'leave') {
            final String leavingUser = snapshot.data!.message!;
            if (connectedUsers.contains(leavingUser)) {
              connectedUsers.remove(leavingUser);
            }
          }
        }
        if (connectedUsers.isEmpty) {
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
            itemCount: connectedUsers.length,
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
                        connectedUsers[index],
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
