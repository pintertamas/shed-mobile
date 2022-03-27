import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:websocket_mobile/mobile/user_management/screen/login_screen.dart';
import 'package:websocket_mobile/mobile/user_management/screen/sign_up_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  static const routeName = '/welcome-screen';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  TextEditingController gameIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double _settingsIconGap = MediaQuery.of(context).size.height * 0.015;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: _settingsIconGap,
              right: _settingsIconGap,
              child: IconButton(
                icon: const Icon(FontAwesomeIcons.bars),
                onPressed: () {},
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, LoginScreen.routeName);
                    },
                    child: const Text(
                      'Login',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, SignUpScreen.routeName);
                    },
                    child: const Text(
                      'Sign up',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
