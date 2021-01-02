import 'package:flutter/material.dart';
import 'package:futictor_football_predictor/Models/Predictions.dart';
import 'package:provider/provider.dart';

import './../Models/MatchScreenArgs.dart';
import './../components/PredictionPart.dart';
import './../screens/MatchScreenNewer.dart';
import './PredictionCardUtils.dart';

class PredictionCard extends StatelessWidget {
  final Map match;
  PredictionCard({Key key, this.match}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Predictions Pred = Provider.of<Predictions>(context);

    if (match['status'] != 'SCHEDULED' && match['status'] != 'FINISHED') {
      // print(widget.match['status']);
    }

    return Container(
      // margin: EdgeInsets.only(bottom: 10.0),
      // decoration: BoxDecoration(border: Border),
      child: Column(children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.pushNamed(context, MatchScreenNewer.route,
                arguments: MatchScreenArgs(
                    compId: match['competition']['id'], match: match
                    // utcDate:
                    ));
          },
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  clubName(
                      match['homeTeam'], match['homeTeamId'], false, context),
                  matchTime(match, context),
                  clubName(
                      match['awayTeam'], match['awayTeamId'], true, context)
                ],
              ),
            ),
          ),
        ),
        PredictionPart(match),
        if (match['status'] == 'POSTPONED') PostponedGame(),
        //if match is in play
        if (match['status'] != 'SCHEDULED' &&
            match['status'] != 'FINISHED' &&
            match['status'] != 'POSTPONED')
          WaitingForFinalResult(match['id'], Pred.preds[match['id']]),
        // if match is done
        if (match['status'] == 'FINISHED')
          FinishedGame(Pred.history, match['id'])
      ]),
    );
  }
}
