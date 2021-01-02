import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:futictor_football_predictor/utils/constants.dart';
import 'package:provider/provider.dart';

import './../Models/LeagueCardState.dart';
import './../Models/TableScreenArgs.dart';
import './../screens/TableScreen.dart';
import './FakeChip.dart';

class DrawerKey extends StatefulWidget {
  const DrawerKey();

  @override
  _DrawerKeyState createState() => _DrawerKeyState();
}

class _DrawerKeyState extends State<DrawerKey> {
  @override
  Widget build(BuildContext context) {
    // LeagueGames leagueGames = Provider.of<LeagueGames>(context);
    LeagueCardState leagueCardState = Provider.of<LeagueCardState>(context);
    // print('leagueCardState');
    // print(leagueCardState.leagueName);
    // print(leagueCardState.leagueId);

    return Container(
      // padding: EdgeInsets.only(bottom: 10.0),
      alignment: AlignmentDirectional.topStart,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(kPadLeft, kPadTop, kPadLeft, 0.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.pushNamed(context, TableScreen.route,
                          arguments: TableScreenArgs(
                              competitionName: leagueCardState.getLeagueName,
                              competitionId: leagueCardState.getLeagueId
                              // utcDate:
                              ));
                    },
                    child: Text(
                      leagueCardState.leagueName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kDrawerHeader,
                      ),
                    ),
                  ),
                  // todo also add a chip to show number of games when it is unexpanded
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AnimatedOpacity(
                            opacity: !leagueCardState.isExpanded ? 1.0 : 0.0,
                            duration: kAnimDuration,
                            curve: Curves.easeIn,
                            child: FakeChip(
                                bgColor: Colors.orange,
                                text:
                                    leagueCardState.matchesNumber.toString())),
                        GestureDetector(
                          onTap: () {
                            leagueCardState.toggleExpanded();
                          },
                          child: Icon(
                            leagueCardState.isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: kDrawerHeader,
                            size: 30.0,
                          ),
                        ),
                      ])
                ]),
          ),
          AnimatedOpacity(
            opacity: leagueCardState.isExpanded ? 1.0 : 0.0,
            duration: kAnimDuration,
            child: Container(
              height: kPadTop,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: Color.fromRGBO(150, 150, 150, 1), width: 1.0),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
