import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:websocket_mobile/mobile/user_management/screen/login_screen.dart';
import 'package:websocket_mobile/mobile/user_management/screen/sign_up_screen.dart';
import 'package:websocket_mobile/mobile/user_management/widget/custom_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  static const routeName = '/welcome-screen';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  TextEditingController gameIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double _settingsIconGap = MediaQuery.of(context).size.height * 0.015;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.brown,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: _settingsIconGap,
              right: _settingsIconGap,
              child: IconButton(
                icon: const Icon(
                  FontAwesomeIcons.bars,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.height * 0.1,
                      ),
                      child: const Image(
                        image: AssetImage(
                          'assets/playing-cards.png',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.2,
                    ),
                    child: Column(
                      children: [
                        CustomButton(
                          onPressed: () {
                            Navigator.pushNamed(context, LoginScreen.routeName);
                          },
                          text: 'Login',
                        ),
                        CustomButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, SignUpScreen.routeName);
                          },
                          text: 'Sign up',
                        ),
                      ],
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
