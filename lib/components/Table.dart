//todo fix changing fast to table that causes error
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './../Models/Competition.dart';
import './../Models/CustomScrollController.dart';
import './../Models/LayeredControllers.dart';
import './../components/MatchFacts.dart';
import './../components/TeamTableRow.dart';
import './../components/utils/componentsUtils.dart';
import './../utils/constants.dart';

// todo optional add a capability for table to be called from the league card in each day

class LeagueTable extends StatefulWidget {
  final Map match;
  final ScrollController parentController;

  LeagueTable({this.match, this.parentController});
  @override
  _LeagueTableState createState() => _LeagueTableState();
}

class _LeagueTableState extends State<LeagueTable>
    with AutomaticKeepAliveClientMixin<LeagueTable>, LayeredControllers {
  ScrollController _scrollController;
  Map _totalHomeAway = kInitialTotalHomeAwayState;
  // double position;

  void totalHomeAwayChanger(String stringKey) {
    Map _toParams = {'total': 0, 'home': 0, 'away': 0};
    // List _totalHomeAwayKeys = _totalHomeAway.keys.toList();
    switch (stringKey) {
      case "total":
        {
          _toParams['total'] = 1;
          setState(() {
            _totalHomeAway = _toParams;
          });
        }
        break;
      case "home":
        {
          _toParams['home'] = 1;
          setState(() {
            _totalHomeAway = _toParams;
          });
        }
        break;
      case 'away':
        {
          _toParams['away'] = 1;
          setState(() {
            _totalHomeAway = _toParams;
          });
        }
        break;
      default:
        {
          setState(() {
            _totalHomeAway = kInitialTotalHomeAwayState;
          });
        }
        break;
    }
    setState(() {
      _totalHomeAway = _toParams;
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (widget.parentController != null) {
      _scrollController = CustomScrollController(widget.parentController);
    } else {
      _scrollController = ScrollController();
    }
    // _scrollController.addListener(
    //     () => listener(_scrollController, widget.parentController));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List _kInitialTotalHomeAwayStateKey =
        kInitialTotalHomeAwayState.keys.toList();
    // if (position != null) {
    //   widget.parentController.position.jumpTo(position);
    // }
    TextStyle teamLine = Theme.of(context).textTheme.headline5;
    TextStyle teamTitle = Theme.of(context).textTheme.headline4;
    Competition competition = Provider.of<Competition>(context);
    final List totalComp =
        totalHomeAwayCatFinder(competition.competition, kGameTypes['TOTAL']);
    final List homeComp =
        totalHomeAwayCatFinder(competition.competition, kGameTypes['HOME']);
    final List awayComp =
        totalHomeAwayCatFinder(competition.competition, kGameTypes['AWAY']);
    final Map compInfo = compInfoBuilder(totalComp, homeComp, awayComp);
    // print(compInfo);
    // print(compInfo);
    // print('competition shit');
    // print(totalComp);
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
        child: Stack(
          children: [
            Container(
              child: Column(children: [
                SizedBox(
                  height: kLeagueHeaderAreaHeight,
                ),
                Expanded(child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return ListView(
                      dragStartBehavior: DragStartBehavior.start,
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _scrollController,
                      itemExtent:
                          (kLeagueCardPadding.vertical + kHeightOfEachInTable) *
                              totalComp.length,
                      children: [
                        SizedBox(
                          height: (kLeagueCardPadding.vertical +
                                  kHeightOfEachInTable) *
                              totalComp.length,
                          width: constraints.maxWidth,
                          child: Stack(
                            children: tableMaker(
                                totalComp,
                                compInfo,
                                widget.match,
                                _totalHomeAway,
                                context,
                                teamLine),
                          ),
                        ),
                      ],
                      // tableMaker(totalComp, compInfo, widget.match,
                      //     _totalHomeAway, context, teamLine),
                    );
                  },
                )),
              ]),
            ),
            Container(
              // width: MediaQuery.of(context).size.width,
              height: kLeagueHeaderAreaHeight,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.9),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 2), // changes position of shadow
                ),
              ]),
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    totalHomeAway(totalHomeAwayChanger, _totalHomeAway),
                    TeamTableRow(
                        position: '#',
                        teamName: 'Team',
                        playedGames: 'Pl',
                        won: 'W',
                        draw: 'D',
                        lost: 'L',
                        goalForAgainst: '+/-',
                        goalDifference: 'GD',
                        points: 'Pts',
                        style: Theme.of(context).textTheme.headline4),
                  ]),
            ),
          ],
        ));
  }
}
