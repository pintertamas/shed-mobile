import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:websocket_mobile/web/create_game/model/create_game_provider.dart';

class RuleSelectionWidget extends StatefulWidget {
  const RuleSelectionWidget({
    required this.paddingSize,
    required this.index,
    Key? key,
  }) : super(key: key);
  final double paddingSize;
  final int index;

  @override
  State<RuleSelectionWidget> createState() => _RuleSelectionWidgetState();
}

class _RuleSelectionWidgetState extends State<RuleSelectionWidget> {
  String? selectedValue;
  late int randomSeed;

  String getRandomShape() {
    final List<String> shapes = [
      'clubs',
      'diamonds',
      'hearts',
      'spades',
    ];
    return shapes[Random(randomSeed).nextInt(shapes.length)];
  }

  @override
  void initState() {
    randomSeed = Random.secure().nextInt(100);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CreateGameProvider>(context);

    final double width =
        MediaQuery.of(context).size.width * 3 / 5 / 3 - widget.paddingSize * 3;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: width,
          color: Colors.green,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Image.asset(
                    'assets/cards/${getRandomShape()}${widget.index + 2}.png',
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      isExpanded: true,
                      selectedItemHighlightColor: Colors.green,
                      hint: Text(
                        provider.rules[widget.index],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      items: provider.items
                          .map(
                            (item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                      value: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value! as String;
                          provider.rules[widget.index] = value as String;
                        });
                      },
                      icon: const Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Colors.white,
                      ),
                      iconSize: 14,
                      iconEnabledColor: Colors.yellow,
                      iconDisabledColor: Colors.grey,
                      buttonWidth: MediaQuery.of(context).size.width * 2 / 5 / 3 -
                          widget.paddingSize * 4,
                      buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                      buttonDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.brown,
                        ),
                        color: Colors.brown,
                      ),
                      buttonElevation: 2,
                      itemHeight: 40,
                      itemPadding: const EdgeInsets.only(left: 14, right: 14),
                      dropdownMaxHeight: 200,
                      dropdownWidth: 200,
                      dropdownPadding: null,
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.brown,
                      ),
                      dropdownElevation: 8,
                      scrollbarRadius: const Radius.circular(40),
                      scrollbarThickness: 6,
                      scrollbarAlwaysShow: true,
                      offset: const Offset(-20, 0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
