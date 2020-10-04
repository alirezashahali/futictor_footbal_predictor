import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../utils/constants.dart';

Widget clubName(name, context) {
  return Container(
    width: MediaQuery.of(context).size.width / 3,
    child: Text(
      name,
      style: Theme.of(context).textTheme.bodyText1,
      maxLines: 2,
      textAlign: TextAlign.center,
    ),
  );
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
    return Row(
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
              predictions['home'].toString() +
              '-' +
              predictions['away'].toString(),
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
            'Your prediction: ' + pred['homeTeam'] + '-' + pred['awayTeam'],
            style: kInfoText,
          ),
          if (hisI['point'] == 3)
            Icon(
              MaterialCommunityIcons.check_all,
              color: kPrimaryColor,
              size: kIconSize,
            ),
          if (hisI['point'] > 0)
            Icon(
              MaterialCommunityIcons.check,
              color: kSoSoColor,
              size: kIconSize,
            ),
          if (hisI['point'] == -3)
            Icon(
              MaterialCommunityIcons.skull_crossbones,
              color: kDangerColor,
              size: kIconSize,
            ),
          if (hisI['point'] < 0)
            Icon(
              MaterialCommunityIcons.skull_crossbones,
              color: kSoSoColor,
              size: kIconSize,
            )
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
