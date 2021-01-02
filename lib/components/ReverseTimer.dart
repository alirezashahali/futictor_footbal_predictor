import 'dart:async';

import 'package:flutter/material.dart';

import './../utils/constants.dart';

class ReverseTimer extends StatefulWidget {
  final int secondsToShow;
  final TextStyle textStyle;
  ReverseTimer(this.secondsToShow, this.textStyle);
  @override
  _ReverseTimerState createState() => _ReverseTimerState();
}

class _ReverseTimerState extends State<ReverseTimer> {
  Timer _timer;
  int _secondsToShow;
  String _afterEndText;

  void startTimer() {
    const _oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(_oneSec, (Timer timer) {
      if (_secondsToShow <= 0) {
        timer.cancel();
        setState(() {
          _afterEndText = kWaitForResultText;
        });
      } else {
        // print(_secondsToShow);
        setState(() {
          _secondsToShow--;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _secondsToShow = widget.secondsToShow;
    });
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: listToText(secondsToTime(_secondsToShow), widget.textStyle),
    );
  }
}

List secondsToTime(int seconds) {
  final int secs = seconds % 60;
  final int minutes = seconds ~/ 60;
  final int mins = minutes % 60;
  final int hours = minutes ~/ 60;
  return [secs, mins, hours];
}

Widget listToText(List timeList, TextStyle textStyle) {
  return Text(
    gracefulTwoNumberer(timeList[2]) +
        ':' +
        gracefulTwoNumberer(timeList[1]) +
        ':' +
        gracefulTwoNumberer(timeList[0]),
    style: textStyle,
  );
}

String gracefulTwoNumberer(int inp) {
  if (inp < 10) {
    return '0' + inp.toString();
  } else {
    return inp.toString();
  }
}
