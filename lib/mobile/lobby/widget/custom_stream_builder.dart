import 'package:flutter/material.dart';

Widget customStreamBuilder(Stream customStream) => StreamBuilder<dynamic>(
      stream: customStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        List<Widget> children;
        if (snapshot.hasError) {
          children = <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Error: ${snapshot.error}'),
            ),
          ];
        } else {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              children = const <Widget>[
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Awaiting bids...'),
                )
              ];
              break;
            case ConnectionState.active:
              children = <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('\$${snapshot.data}'),
                )
              ];
              break;
            case ConnectionState.done:
              children = <Widget>[
                const Icon(
                  Icons.info,
                  color: Colors.blue,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('\$${snapshot.data} (closed)'),
                )
              ];
              break;
          }
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        );
      },
    );
