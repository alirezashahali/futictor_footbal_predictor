import 'package:flutter/material.dart';
import 'package:futictor_football_predictor/screens/PointsScreen.dart';

class PredictionScreen extends StatelessWidget {
  static String route = 'Predictions';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Predictions'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.calendar_today,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, PointsScreen.route);
            },
          )
        ],
      ),
    );
  }
}
