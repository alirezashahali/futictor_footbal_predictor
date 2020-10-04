// import 'package:flutter/material.dart';

int dateComparer(a, b) {
  return 0;
}

Future infoAddingProcess(Preds) async {
  // Predictions Preds = Provider.of<Predictions>(context);
  await Preds.matchesPopulate();
  await Preds.popInfoForHisReq();
  await Preds.CheckForShouldDelete();
}
