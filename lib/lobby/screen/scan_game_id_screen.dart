import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:websocket_mobile/lobby/model/ScreenArguments.dart';
import 'package:websocket_mobile/lobby/screen/join_lobby_screen.dart';

class ScanGameIdScreen extends StatefulWidget {
  const ScanGameIdScreen({Key? key}) : super(key: key);

  static const routeName = '/scan-game-id';

  @override
  State<ScanGameIdScreen> createState() => _ScanGameIdScreenState();
}

class _ScanGameIdScreenState extends State<ScanGameIdScreen> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? barcode;
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();

    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          body: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              _buildQrView(context),
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.05,
                child: buildResult(),
              ),
            ],
          ),
        ),
      );

  Widget buildResult() => Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white24, borderRadius: BorderRadius.circular(10)),
        child: Text(
          barcode != null
              ? 'Game ID: ${barcode!.code}'
              : 'Scan the code to join a game!',
          maxLines: 3,
        ),
      );

  Widget _buildQrView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          cutOutSize: MediaQuery.of(context).size.width * 0.8,
          borderWidth: 30,
          borderLength: 50,
          borderRadius: 10,
          borderColor: Colors.lightBlue, // TODO: Make a theme for the project!
        ),
      );

  void onQRViewCreated(QRViewController controller) {
    setState(() => this.controller = controller);

    controller.scannedDataStream.listen((barcode) {
      this.barcode = barcode;
      Navigator.pushNamed(context, JoinLobbyScreen.routeName,
          arguments: ScreenArguments(barcode.code!));
    });
  }
}
