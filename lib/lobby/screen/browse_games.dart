import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../widget/custom_stream_builder.dart';

class BrowseGamesScreen extends StatefulWidget {
  const BrowseGamesScreen({Key? key}) : super(key: key);

  static const routeName = '/browse';

  @override
  State<BrowseGamesScreen> createState() => _BrowseGamesScreenState();
}

class _BrowseGamesScreenState extends State<BrowseGamesScreen> {
  final Stream<int> _placeholderStream = (() {
    late final StreamController<int> controller;
    controller = StreamController<int>(
      onListen: () async {
        await Future<void>.delayed(const Duration(seconds: 1));
        controller.add(1);
        await Future<void>.delayed(const Duration(seconds: 1));
        await controller.close();
      },
    );
    return controller.stream;
  })();

  Stream<double> getRandomValues() async* {
    var random = Random(2);
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      yield random.nextDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Text("Browse games"),
            Center(child: CustomStreamBuilder(getRandomValues())),
          ],
        ),
      ),
    );
  }
}
