import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:websocket_mobile/common/error_handling/error_message_popup.dart';
import 'package:websocket_mobile/common/service/game_service.dart';
import 'package:websocket_mobile/mobile/lobby/model/lobby_screen_arguments.dart';
import 'package:websocket_mobile/mobile/lobby/screen/lobby_screen.dart';

class ScanGameIdScreen extends StatefulWidget {
  const ScanGameIdScreen({Key? key}) : super(key: key);

  static const routeName = '/scan-game-id';

  @override
  State<ScanGameIdScreen> createState() => _ScanGameIdScreenState();
}

class _ScanGameIdScreenState extends State<ScanGameIdScreen> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool gameFoundAlready = false;
  late GameService gameService;

  @override
  void initState() {
    gameService = GameService();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          backgroundColor: Colors.brown,
          body: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              _buildQrView(context),
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.05,
                child: _buildResult(),
              ),
            ],
          ),
        ),
      );

  Widget _buildResult() => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Text(
          'Scan the code to join a game!',
          maxLines: 3,
        ),
      );

  Widget _buildQrView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
          cutOutSize: MediaQuery.of(context).size.width * 0.8,
          borderWidth: 30,
          borderLength: 50,
          borderRadius: 10,
          borderColor: Colors.green,
        ),
      );

  void _onQRViewCreated(QRViewController controller) {
    setState(() => this.controller = controller);

    controller.scannedDataStream.listen(
      (qrcode) async {
        if (gameFoundAlready) return;
        gameFoundAlready = true;
        bool gameExists = true;
        print(
          'checking existence of: ${qrcode.code}',
        );
        if (qrcode.code == null) return;
        gameService.saveGameName(qrcode.code!);
        await gameService
            .isGameExist(qrcode.code!)
            .then(
              (value) => {
                print('gameExists: $value'),
                if (!value)
                  {
                    errorMessagePopup(
                      context,
                      'Game not found with this name\n${qrcode.code}',
                    ),
                    gameExists = false,
                  }
              },
            )
            .then(
              (value) => {
                if (gameExists)
                  {
                    Navigator.pushReplacementNamed(
                      context,
                      LobbyScreen.routeName,
                      arguments: LobbyScreenArguments(
                        gameId: qrcode.code!,
                      ),
                    ),
                  },
              },
            );
      },
    );
  }
}
