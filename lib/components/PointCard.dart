import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import './../utils/constants.dart';
import './utils/componentsUtils.dart';

// todo not showing the real result at the start

class PointCard extends StatelessWidget {
  var data;
  PointCard(this.data);
  @override
  Widget build(BuildContext context) {
    final TextStyle text1S = Theme.of(context).textTheme.bodyText1;
    final TextStyle text2S = Theme.of(context).textTheme.bodyText2;
    final TextStyle text2H = Theme.of(context).textTheme.headline2;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      // height: 140.0,
      decoration: kCardDec,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 5.0),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
              width: 1.0,
            ))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                data['comp'] == null
                    ? Text('Game', style: text2S)
                    : Text(
                        nameStringBurper(data['comp']),
                        style: text2S,
                      ),
                Text(
                  dateStringBurper(data['utcDate']),
                  style: text2S,
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 2),
                child: Text(
                  'Prediction',
                  style: text2H,
                ),
              ),
              Text(
                'Point',
                style: text2H,
              )
            ],
          ),
          Row(
            children: [
              Container(
                child: Column(
                  children: [
                    teamNameResult('home', 'homeTeam', text1S, data, context),
                    teamNameResult('away', "awayTeam", text1S, data, context)
                  ],
                ),
              ),
              Column(
                children: [
                  predRes('homeTeam', text1S, data),
                  predRes('awayTeam', text1S, data)
                ],
              ),
              Expanded(
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Text(
                    data['point'].toString(),
                    style: TextStyle(
                        fontSize: text1S.fontSize + 5.0,
                        fontWeight: FontWeight.bold,
                        color: colorGiver(data['point'].toDouble())),
                  ),
                ]),
              )
            ],
          )
        ],
      ),
    );
  }
}

Widget teamNameResult(String name, String nameTeam, TextStyle textStyle,
    Map data, BuildContext context) {
  return Row(
    children: [
      data[name] != null
          ? Container(
              width: MediaQuery.of(context).size.width / 2 - 20.0,
              padding: EdgeInsets.only(bottom: kPadTop),
              child: Text(
                data[name]['name'],
                maxLines: 1,
                style: textStyle,
              ),
            )
          : Container(
              width: MediaQuery.of(context).size.width / 2 - 20.0,
              padding: EdgeInsets.only(bottom: kPadTop),
              child: Text(
                nameTeam,
                maxLines: 1,
                style: textStyle,
              ),
            ),
      Container(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 10.0),
        child: Text(
          data['result'][nameTeam].toString(),
          style: textStyle,
        ),
      )
    ],
  );
}

Widget predRes(String name, TextStyle textStyle, Map data) {
  return Container(
    padding: EdgeInsets.fromLTRB(30.0, 0, 0, 10.0),
    child: Text(
      data['pred'][name].toString(),
      style: textStyle,
    ),
  );
}

String dateStringBurper(String input) {
  String output = input.split("T")[0];
  if (output[0] == '"') {
    return output.split('"')[1];
  }
  return output;
}

String nameStringBurper(String input) {
  if (input[0] == '"') {
    return input.split('"')[1];
  }
  return input;
}
