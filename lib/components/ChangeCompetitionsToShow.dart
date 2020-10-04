import 'package:flutter/material.dart';
import 'package:futictor_football_predictor/Models/Predictions.dart';
import 'package:futictor_football_predictor/utils/constants.dart';
import 'package:provider/provider.dart';

import '../Models/Predictions.dart';

class ChangeCompetitionsToShow extends StatefulWidget {
  @override
  _ChangeCompetitionsToShowState createState() =>
      _ChangeCompetitionsToShowState();
}

class _ChangeCompetitionsToShowState extends State<ChangeCompetitionsToShow> {
  @override
  Widget build(BuildContext context) {
    Predictions _leaguesToWatchClass =
        Provider.of<Predictions>(context, listen: true);
    Map _leaguesToWatch = _leaguesToWatchClass.getClubSettings;
    List _keys = _leaguesToWatch.keys.toList();
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.landscape) {
          return GridView.count(
            childAspectRatio: MediaQuery.of(context).size.width / 70.0,
            crossAxisCount: 2,
            children: List.generate(
                _leaguesToWatch.length,
                (int index) => eachItemBuilder(_leaguesToWatch, _keys, index,
                    context, _leaguesToWatchClass)),
          );
        } else {
          return ListView.builder(
              padding: const EdgeInsets.only(
                  left: 2 * kPadLeft, top: kPadTop, right: 2 * kPadLeft),
              itemCount: _leaguesToWatch.length,
              itemBuilder: (BuildContext context, int index) {
                return eachItemBuilder(_leaguesToWatch, _keys, index, context,
                    _leaguesToWatchClass);
              });
        }
      },
    );
  }
}

Widget eachItemBuilder(
    _leaguesToWatch, _keys, index, context, _leaguesToWatchClass) {
  String leagueName;
  switch (_keys[index]) {
    case 'PL':
      leagueName = 'Premier League';
      break;
    case 'CL':
      leagueName = 'Champions League';
      break;
    case 'PD':
      leagueName = 'La Liga';
      break;
    case 'SA':
      leagueName = 'Serie A';
      break;
    case 'BL1':
      leagueName = 'Bundes Liga';
      break;
    default:
      leagueName = 'Unknown';
      break;
  }
  return Container(
    height: 40.0,
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Padding(
        padding: EdgeInsets.only(left: kPadLeft),
        child: Text(
          leagueName,
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
      ),
      Switch(
          activeColor: Theme.of(context).primaryColor,
          value: _leaguesToWatch[_keys[index]],
          onChanged: (value) =>
              _leaguesToWatchClass.clubSettingsToggler(_keys[index]))
    ]),
  );
}
