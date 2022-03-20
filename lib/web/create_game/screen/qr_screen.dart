import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRScreen extends StatefulWidget {
  const QRScreen({required this.name, Key? key}) : super(key: key);
  final String name;

  static const routeName = '/qr';

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  bool errorLoading = false;

  @override
  Widget build(BuildContext context) {
    final double qrHeight = MediaQuery.of(context).size.height * 0.5;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImage(
              data: widget.name,
              version: QrVersions.auto,
              size: qrHeight,
              errorStateBuilder: (cxt, err) {
                print(err.toString());
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Icon(
                        FontAwesomeIcons.exclamationCircle,
                        color: Colors.red,
                        size: qrHeight / 4,
                      ),
                    ),
                    Text(
                      'Uh oh! Something went wrong... Try again in a few minutes!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: qrHeight / 25,
                        color: Colors.red,
                      ),
                    ),
                  ],
                );
              },
            ),
            const Text('To manually join a game, type the following:'),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                widget.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
