import 'package:flutter/material.dart';

import './../Models/Competition.dart';
import './../components/MatchFacts.dart';
import './../utils/constants.dart';

class PerformanceTable extends StatelessWidget {
  final Map match;
  final Competition competition;

  PerformanceTable(this.match, this.competition);
  @override
  Widget build(BuildContext context) {
    final headline4 = Theme.of(context).textTheme.headline4;
    final cardWidth = .9 * MediaQuery.of(context).size.width;
    final Map homeTeamHome = teamFinder(
        competition.competition, match['homeTeamId'], kGameTypes['HOME']);
    final Map homeTeamAway = teamFinder(
        competition.competition, match['homeTeamId'], kGameTypes['AWAY']);
    final Map awayTeamHome = teamFinder(
        competition.competition, match['awayTeamId'], kGameTypes['HOME']);
    final Map awayTeamAway = teamFinder(
        competition.competition, match['awayTeamId'], kGameTypes['AWAY']);

    return Container(
      decoration: kCardDec,
      width: cardWidth,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          margin: kLeagueCardMargin,
          padding: kLeagueCardPadding,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Text(
                    'Home',
                    style: headline4,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Container(
                    width: 10.0,
                    height: 10.0,
                    color: kHomeColor,
                  )
                ]),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Text(
                      'Away',
                      style: headline4,
                    ),
                    SizedBox(width: 10.0),
                    Container(
                      width: 10.0,
                      height: 10.0,
                      color: kAwayColor,
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(),
              )
            ],
          ),
        ),
        Container(
          margin: kLeagueCardMargin,
          padding: kLeagueCardPaddingNoTop,
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(2),
            },
            children: [
              TableRow(children: [
                Container(),
                headBelcher('Home', headline4, true),
                headBelcher('Away', headline4, true)
              ]),
              TableRow(children: [
                headBelcher('Points', headline4, false),
                HomeAwayBoxer(textFromTeamBringer(homeTeamHome, 'points'),
                    textFromTeamBringer(awayTeamHome, 'points')),
                HomeAwayBoxer(textFromTeamBringer(homeTeamAway, 'points'),
                    textFromTeamBringer(awayTeamAway, 'points'))
              ]),
              TableRow(children: [
                headBelcher('Win-rate', headline4, false),
                HomeAwayBoxer(textFromTeamBringer(homeTeamHome, 'won'),
                    textFromTeamBringer(awayTeamHome, 'won')),
                HomeAwayBoxer(textFromTeamBringer(homeTeamAway, 'won'),
                    textFromTeamBringer(awayTeamAway, 'won'))
              ]),
              TableRow(children: [
                headBelcher('Draw-rate', headline4, false),
                HomeAwayBoxer(textFromTeamBringer(homeTeamHome, 'draw'),
                    textFromTeamBringer(awayTeamHome, 'draw')),
                HomeAwayBoxer(textFromTeamBringer(homeTeamAway, 'draw'),
                    textFromTeamBringer(awayTeamAway, 'draw'))
              ]),
              TableRow(children: [
                headBelcher('Loss-rate', headline4, false),
                HomeAwayBoxer(textFromTeamBringer(homeTeamHome, 'lost'),
                    textFromTeamBringer(awayTeamHome, 'lost')),
                HomeAwayBoxer(textFromTeamBringer(homeTeamAway, 'lost'),
                    textFromTeamBringer(awayTeamAway, 'lost'))
              ]),
              TableRow(children: [
                headBelcher('Scored', headline4, false),
                HomeAwayBoxer(textFromTeamBringer(homeTeamHome, 'goalsFor'),
                    textFromTeamBringer(awayTeamHome, 'goalsFor')),
                HomeAwayBoxer(textFromTeamBringer(homeTeamAway, 'goalsFor'),
                    textFromTeamBringer(awayTeamAway, 'goalsFor'))
              ]),
              TableRow(children: [
                headBelcher('Conceited', headline4, false),
                HomeAwayBoxer(textFromTeamBringer(homeTeamHome, 'goalsAgainst'),
                    textFromTeamBringer(awayTeamHome, 'goalsAgainst')),
                HomeAwayBoxer(textFromTeamBringer(homeTeamAway, 'goalsAgainst'),
                    textFromTeamBringer(awayTeamAway, 'goalsAgainst'))
              ]),
              // TableRow(children: [])
              // TableRow(children: [Text('fucker'), Text('fuckers')]),
            ],
          ),
        ),
      ]),
    );
  }
}

Widget headBelcher(String title, TextStyle style, bool center) {
  if (center == false) {
    return Text(
      title,
      style: style,
    );
  }
  return Center(
    child: Text(
      title,
      style: style,
    ),
  );
}

String textFromTeamBringer(Map team, String field) {
  switch (field) {
    case 'points':
      return ('${team['points'].toString()}/${(team['playedGames'] * 3).toString()}');
      break;
    case 'won':
      return ((team['won'] / team['playedGames']) * 100)
              .toStringAsPrecision(3) +
          '%';
      break;
    case 'draw':
      return ((team['draw'] / team['playedGames']) * 100)
              .toStringAsPrecision(3) +
          '%';
      break;
    case 'lost':
      return ((team['lost'] / team['playedGames']) * 100)
              .toStringAsPrecision(3) +
          '%';
      break;
    case 'goalsFor':
      return team['goalsFor'].toString();
      break;
    case 'goalsAgainst':
      return team['goalsAgainst'].toString();
      break;
  }
}

class HomeAwayBoxer extends StatelessWidget {
  final String home;
  final String away;
  HomeAwayBoxer(this.home, this.away);
  @override
  Widget build(BuildContext context) {
    final headline5 = Theme.of(context).textTheme.headline5;
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: kHomeColor,
                  borderRadius: BorderRadius.only(
                      topLeft: kBorderRadiusForHomeAway,
                      bottomLeft: kBorderRadiusForHomeAway)),
              width: constraints.maxWidth / 2 - kMarginForHomeAway,
              child: Center(
                child: Text(
                  home,
                  style: headline5,
                ),
              ),
            ),
            Container(
                decoration: BoxDecoration(
                    color: kAwayColor,
                    borderRadius: BorderRadius.only(
                        topRight: kBorderRadiusForHomeAway,
                        bottomRight: kBorderRadiusForHomeAway)),
                width: constraints.maxWidth / 2 - kMarginForHomeAway,
                child: Center(child: Text(away, style: headline5)))
          ],
        ),
      );
    });
  }
}
