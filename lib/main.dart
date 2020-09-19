import 'package:flutter/material.dart';

import './screens/PointsScreen.dart';
import './screens/PredictionScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: PredictionScreen.route,
      routes: {
        PredictionScreen.route: (_) => PredictionScreen(),
        PointsScreen.route: (_) => PointsScreen(),
      },
      // home: PredictionScreen(),
    );
  }
}
