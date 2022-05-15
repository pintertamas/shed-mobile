import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:websocket_mobile/common/service/game_service.dart';
import 'package:websocket_mobile/mobile/user_management/widget/custom_button.dart';
import 'package:websocket_mobile/web/create_game/model/card_rule.dart';
import 'package:websocket_mobile/web/create_game/model/create_game_provider.dart';
import 'package:websocket_mobile/web/create_game/model/qr_screen_arguments.dart';
import 'package:websocket_mobile/web/create_game/screen/qr_screen.dart';
import 'package:websocket_mobile/web/create_game/widget/rule_selection_widget.dart';

class GameConfigWidget extends StatefulWidget {
  const GameConfigWidget({required this.paddingSize, Key? key})
      : super(key: key);
  final double paddingSize;

  @override
  State<GameConfigWidget> createState() => _GameConfigWidgetState();
}

class _GameConfigWidgetState extends State<GameConfigWidget> {
  GameService gameService = GameService();
  double _currentSliderValue = 3;
  late bool enabled;

  @override
  void initState() {
    enabled = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CreateGameProvider>(context);
    final width =
        MediaQuery.of(context).size.width * 3 / 5 - widget.paddingSize * 2;

    final List<Widget> settingWidgets = [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Visible to anyone',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SlidingSwitch(
              value: !provider.isVisible,
              width: width / 6,
              textOff: 'yes',
              textOn: 'no',
              colorOff: Colors.white,
              colorOn: Colors.white,
              buttonColor: Colors.brown,
              inactiveColor: Colors.white,
              background: Colors.green,
              animationDuration: const Duration(milliseconds: 100),
              onChanged: (bool value) {
                provider.isVisible = !value;
              },
              onTap: () {},
              onSwipe: () {},
              onDoubleTap: () {},
            ),
          ),
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Number of decks',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SlidingSwitch(
              value: provider.numberOfDecks == 2,
              width: width / 6,
              textOff: '1',
              textOn: '2',
              colorOff: Colors.white,
              colorOn: Colors.white,
              buttonColor: Colors.brown,
              inactiveColor: Colors.white,
              background: Colors.green,
              animationDuration: const Duration(milliseconds: 100),
              onChanged: (bool value) {
                if (value) {
                  provider.numberOfDecks = 2;
                } else {
                  provider.numberOfDecks = 1;
                }
              },
              onTap: () {},
              onSwipe: () {},
              onDoubleTap: () {},
            ),
          ),
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Play with jokers',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SlidingSwitch(
              value: !provider.jokers,
              width: width / 6,
              textOff: 'yes',
              textOn: 'no',
              colorOff: Colors.white,
              colorOn: Colors.white,
              buttonColor: Colors.brown,
              inactiveColor: Colors.white,
              background: Colors.green,
              animationDuration: const Duration(milliseconds: 100),
              onChanged: (bool value) {
                provider.jokers = !value;
                setState(() {});
              },
              onTap: () {},
              onSwipe: () {},
              onDoubleTap: () {},
            ),
          ),
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Number of cards per hand',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              provider.numberOfCardsInHand.toString(),
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(
            width: width / 6,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: NeumorphicSlider(
                value: _currentSliderValue.round().roundToDouble(),
                min: 3,
                max: 5,
                style: const SliderStyle(
                  accent: Colors.brown,
                  variant: Colors.green,
                ),
                onChanged: (double value) {
                  setState(() {
                    _currentSliderValue = value;
                    provider.numberOfCardsInHand = value.round();
                  });
                },
              ),
            ),
          ),
        ],
      )
    ];

    return Padding(
      padding: EdgeInsets.all(widget.paddingSize / 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: width > 1000 ? width / 7 : width / 3,
            child: Padding(
              padding: EdgeInsets.only(bottom: widget.paddingSize / 2),
              child: Container(
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.green.shade50,
                ),
                child: GridView.builder(
                  controller: ScrollController(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: width > 1000
                        ? 4
                        : width > 800
                            ? 3
                            : width > 650
                                ? 2
                                : 1,
                    childAspectRatio: 2,
                  ),
                  itemCount: 4,
                  itemBuilder: (BuildContext context, int i) {
                    return settingWidgets[i];
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: widget.paddingSize / 2),
              child: Container(
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.green.shade50,
                ),
                child: GridView.builder(
                  controller: ScrollController(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: width > 1000
                        ? 3
                        : width > 600
                            ? 2
                            : 1,
                    childAspectRatio: 3,
                  ),
                  itemCount: provider.jokers ? 14 : 13,
                  itemBuilder: (BuildContext context, int i) {
                    return RuleSelectionWidget(
                      paddingSize: widget.paddingSize,
                      index: i,
                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: widget.paddingSize / 2),
            child: Center(
              child: CustomButton(
                enabled: enabled,
                onPressed: () async {
                  if (!enabled) return;
                  setState(() {
                    enabled = false;
                  });
                  final List<CardRule> cardRules = [];
                  for (int i = 0; i < provider.rules.length; i++) {
                    cardRules.add(
                      CardRule(i + 2, provider.rules[i]),
                    );
                  }
                  gameService
                      .createGame(
                        visible: provider.isVisible,
                        numberOfDecks: provider.numberOfDecks,
                        numberOfCardsInHand: provider.numberOfCardsInHand,
                        joker: provider.jokers,
                        cardRules: cardRules,
                      )
                      .then(
                        (gameName) => {
                          print('gameName: $gameName'),
                          if (gameName != '' && gameName != 'error')
                            {
                              gameService.saveGameName(gameName),
                              Navigator.pushReplacementNamed(
                                context,
                                QRScreen.routeName,
                                arguments: QRScreenArguments(
                                  gameName: gameName,
                                ),
                              ),
                            }
                          else
                            {
                              enabled = true,
                              // TODO: setState?
                            }
                        },
                      )
                      .whenComplete(
                        () => {
                          setState(
                            () {
                              enabled = true;
                            },
                          ),
                        },
                      );
                },
                width: MediaQuery.of(context).size.width * 0.5,
                text: 'Create game',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
