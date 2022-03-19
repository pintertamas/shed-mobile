import 'package:flutter/material.dart';

Widget browseGamesWidget(double paddingSize) => Padding(
  padding: EdgeInsets.all(paddingSize / 2),
  child: Container(
    decoration: BoxDecoration(
      border: Border.all(
        color: Colors.black26,
      ),
    ),
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            paddingSize,
            paddingSize,
            paddingSize,
            paddingSize / 2,
          ),
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Colors.purple.shade300,
              ),
            ),
            child: const Text(
              'Browse games',
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              paddingSize,
              paddingSize / 2,
              paddingSize,
              paddingSize,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green.shade100,
              ),
              child: const Center(
                child: Text('the list of new games comes here'),
              ),
            ),
          ),
        ),
      ],
    ),
  ),
);