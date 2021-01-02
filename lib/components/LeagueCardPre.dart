// was a test did not get used
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './../Models/LeagueCardsState.dart';
import './LeagueCard.dart';

class LeagueCardPre extends StatelessWidget {
  final String neededDate;
  final String leagueName;
  final List leagueMatches;
  final Key key;
  LeagueCardPre(
      {this.key, this.neededDate, this.leagueName, this.leagueMatches})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    LeagueCardsState leagueCardsState =
        Provider.of<LeagueCardsState>(context, listen: false);
    return ChangeNotifierProvider.value(
      value: leagueCardsState.leagueCardsState[neededDate + leagueName],
      child: LeagueCard(key: key, leagueMatches: leagueMatches),
    );
  }
}
