import 'package:flutter/material.dart';
import 'package:futictor_football_predictor/utils/constants.dart';
import 'package:provider/provider.dart';

import '../Models/Predictions.dart';
import '../components/PointCard.dart';

// shows your points from todays games and how much are impending
// also has the option to pick yesterday/last week/previous years
class PointsScreen extends StatelessWidget {
  static String route = 'Points';
  @override
  Widget build(BuildContext context) {
    var history = Provider.of<Predictions>(context).history;
    Map _datasWith = datasFromHis(history);
    List datas = _datasWith['datas'];
    double pointsAll = _datasWith['pointsAll'];
    if (datas.length == 0) {
      return Scaffold(
        appBar: AppBar(title: Text('Points')),
        body: Center(
          child: Text(
            'You have no results for your prediction to show',
            style: kInfoText,
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(title: Text('Points')),
        body: Column(
          children: [
            Container(
              child: Text(
                pointsAll.toString() + ' Points',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            Container(
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: datas.length,
                    itemBuilder: (BuildContext context, int index) {
                      return PointCard(datas[index]);
                    }))
          ],
        ),
      );
    }
  }
}

Map datasFromHis(Map history) {
  print('history length');
  print(history.length);
  double pointsAll = 0.0;
  List placeHolder = [];
  history.forEach((key, value) {
    placeHolder.add(value);
    pointsAll += value['point'];
  });
  placeHolder.sort((a, b) =>
      DateTime.parse(a['utcDate']).compareTo(DateTime.parse(b['utcDate'])));
  return {'datas': placeHolder, 'pointsAll': pointsAll};
}
