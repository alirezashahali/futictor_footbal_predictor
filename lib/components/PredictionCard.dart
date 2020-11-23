import 'package:flutter/material.dart';
import 'package:futictor_football_predictor/Models/Predictions.dart';
import 'package:provider/provider.dart';

import './PredictionCardUtils.dart';

class PredictionCard extends StatefulWidget {
  final Map match;
  PredictionCard(this.match);
  @override
  _PredictionCardState createState() => _PredictionCardState();
}

class _PredictionCardState extends State<PredictionCard> {
  int _home;
  int _away;
  bool _isInit;

  final homeController = TextEditingController();
  final awayController = TextEditingController();

  void commitingPred(Pred) {
    Pred.populatePreds(widget.match, _away, _home);
    homeController.text = Pred.preds[widget.match['id']]['homeTeam'].toString();
    awayController.text = Pred.preds[widget.match['id']]['awayTeam'].toString();
  }

  void depop(Pred) {
    Pred.depopulatePreds(widget.match);
    if (Pred.preds[widget.match['id']] != null) {
      homeController.text =
          Pred.preds[widget.match['id']]['homeTeam'].toString();
      awayController.text =
          Pred.preds[widget.match['id']]['awayTeam'].toString();
    }
  }

  void stateToController(Predictions Pred) {
    if (Pred.preds[widget.match['id']] != null && !_isInit) {
      homeController.text =
          Pred.preds[widget.match['id']]['homeTeam'].toString();
      awayController.text =
          Pred.preds[widget.match['id']]['awayTeam'].toString();
      setState(() {
        _isInit = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _isInit = false;
    });
    homeController.addListener(() {
      setState(() {
        if (homeController.text.length == 0) {
          _home = null;
        } else {
          _home = int.parse(homeController.text);
        }
      });
    });
    awayController.addListener(() {
      setState(() {
        if (awayController.text.length == 0) {
          _away = null;
        } else {
          _away = int.parse(awayController.text);
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    homeController.dispose();
    awayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Predictions Pred = Provider.of<Predictions>(context);
    print(Pred.preds.length);
    // print(Pred.preds[widget.match['id']]['homeTeam'].toString());
    stateToController(Pred);

    if (widget.match['status'] != 'SCHEDULED' &&
        widget.match['status'] != 'FINISHED') {
      print(widget.match['status']);
    }

    return Container(
      // decoration: BoxDecoration(border: Border),
      child: Column(children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              clubName(widget.match['homeTeam'], context),
              matchTime(widget.match, context),
              clubName(widget.match['awayTeam'], context)
            ],
          ),
        ),
        if (widget.match['status'] == 'SCHEDULED')
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Container(
              width: 60.0,
              height: 30.0,
              child: predField(
                  homeController,
                  _away,
                  () {
                    commitingPred(Pred);
                  },
                  'Home',
                  _home,
                  () {
                    depop(Pred);
                  }),
            ),
            // away team pred
            Container(
                width: 10.0,
                child: Text(
                  'v',
                  style: TextStyle(color: Colors.grey),
                )),
            Container(
              width: 60.0,
              height: 30.0,
              child: predField(
                  awayController,
                  _home,
                  () {
                    commitingPred(Pred);
                  },
                  'Away',
                  _away,
                  () {
                    depop(Pred);
                  }),
            )
          ]),
        if (widget.match['status'] == 'POSTPONED') PostponedGame(),
        //if match is in play
        if (widget.match['status'] != 'SCHEDULED' &&
            widget.match['status'] != 'FINISHED' &&
            widget.match['status'] != 'POSTPONED')
          WaitingForFinalResult(
              widget.match['id'], Pred.preds[widget.match['id']]),
        // if match is done
        if (widget.match['status'] == 'FINISHED')
          FinishedGame(Pred.history, widget.match['id'])
      ]),
    );
  }
}
