import 'package:flutter/material.dart';

import './../utils/constants.dart';

class KeyTotalHomeAway extends StatefulWidget {
  dynamic toChanger;
  Map totalHomeAway;
  String stringKey;

  KeyTotalHomeAway({this.toChanger, this.totalHomeAway, this.stringKey});

  @override
  _KeyTotalHomeAwayState createState() => _KeyTotalHomeAwayState();
}

class _KeyTotalHomeAwayState extends State<KeyTotalHomeAway> {
  @override
  Widget build(BuildContext context) {
    final TextStyle headline4 = Theme.of(context).textTheme.headline4;
    // print('broken widg' + widget.totalHomeAway.toString(), widget);
    return GestureDetector(
      onTap: () => widget.toChanger(widget.stringKey),
      child: Container(
        decoration: BoxDecoration(
            color: widget.totalHomeAway[widget.stringKey] == 1
                ? kShallowGrey
                : Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(width: 1.0, color: kShallowGrey)),
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        child: Text(widget.stringKey.toUpperCase(),
            style: TextStyle(
                color: widget.totalHomeAway[widget.stringKey] == 1
                    ? kPrimaryColor
                    : kDeepGrey,
                fontSize: headline4.fontSize,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}
