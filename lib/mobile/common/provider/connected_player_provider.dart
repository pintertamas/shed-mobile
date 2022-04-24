import 'package:flutter/cupertino.dart';

class ConnectedPlayerProvider extends ChangeNotifier {
  static final List<String> _connectedUsers = [];

  List<String> get connectedUsers => _connectedUsers;
}
