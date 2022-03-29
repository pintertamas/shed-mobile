import 'package:animated_button/animated_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget browseGamesWidget(double paddingSize) => Padding(
      padding: EdgeInsets.all(paddingSize / 2),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              bottom: paddingSize / 2,
            ),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Browse games',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: paddingSize / 2,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: ListView.builder(
                  itemCount: 50,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: index.isOdd
                            ? Colors.green.shade50
                            : Colors.green.shade100,
                      ),
                      child: ListTile(
                        selectedColor: Colors.red,
                        hoverColor: Colors.grey,
                        iconColor: Colors.green,
                        leading: const Icon(FontAwesomeIcons.gamepad),
                        trailing: AnimatedButton(
                          width: MediaQuery.of(context).size.width * 0.1,
                          height: MediaQuery.of(context).size.width * 0.025,
                          color: Colors.green,
                          onPressed: () {},
                          child: const Text(
                            'Join',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        title: Text(
                          'Game name $index',
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
