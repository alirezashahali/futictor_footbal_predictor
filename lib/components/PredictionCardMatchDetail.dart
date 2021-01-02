import 'package:flutter/material.dart';

import './../utils/constants.dart';
import './PredictionPart.dart';

class PredictionCardMatchDetail extends StatelessWidget {
  final Map match;
  PredictionCardMatchDetail(this.match);
  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;
    return Container(
        padding: kLeagueCardPadding,
        margin: kLeagueCardMargin,
        decoration: kCardDec,
        width: mediaWidth * .9,
        child: PredictionPart(match));
  }
}
