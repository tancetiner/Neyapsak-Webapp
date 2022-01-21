// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Membership extends StatelessWidget {
  const Membership({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Row(
          children: <Widget>[
            Container(
              width: 90.0,
              child: const Text(
                "Membership",
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(
              width: 40.0,
            ),
            CircleAvatar(
              backgroundColor: Colors.blue[50],
              child: Icon(Icons.account_balance_wallet),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Container(
              width: 50.0,
              child: Text(
                "Classic",
                textAlign: TextAlign.left,
              ),
            ),
            CircleAvatar(
              backgroundColor: Colors.blue[50],
              child: Icon(Icons.account_balance_wallet),
            ),
            SizedBox(
              width: 10.0,
            ),
            Container(
              width: 50.0,
              child: Text(
                "Silver",
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            CircleAvatar(
              backgroundColor: Colors.blue[50],
              child: Icon(Icons.account_balance_wallet),
            ),
            SizedBox(
              width: 10.0,
            ),
            Container(
              width: 90.0,
              child: Text(
                "Gold",
                textAlign: TextAlign.left,
              ),
            ),
          ],
        );
      },
    );
  }
}
