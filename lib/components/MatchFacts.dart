import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:futictor_football_predictor/Models/Competition.dart';
import 'package:provider/provider.dart';

import './../Models/LayeredControllers.dart';
import './../components/PerformanceTable.dart';
import './../utils/constants.dart';
import './PredictionCardMatchDetail.dart';

class MatchFacts extends StatefulWidget {
  final Map match;
  final ScrollController parentController;

  MatchFacts(this.match, this.parentController);

  @override
  _MatchFactsState createState() => _MatchFactsState();
}

class _MatchFactsState extends State<MatchFacts>
    with AutomaticKeepAliveClientMixin<MatchFacts>, LayeredControllers {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  ScrollController _scrollController;
  // double position;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    // _scrollController.addListener(
    //     () => listener(_scrollController, widget.parentController));

    // widget.parentController.addListener(() {
    //   var currentOutPos = widget.parentController.position.pixels;
    //   var innerPos = _scrollController.position.pixels;
    //   if (currentOutPos <= 0) {
    //     _scrollController.position.jumpTo(innerPos + currentOutPos);
    //   }
    //   // position = widget.parentController.position.pixels;
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (position != null) {
    //   widget.parentController.position.jumpTo(position);
    // }
    Competition competition = Provider.of<Competition>(context);
    if (mapEquals(competition.competition, {})) {
      return SingleChildScrollView();
    } else {
      return NotificationListener(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollStartNotification) {
            onStartScroll(scrollNotification);
          } else if (scrollNotification is ScrollUpdateNotification) {
            onUpdateScroll(
                scrollNotification, _scrollController, widget.parentController);
          } else if (scrollNotification is ScrollEndNotification) {
            onEndScroll(scrollNotification);
          } else if (scrollNotification is OverscrollNotification) {
            onOverScroll(
                scrollNotification, _scrollController, widget.parentController);
          }
          return true;
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          // primary: true,
          child: Container(
            margin: EdgeInsets.only(top: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.match['status'] == 'SCHEDULED')
                  PredictionCardMatchDetail(widget.match),
                if (widget.match['status'] == 'SCHEDULED')
                  SizedBox(
                    height: 20.0,
                  ),
                TeamForm(widget.match, competition),
                SizedBox(
                  height: 20.0,
                ),
                PerformanceTable(widget.match, competition)
              ],
            ),
          ),
        ),
      );
    }
  }
}

// class MatchFacts extends StatelessWidget {
//   final Map match;
//   MatchFacts(this.match);
//   @override
//   Widget build(BuildContext context) {
//     Competition competition = Provider.of<Competition>(context);
//     if (mapEquals(competition.competition, {})) {
//       return Container();
//     }
//     return SingleChildScrollView(
//       child: Container(
//         margin: EdgeInsets.only(top: 10.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             if (match['status'] == 'SCHEDULED')
//               PredictionCardMatchDetail(match),
//             if (match['status'] == 'SCHEDULED')
//               SizedBox(
//                 height: 20.0,
//               ),
//             TeamForm(match, competition),
//             SizedBox(
//               height: 20.0,
//             ),
//             PerformanceTable(match, competition)
//           ],
//         ),
//       ),
//     );
//   }
// }

class TeamForm extends StatelessWidget {
  final Map match;
  final Competition competition;

  TeamForm(this.match, this.competition);
  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.headline2;
    final textBodyStyle = Theme.of(context).textTheme.bodyText1;
    final mediaWidth = MediaQuery.of(context).size.width;
    final Map homeTeam = teamFinder(
        competition.competition, match['homeTeamId'], kGameTypes['TOTAL']);
    final Map awayTeam = teamFinder(
        competition.competition, match['awayTeamId'], kGameTypes['TOTAL']);
    return Container(
      decoration: kCardDec,
      width: mediaWidth * .9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: kCardMemberPadding,
            margin: kLeagueCardMargin,
            child: Text(
              'Team form',
              style: textStyle,
            ),
          ),
          Container(
            padding: kCardMemberPadding,
            margin: kLeagueCardMargin,
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [WDLBox(homeTeam), WDLBox(awayTeam)],
              ),
              Container(
                padding: kCardMemberPadding,
                margin: kLeagueCardMargin,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1.0, color: Colors.black38))),
                child: Text(
                  'Games played: goals scored-conceded',
                  style: textBodyStyle,
                ),
              ),
              Container(
                margin: kLeagueCardMargin,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text((homeTeam['playedGames'].toString() +
                        ':' +
                        homeTeam['goalsFor'].toString() +
                        '-' +
                        homeTeam['goalsAgainst'].toString())),
                    Text((awayTeam['playedGames'].toString() +
                        ':' +
                        awayTeam['goalsFor'].toString() +
                        '-' +
                        awayTeam['goalsAgainst'].toString()))
                  ],
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }
}

Map teamFinder(Map competition, int teamId, String totalHomeAway) {
  // print(competition['standings'][0]['table']);

  List listOfClubs = totalHomeAwayCatFinder(competition, totalHomeAway);
  // [0]['table'];
  Map teamData =
      listOfClubs.singleWhere((element) => element['team']['id'] == teamId);
  return teamData;
}

List totalHomeAwayCatFinder(Map competition, String totalHomeAway) {
  if (competition['standings'] != null) {
    return competition['standings']
        .singleWhere((element) => element['type'] == totalHomeAway)['table'];
  }
  return [];
}

class WDLBox extends StatelessWidget {
  final Map teamData;
  WDLBox(this.teamData);
  @override
  Widget build(BuildContext context) {
    final List streakList = teamData['form'].split(',').reversed.toList();
    List<Widget> streakListWidg =
        streakList.map((el) => sexyBoxerForWDL(el)).toList();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: streakListWidg,
    );
  }
}

Widget sexyBoxerForWDL(String wdl) {
  Color _color;

  switch (wdl) {
    case 'W':
      _color = kPrimaryColor;
      break;
    case 'L':
      _color = kDangerColor;
      break;
    case 'D':
      _color = kGefagigColor;
      break;
    default:
      _color = kInfoColor;
  }

  return Container(
    width: 25.0,
    decoration:
        BoxDecoration(color: _color, borderRadius: BorderRadius.circular(5.0)),
    padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
    margin: EdgeInsets.all(1.0),
    child: Center(child: Text(wdl, style: textStyleWDL)),
  );
}
