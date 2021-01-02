import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:futictor_football_predictor/utils/constants.dart';
import 'package:provider/provider.dart';

import './../Models/LeagueCardsState.dart';
import './../utils/constants.dart';
import './LeagueCard.dart';
import './utils/componentsUtils.dart';
import '../Models/Predictions.dart';

class DayToPredict extends StatefulWidget {
  final DateTime todayDate;
  final int dayToAdd;
  DayToPredict(this.todayDate, this.dayToAdd);

  @override
  _DayToPredictState createState() => _DayToPredictState();
}

class _DayToPredictState extends State<DayToPredict> {
  Map _matchesToShowState;

  Future infoAddingProcess(preds) async {
    await preds.settingsReader();
    await preds.initPreds();
    // odo when i replace the matchesPopulate and initHistory it get stuck fix it
    await preds.initHistory();
    await preds.matchesPopulate();
    // await matches.matchesPopulate();
    preds.popInfoForHisReq();
    preds.CheckForShouldDelete();
  }

  // todo add only competitions build
  void leagueCardsStateInitializer() {
    final String neededDate = getNeededDate(widget.todayDate, widget.dayToAdd);
    Map<String, List> _matchesToShow =
        Provider.of<Predictions>(context).matches;
    Map<String, List> _matchesToShowForToday =
        filterGamesForToday(_matchesToShow, neededDate);
    List comps = _matchesToShowForToday.keys.toList();
    // print('finding the shit');
    // print(_matchesToShowForToday);

    //check if _matchesToShow has updated so we should sort of rebuild LeagueCardsState
    if (!mapEquals(_matchesToShow, _matchesToShowState)) {
      for (String leagueName in comps) {
        LeagueCardsState leagueCardsState =
            Provider.of<LeagueCardsState>(context, listen: false);
        leagueCardsState.build(
            neededDate + leagueName,
            leagueName,
            _matchesToShowForToday[leagueName]
                .map((match) => match['id'])
                .toList(),
            _matchesToShowForToday[leagueName][0]['competition']['id']);
      }
      setState(() {
        _matchesToShowState = _matchesToShow;
      });
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    leagueCardsStateInitializer();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final String neededDate = getNeededDate(widget.todayDate, widget.dayToAdd);
    Predictions preds = Provider.of<Predictions>(context, listen: false);

    // print('day to predict building' + neededDate);
    if (preds.fetching) {
      return Center(child: CircularProgressIndicator());
    }

    // todo make these into some sort method or function
    Map<String, List> _matchesToShow = {};
    // todo null is temporary
    // todo make it a sort of method in matches model and the next one too
    if (preds.getClubSettings['allComps']) {
      _matchesToShow = preds.matches;
    } else {
      for (String comp in preds.getClubSettings.keys) {
        if (preds.getClubSettings[comp] == true) {
          if (preds.matches[kClubNameKey[comp]] != null) {
            _matchesToShow[kClubNameKey[comp]] =
                preds.matches[kClubNameKey[comp]];
          }
        }
      }
    }
    Map<String, List> _matchesToShowForThisDay =
        filterGamesForToday(_matchesToShow, neededDate);

    // return Container(child: Text('still testing don\'t mind me'));
    List keyList = _matchesToShowForThisDay.keys.toList();

    // todo build all LeagueCardsState for this Day
    // for (String key in keyList) {
    //   cardsState.build(
    //       '${neededDate} + ${key}',
    //       _matchesToShowForThisDay[key].map((match) => match['id']).toList(),
    //       key);
    // }

    if (keyList.length == 0) {
      return Container(
        child: Center(
          child: Text('sorry but nothing to show for today'),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 220, 220, 220),
      ),
      child: RefreshIndicator(
        onRefresh: () => infoAddingProcess(preds),
        child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(10),
            itemCount: keyList.length,
            itemBuilder: (BuildContext context, int index) {
              // add the state if its not;
              return MultiProvider(
                providers: [
                  // ChangeNotifierProvider.value(
                  //     value: LeagueGames(
                  //         leagueName: keyList[index],
                  //         listLength:
                  //             _matchesToShowForThisDay[keyList[index]].length)),
                  ChangeNotifierProvider.value(
                      value:
                          Provider.of<LeagueCardsState>(context, listen: false)
                              .leagueCardsState[neededDate + keyList[index]]),
                ],
                child: LeagueCard(
                  key: UniqueKey(),
                  leagueMatches: _matchesToShowForThisDay[keyList[index]],
                ),
              );
              // ChangeNotifierProvider.value(
              //   value: LeagueGames(
              //       leagueName: keyList[index],
              //       listLength:
              //           _matchesToShowForThisDay[keyList[index]].length),
              //   child: LeagueCard(
              //     leagueName: keyList[index],
              //     neededDate: neededDate,
              //     key: UniqueKey(),
              //     leagueMatches: _matchesToShowForThisDay[keyList[index]],
              //   ),
              // );
              // todo add changeNotifierProver here
              // return Container(
              //   child: LeagueCard(
              //     key: UniqueKey(),
              //     leagueMatches: _matchesToShowForThisDay[keyList[index]],
              //     leagueName: keyList[index],
              //   ),
              // );
            }),
      ),
    );
  }
}

// class DayToPredict extends StatelessWidget {
//   final DateTime todayDate;
//   final int dayToAdd;
//   DayToPredict(this.todayDate, this.dayToAdd);
//
//   Future infoAddingProcess(preds) async {
//     await preds.settingsReader();
//     // await Matches.matchesPopulate();
//     await preds.matchesPopulate();
//     await preds.initPreds();
//     await preds.initHistory();
//     preds.popInfoForHisReq();
//     preds.CheckForShouldDelete();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final String neededDate =
//         todayDate.add(Duration(days: dayToAdd)).toString().split(' ')[0];
//     Predictions preds = Provider.of<Predictions>(context, listen: false);
//
//     print('day to predict building');
//     if (preds.fetching) {
//       return Center(child: CircularProgressIndicator());
//     }
//
//     // todo make these into some sort method or function
//     Map<String, List> _matchesToShow = {};
//     // todo null is temporary
//     // todo make it a sort of method in matches model and the next one too
//     if (preds.getClubSettings['allComps'] != null &&
//         preds.getClubSettings['allComps']) {
//       _matchesToShow = preds.matches;
//     } else {
//       for (String comp in preds.getClubSettings.keys) {
//         if (preds.getClubSettings[comp] == true) {
//           _matchesToShow[kClubNameKey[comp]] =
//               preds.matches[kClubNameKey[comp]];
//         }
//       }
//     }
//     Map<String, List> _matchesToShowForThisDay = {};
//     for (String leagueGames in _matchesToShow.keys) {
//       for (Map match in _matchesToShow[leagueGames]) {
//         // print(DateTime.parse(match['utcDate'])
//         //     .toLocal()
//         //     .toString()
//         //     .split(" ")[0]);
//         if (DateTime.parse(match['utcDate'])
//                 .toLocal()
//                 .toString()
//                 .split(" ")[0] ==
//             neededDate) {
//           // remove the match that is not held today
//           if (_matchesToShowForThisDay[leagueGames] == null) {
//             _matchesToShowForThisDay[leagueGames] = [];
//           }
//           _matchesToShowForThisDay[leagueGames].add(match);
//         }
//       }
//     }
//
//     // return Container(child: Text('still testing don\'t mind me'));
//     List keyList = _matchesToShowForThisDay.keys.toList();
//
//     // todo build all LeagueCardsState for this Day
//     // for (String key in keyList) {
//     //   cardsState.build(
//     //       '${neededDate} + ${key}',
//     //       _matchesToShowForThisDay[key].map((match) => match['id']).toList(),
//     //       key);
//     // }
//
//     if (keyList.length == 0) {
//       return Container(
//         child: Center(
//           child: Text('sorry but nothing to show for today'),
//         ),
//       );
//     }
//
//     return Container(
//         decoration: BoxDecoration(
//           color: Color.fromARGB(255, 220, 220, 220),
//         ),
//         child: RefreshIndicator(
//           onRefresh: () => infoAddingProcess(preds),
//           child: ListView.builder(
//               physics: const AlwaysScrollableScrollPhysics(),
//               padding: const EdgeInsets.all(10),
//               itemCount: keyList.length,
//               itemBuilder: (BuildContext context, int index) {
//                 // add the state if its not;
//                 return ChangeNotifierProvider.value(
//                   value: LeagueGames(
//                       leagueName: keyList[index],
//                       listLength:
//                           _matchesToShowForThisDay[keyList[index]].length),
//                   child: LeagueCard(
//                     leagueName: keyList[index],
//                     neededDate: neededDate,
//                     key: UniqueKey(),
//                     leagueMatches: _matchesToShowForThisDay[keyList[index]],
//                   ),
//                 );
//                 // todo add changeNotifierProver here
//                 // return Container(
//                 //   child: LeagueCard(
//                 //     key: UniqueKey(),
//                 //     leagueMatches: _matchesToShowForThisDay[keyList[index]],
//                 //     leagueName: keyList[index],
//                 //   ),
//                 // );
//               }),
//         ));
//   }
// }
