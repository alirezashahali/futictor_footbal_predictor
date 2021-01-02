import 'package:flutter/material.dart';

import './../utils/constants.dart';

class FakeChip extends StatelessWidget {
  final Color bgColor;
  final String text;

  const FakeChip({this.bgColor, this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: kPadLeft / 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.all(
          Radius.circular(kFChipR),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 16.0, color: Colors.white),
      ),
    );
  }
}
