import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:websocket_mobile/mobile/user_management/widget/custom_button.dart';
import 'package:websocket_mobile/web/create_game/model/card_rule.dart';
import 'package:websocket_mobile/web/create_game/model/create_game_provider.dart';
import 'package:websocket_mobile/web/create_game/model/qr_screen_arguments.dart';
import 'package:websocket_mobile/web/create_game/screen/qr_screen.dart';
import 'package:websocket_mobile/web/create_game/service/game_service.dart';
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

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CreateGameProvider>(context);
    final width =
        MediaQuery.of(context).size.width * 3 / 5 - widget.paddingSize * 2;

    return Padding(
      padding: EdgeInsets.all(widget.paddingSize / 2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: widget.paddingSize / 2),
            child: Container(
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.green.shade50,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
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
                            animationDuration:
                                const Duration(milliseconds: 100),
                            onChanged: (bool value) {
                              provider.isVisible = !value;
                              print(provider.isVisible);
                            },
                            onTap: () {},
                            onSwipe: () {},
                            onDoubleTap: () {},
                          ),
                        ),
                      ],
                    ),
                    Column(
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
                            animationDuration:
                                const Duration(milliseconds: 100),
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
                            animationDuration:
                                const Duration(milliseconds: 100),
                            onChanged: (bool value) {
                              provider.jokers = !value;
                              print(provider.jokers);
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
                      ],
                    )
                  ],
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
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
                onPressed: () async {
                  final List<CardRule> cardRules = [];
                  for (int i = 0; i < provider.rules.length; i++) {
                    cardRules.add(
                      CardRule(i + 1, provider.rules[i]),
                    );
                  }
                  gameService
                      .createGame(
                        visibility: provider.isVisible,
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
                              Navigator.pushNamed(
                                context,
                                QRScreen.routeName,
                                arguments: QRScreenArguments(gameName),
                              ),
                            },
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
