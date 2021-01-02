import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './../Models/Predictions.dart';
import './../components/PredictionCardUtils.dart';

class PredictionPart extends StatefulWidget {
  final Map match;
  PredictionPart(this.match);
  @override
  _PredictionPartState createState() => _PredictionPartState();
}

class _PredictionPartState extends State<PredictionPart> {
  int _home;
  int _away;
  bool _isInit;

  final homeController = TextEditingController();
  final awayController = TextEditingController();

  // after changing textEditing controllers text implements changes to Pred
  void commitingPred(Predictions Pred) {
    if (_away != null && _home != null) {
      Pred.populatePreds(widget.match, _away, _home);
      homeController.text =
          Pred.preds[widget.match['id']]['homeTeam'].toString();
      awayController.text =
          Pred.preds[widget.match['id']]['awayTeam'].toString();
    }
  }

  // trys to depopulate if you delete both of textEditingControllers
  void depop(Predictions Pred) {
    Pred.depopulatePreds(widget.match);
    if (Pred.preds[widget.match['id']] != null) {
      homeController.text =
          Pred.preds[widget.match['id']]['homeTeam'].toString();
      awayController.text =
          Pred.preds[widget.match['id']]['awayTeam'].toString();
    }
  }

  //from state populates TextEditing controllers
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
          // print('check homeController');
          // print(homeController.text.length);
          _home = null;
        } else {
          // print('check homeController 2');
          // print(homeController.text);
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
    stateToController(Pred);
    if (widget.match['status'] == 'SCHEDULED') {
      return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Container(
          width: 60.0,
          height: 30.0,
          // predField is a function that tries to implement the hole system something complicated that i built pretty impressive
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
      ]);
    } else {
      return Container();
    }
  }
}
