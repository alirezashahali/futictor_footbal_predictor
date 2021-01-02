import 'package:flutter/material.dart';

import './../../utils/constants.dart';
import './../KeyForTotalHomeAway.dart';
import './../TeamTableRow.dart';

String getNeededDate(DateTime todayDate, int dayToAdd) {
  return todayDate.add(Duration(days: dayToAdd)).toString().split(' ')[0];
}

Map<String, List> filterGamesForToday(
    Map<String, List> matchesToShow, String neededDate) {
  Map<String, List> matchesToShowForThisDay = {};
  for (String leagueGames in matchesToShow.keys) {
    for (Map match in matchesToShow[leagueGames]) {
      // print(DateTime.parse(match['utcDate'])
      //     .toLocal()
      //     .toString()
      //     .split(" ")[0]);
      if (DateTime.parse(match['utcDate']).toLocal().toString().split(" ")[0] ==
          neededDate) {
        // remove the match that is not held today
        if (matchesToShowForThisDay[leagueGames] == null) {
          matchesToShowForThisDay[leagueGames] = [];
        }
        matchesToShowForThisDay[leagueGames].add(match);
      }
    }
  }
  return matchesToShowForThisDay;
}

Color colorGiver(double point) {
  if (point <= kColorThresh['low']) {
    return kDangerColor;
  }
  if (point >= 1 && point < 3) {
    return kInfoColor;
  }
  return kPrimaryColor;
}

void kInsideControllerListener =
    (ScrollController _scrollController, ScrollController _parentController) {
  var innerPos = _scrollController.position.pixels;
  var maxInnerPos = _scrollController.position.maxScrollExtent;
  var maxOuterPos = _parentController.position.maxScrollExtent;
  var currentOutPos = _parentController.position.pixels;
  var innerPosOverScroll = _scrollController.offset;

  // print("parent pos " +
  //     currentOutPos.toString() +
  //     " max parent pos " +
  //     maxOuterPos.toString() +
  //     ' inner Pos' +
  //     innerPos.toString() +
  //     ' max inner pos' +
  //     maxInnerPos.toString() +
  //     'offset of inner' +
  //     innerPosOverScroll.toString());
  // todo annimate to end
  if (innerPos >= 0 && currentOutPos < maxOuterPos) {
    _parentController.position.jumpTo(innerPos);
    // todo annimate to start butt first check reasonability
  } else if (innerPos <= 1.0 && currentOutPos > 0) {
    print('yup it gets smaller' + innerPos.toString());
    _parentController.position.jumpTo(currentOutPos - 1.0);
  } else {
    var currentParentPos = currentOutPos;
    _parentController.position.jumpTo(currentParentPos);
  }
};

List<Widget> tableMaker(List unknownComp, Map compInfo, Map match,
    Map _totalHomeAway, BuildContext context, TextStyle teamLine) {
  List<Widget> returnie = [];
  for (int i = 0; i < unknownComp.length; i++) {
    // print('unknownComp');
    // print()
    returnie.add(widgetMaker(
        unknownComp[i],
        compInfo[unknownComp[i]['team']['id'].toString()],
        match,
        _totalHomeAway,
        context,
        teamLine));
  }
  return returnie;
}

//todo widgetmaker should return a tweenAnimationBuilder
Widget widgetMaker(Map team, Map compInfoForTeam, Map match, Map _totalHomeAway,
    BuildContext context, TextStyle style) {
  double eachTableRowHeight =
      kLeagueCardPadding.vertical + kHeightOfEachInTable;
  String activeKey = activeKeyGetter(_totalHomeAway);

  return TweenAnimationBuilder(
    // for begin get the position in total and then calculate the height based on the position
    // to calculate end take the state and see what that is to caculate the end based on that
    tween: Tween<double>(
        begin: positionCalculator(
                compInfoForTeam, kInitialTotalHomeAwayState.keys.toList()[0]) *
            eachTableRowHeight,
        end: positionCalculator(compInfoForTeam, activeKey) *
            eachTableRowHeight),
    duration: Duration(milliseconds: 500),
    curve: Curves.easeInOut,
    builder: (context, double position, Widget child) {
      return Positioned(
          // height: eachTableRowHeight,
          width: MediaQuery.of(context).size.width,
          top: position,
          child: Container(
            padding: kLeagueCardPadding,
            decoration: BoxDecoration(
                color: (match != null &&
                        (team['team']['id'] == match['homeTeamId'] ||
                            team['team']['id'] == match['awayTeamId']))
                    ? kLightGrey
                    : Colors.white,
                border: Border(
                    bottom: BorderSide(width: .5, color: Colors.blueGrey))),
            child: TeamTableRow(
              position: compInfoForTeam[activeKey]['position'].toString(),
              crestUrl: compInfoForTeam[activeKey]['team']['crestUrl'],
              teamName: compInfoForTeam[activeKey]['team']['name'].toString(),
              playedGames: compInfoForTeam[activeKey]['playedGames'].toString(),
              won: compInfoForTeam[activeKey]['won'].toString(),
              draw: compInfoForTeam[activeKey]['draw'].toString(),
              lost: compInfoForTeam[activeKey]['lost'].toString(),
              goalForAgainst:
                  '${compInfoForTeam[activeKey]['goalsFor'].toString()}/${compInfoForTeam[activeKey]['goalsAgainst'].toString()}',
              goalDifference:
                  compInfoForTeam[activeKey]['goalDifference'].toString(),
              points: compInfoForTeam[activeKey]['points'].toString(),
              style: style,
            ),
          ));
    },
    // child: TeamTableRow(
    //   position: team['position'].toString(),
    //   crestUrl: team['team']['crestUrl'],
    //   teamName: team['team']['name'].toString(),
    //   playedGames: team['playedGames'].toString(),
    //   won: team['won'].toString(),
    //   draw: team['draw'].toString(),
    //   lost: team['lost'].toString(),
    //   goalForAgainst:
    //       '${team['goalsFor'].toString()}/${team['goalsAgainst'].toString()}',
    //   goalDifference: team['goalDifference'].toString(),
    //   points: team['points'].toString(),
    //   style: style,
    // ),
  );

  // Container(
  //   padding: kLeagueCardPadding,
  //   decoration: BoxDecoration(
  //       color: (team['team']['id'] == match['homeTeamId'] ||
  //               team['team']['id'] == match['awayTeamId'])
  //           ? kLightGrey
  //           : Colors.white,
  //       border:
  //           Border(bottom: BorderSide(width: .5, color: Colors.blueGrey))),
  //   child: );
}

Widget totalHomeAway(_toChanger, Map _totalHomeAway) {
  return Container(
    decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1.0, color: kShallowGrey))),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        KeyTotalHomeAway(
          toChanger: _toChanger,
          totalHomeAway: _totalHomeAway,
          stringKey: 'total',
        ),
        KeyTotalHomeAway(
          toChanger: _toChanger,
          totalHomeAway: _totalHomeAway,
          stringKey: 'home',
        ),
        KeyTotalHomeAway(
          toChanger: _toChanger,
          totalHomeAway: _totalHomeAway,
          stringKey: 'away',
        ),
      ],
    ),
  );
}

Map compInfoBuilder(List total, List home, List away) {
  Map returnie = {};
  for (var item in total) {
    int teamId = item['team']['id'];
    Map eachRet = {};
    eachRet['total'] = item;
    eachRet['home'] =
        home.singleWhere((element) => element['team']['id'] == teamId);
    eachRet['away'] =
        away.singleWhere((element) => element['team']['id'] == teamId);
    returnie[teamId.toString()] = eachRet;
  }
  return returnie;
}

int positionCalculator(Map compInfo, String activeKey) {
  return (compInfo[activeKey]['position'] - 1);
}

String activeKeyGetter(Map _totalHomeAway) {
  List kKeysForTotalHomeAway = kInitialTotalHomeAwayState.keys.toList();
  for (var item in kKeysForTotalHomeAway) {
    if (_totalHomeAway[item] == 1) {
      return item;
    }
  }
}
