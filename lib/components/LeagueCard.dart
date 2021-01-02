import 'package:flutter/material.dart';
import 'package:futictor_football_predictor/Models/LeagueCardState.dart';
import 'package:provider/provider.dart';

import './../utils/constants.dart';
import './DrawerKey.dart';
import './PredictionCard.dart';

// todo save some sort of state to keep if a league card was expanded or ...

// odo some sort of protruded card with the ability to minimize
class LeagueCard extends StatefulWidget {
  final List leagueMatches;
  LeagueCard({Key key, this.leagueMatches}) : super(key: key);

  @override
  _LeagueCardState createState() => _LeagueCardState();
}

class _LeagueCardState extends State<LeagueCard> {
  @override
  Widget build(BuildContext context) {
    // LeagueCardState leagueCardState = Provider.of<LeagueCardState>(context);
    return Consumer<LeagueCardState>(
      builder: (context, leagueCardState, child) => AnimatedContainer(
        duration: kAnimDuration,
        curve: Curves.easeIn,
        height: leagueCardState.isExpanded
            // height: true
            ? kHeightOfEach * leagueCardState.matchIds.length + kDrawerKeyHeight
            : kDrawerKeyHeight + 10.0,
        decoration: kCardDec,
        // height: kHeightOfEach * leagueMatches.length,
        margin: kLeagueCardMargin,
        child: Column(
          children: [
            child,
            Expanded(
              child: AnimatedOpacity(
                  opacity: leagueCardState.isExpanded ? 1.0 : 0.0,
                  duration: kAnimDuration,
                  child: Container(
                    padding: EdgeInsets.only(top: 8.0),
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.leagueMatches.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          // todo use kHeightOfEach to
                          height: kHeightOfEach,
                          child: Center(
                              child: PredictionCard(
                                  key: UniqueKey(),
                                  match: widget.leagueMatches[index])),
                        );
                      },
                    ),
                  )),
            )
          ],
        ),
      ),
      child: DrawerKey(),
    );
  }
}

// return Consumer<LeagueGames>(
// builder: (context, leagueGame, child) => Container(
// height: kHeightOfEach * leagueMatches.length + 50.0,
// decoration: BoxDecoration(
// boxShadow: [
// BoxShadow(
// color: Colors.grey.withOpacity(0.5),
// spreadRadius: 5,
// blurRadius: 7,
// offset: Offset(3, 3), // changes position of shadow
// ),
// ],
// borderRadius: BorderRadius.all(Radius.circular(kPadTop)),
// color: Color.fromARGB(255, 255, 255, 255),
// // border: Border.all(
// //   width: 1.0,
// //   color: Color.fromARGB(255, 150, 150, 150),
// // ),
// ),
// // height: kHeightOfEach * leagueMatches.length,
// padding: kLeagueCardPadding,
// margin: kLeagueCardMargin,
// child: Column(
// children: [
// child,
// Expanded(
// child: ListView.builder(
// physics: NeverScrollableScrollPhysics(),
// itemCount: leagueMatches.length,
// itemBuilder: (BuildContext context, int index) {
// return Container(
// // todo use kHeightOfEach to
// height: kHeightOfEach,
// child: Center(
// child: PredictionCard(
// key: UniqueKey(), match: leagueMatches[index])),
// );
// },
// ),
// ),
// ],
// ),
// ),
// child: DrawerKey(),
// );

// return Container(
// height: leagueGames.expanded
// ? kHeightOfEach * leagueMatches.length + 50.0
// : 50.0,
// decoration: BoxDecoration(
// boxShadow: [
// BoxShadow(
// color: Colors.grey.withOpacity(0.5),
// spreadRadius: 5,
// blurRadius: 7,
// offset: Offset(3, 3), // changes position of shadow
// ),
// ],
// borderRadius: BorderRadius.all(Radius.circular(kPadTop)),
// color: Color.fromARGB(255, 255, 255, 255),
// // border: Border.all(
// //   width: 1.0,
// //   color: Color.fromARGB(255, 150, 150, 150),
// // ),
// ),
// // height: kHeightOfEach * leagueMatches.length,
// padding: kLeagueCardPadding,
// margin: kLeagueCardMargin,
// child: Column(
// children: [
// DrawerKey(),
// Expanded(
// child: ListView.builder(
// physics: NeverScrollableScrollPhysics(),
// itemCount: leagueMatches.length,
// itemBuilder: (BuildContext context, int index) {
// return Container(
// // todo use kHeightOfEach to
// height: kHeightOfEach,
// child: Center(
// child: PredictionCard(
// key: UniqueKey(), match: leagueMatches[index])),
// );
// },
// ),
// ),
// ],
// ),
// );

// child: ListView.builder(
// physics: const AlwaysScrollableScrollPhysics(),
// padding: const EdgeInsets.all(8),
// itemCount: leagueMatches.length,
// itemBuilder: (BuildContext context, int index) {
// return Container(
// height: 100.0,
// child: Center(
// child: PredictionCard(
// key: UniqueKey(), match: leagueMatches[index])),
// );
// })
