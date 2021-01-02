import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import './../utils/constants.dart';

class TeamTableRow extends StatelessWidget {
  String position;
  String crestUrl;
  String teamName;
  String playedGames;
  String won;
  String draw;
  String lost;
  String goalForAgainst;
  String goalDifference;
  String points;
  TextStyle style;

  TeamTableRow(
      {@required this.position,
      this.crestUrl,
      @required this.teamName,
      @required this.playedGames,
      @required this.won,
      @required this.draw,
      @required this.lost,
      @required this.goalForAgainst,
      @required this.goalDifference,
      @required this.points,
      @required this.style});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kHeightOfEachInTable,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                position,
                style: style,
              ),
            ),
          ),
          Expanded(
              flex: 2,
              child: Center(
                child: Row(children: [
                  Expanded(
                    child: Container(),
                    flex: 1,
                  ),
                  Expanded(
                    flex: 4,
                    child: LayoutBuilder(builder:
                        (BuildContext context, BoxConstraints constraints) {
                      if (crestUrl == null) {
                        return Container();
                      }
                      return Container(
                        width: constraints.maxWidth,
                        height: constraints.maxWidth,
                        child: SvgPicture.network(
                          crestUrl,
                          placeholderBuilder: (BuildContext context) =>
                              Container(
                            width: constraints.maxWidth,
                            height: constraints.maxWidth,
                            child: SvgPicture.asset(
                                'lib/assets/clubSieldEnhanced.svg',
                                semanticsLabel: 'Acme Logo'),
                          ),
                        ),
                      );
                    }),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  )
                ]),
              )),
          Expanded(
            flex: 6,
            child: Text(
              teamName,
              maxLines: 1,
              style: style,
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                playedGames,
                style: style,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                won,
                style: style,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                draw,
                style: style,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                lost,
                style: style,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                goalForAgainst,
                style: style,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                goalDifference,
                style: style,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                points,
                style: style,
              ),
            ),
          )
        ],
      ),
    );
  }
}
