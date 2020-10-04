import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

import '../Models/Predictions.dart';
import 'PredictionCard.dart';

class DayToPredict extends StatelessWidget {
  final DateTime todayDate;
  final int dayToAdd;
  DayToPredict(this.todayDate, this.dayToAdd);

  Future infoAddingProcess(Preds) async {
    // Predictions Preds = Provider.of<Predictions>(context);
    await Preds.matchesPopulate();
    await Preds.popInfoForHisReq();
    await Preds.CheckForShouldDelete();
  }

  @override
  Widget build(BuildContext context) {
    final String neededDate =
        todayDate.add(Duration(days: dayToAdd)).toString().split(' ')[0];
    Predictions preds = Provider.of<Predictions>(context);
    if (preds.fetching) {
      return Center(child: CircularProgressIndicator());
    }
    List matchesToShow = preds.matches
        .where(
            (match) => match['utcDate'].toString().split("T")[0] == neededDate)
        .toList();
    if (matchesToShow.length == 0) {
      return Center(
        child: Row(
          children: [
            Text('No match for today to be shown!'),
            Icon(
              MaterialCommunityIcons.emoticon_sad,
              color: Colors.amber,
              size: 50.0,
            )
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        ),
      );
    }

    return Container(
        child: RefreshIndicator(
      onRefresh: () => infoAddingProcess(preds),
      child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(8),
          itemCount: matchesToShow.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 100.0,
              child: Center(child: PredictionCard(matchesToShow[index])),
            );
          }),
    ));
  }
}
