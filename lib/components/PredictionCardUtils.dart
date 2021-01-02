import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../utils/constants.dart';

Widget clubName(name, id, bool rightLeft, context) {
  var holeWidth = MediaQuery.of(context).size.width / 3;
  return Container(
    width: holeWidth,
    child: rightLeft
        ? Row(children: [
            clubWidg(holeWidth / 4, id),
            textWidg(holeWidth, name, context),
          ])
        : Row(children: [
            textWidg(holeWidth, name, context),
            clubWidg(holeWidth / 4, id)
          ]),
  );
}

Widget textWidg(double holeWidth, String name, BuildContext context) {
  return Container(
    width: 2 * holeWidth / 3,
    padding: EdgeInsets.only(right: 5.0),
    child: Text(
      name,
      style: Theme.of(context).textTheme.bodyText1,
      maxLines: 2,
      textAlign: TextAlign.center,
    ),
  );
}

Widget clubWidg(double holeWidth, int id) {
  return Container(
      width: holeWidth,
      height: holeWidth,
      child: SvgPicture.network(
        'https://crests.football-data.org/' + id.toString() + '.svg',
        placeholderBuilder: (BuildContext context) => Container(
          width: holeWidth,
          height: holeWidth,
          child: SvgPicture.asset('lib/assets/clubSieldEnhanced.svg',
              semanticsLabel: 'Acme Logo'),
        ),
      ));
}

Widget predField(controller, otherState, Function commitingPred, String label,
    selfState, Function depop) {
  return Focus(
    child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [
          WhitelistingTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(2)
        ],
        maxLines: 1,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
        )),
    onFocusChange: (hasFocus) {
      if (!hasFocus) {
        if (otherState != null) {
          commitingPred();
        }
        if (selfState == null && otherState == null) {
          depop();
        }
      }
    },
  );
}

void stateToController(controller, state) {
  if (state == null) {
    controller.text = "";
  } else {
    controller.text = state.toString();
  }
}

Widget matchTime(match, context) {
  if (DateTime.parse(match['utcDate']).toLocal().isAfter(DateTime.now())) {
    String _reqDate = DateTime.parse(match['utcDate'])
        .toLocal()
        .toString()
        .split(" ")[1]
        .split(".")[0];
    String _reqDate1 = _reqDate.split(":")[0];
    String _reqDate2 = _reqDate.split(":")[1];

    return Text(_reqDate1 + ":" + _reqDate2,
        style: Theme.of(context).textTheme.bodyText1);
  } else if (match['status'] == 'FINISHED') {
    // print(match['']);
    return Text(
      match['score']['fullTime']['homeTeam'].toString() +
          ' ' +
          '- ' +
          match['score']['fullTime']['awayTeam'].toString(),
      style: TextStyle(
        fontSize: 16.0,
        color: Theme.of(context).primaryColor,
      ),
    );
  } else {
    return Icon(
      MaterialCommunityIcons.progress_clock,
      size: 22.0,
      color: Theme.of(context).primaryColor,
    );
  }
}

Widget PostponedGame() {
  return Column(
    children: [
      Text(
        'Sorry this game was postponed!',
        style: kInfoText,
      ),
      Text("Maybe it wasn't meant to be", style: kInfoText)
    ],
    mainAxisAlignment: MainAxisAlignment.spaceAround,
  );
}

Widget WaitingForFinalResult(matchId, predictions) {
  if (predictions == null) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Text(
        'You did not participate for this game!',
        style: kInfoText,
      )
    ]);
  } else {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: Text(
            'waiting for game to finish!',
            style: kInfoText,
          ),
        ),
        Text(
          'your prediction' +
              ' ' +
              predictions['homeTeam'].toString() +
              '-' +
              predictions['awayTeam'].toString(),
          style: kInfoText,
        )
      ],
    );
  }
}

Widget FinishedGame(Map history, int id) {
  if (history[id] != null) {
    var hisI = history[id];
    var pred = hisI['pred'];
    return Padding(
      padding: EdgeInsets.only(left: kPadLeft, top: kPadTop),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'Your prediction: ' +
                pred['homeTeam'].toString() +
                '-' +
                pred['awayTeam'].toString(),
            style: kInfoText,
          ),
        ],
      ),
    );
  } else {
    return Text(
      "Unfortunately you didn't take part in this one!",
      style: kInfoText,
    );
  }
}
