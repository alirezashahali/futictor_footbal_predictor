import 'package:flutter/material.dart';

import './../utils/constants.dart';
import './ReverseTimer.dart';

class TimeOrResult extends StatelessWidget {
  final String utcDate;
  final Map result;
  final String status;
  TimeOrResult(this.utcDate, this.result, this.status);

  @override
  Widget build(BuildContext context) {
    final TextStyle textTheme = Theme.of(context).textTheme.headline3;
    // print('res sucker');
    // print(result);
    // Predictions Preds = Provider.of<Predictions>(context, listen: false);
    final int secondsTill = DateTime.parse(dateFixer(utcDate))
        .difference(DateTime.now().toUtc())
        .inSeconds;
    if (secondsTill > 0) {
      return ReverseTimer(secondsTill, textTheme);
    } else if (status == 'FINISHED') {
      return resultShower(result, textTheme);
    } else {
      return Text(
        kWaitForResultText,
        style: textTheme,
      );
    }
  }
}

String dateFixer(String input) {
  // print(input);
  List inputs = input.split("T");
  String outPut;
  if (inputs[0][0] == '"') {
    outPut = inputs[0].split('"')[1];
  } else {
    outPut = inputs[0];
  }
  outPut += ' ';
  List newInputs = inputs[1].split(':');
  outPut += newInputs[0] + ':' + newInputs[1] + ':' + newInputs[2];
  return outPut;
}

Widget resultShower(result, TextStyle textStyle) {
  return Text(
    result['fullTime']['homeTeam'].toString() +
        '-' +
        result['fullTime']['awayTeam'].toString(),
    style: textStyle,
  );
}
