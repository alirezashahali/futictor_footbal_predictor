import 'package:flutter/material.dart';
import 'package:futictor_football_predictor/components/ChangeCompetitionsToShow.dart';

// place for picking some special competitions that you are
// intrested in and maybe clubs
class SettingsScreen extends StatefulWidget {
  static String route = 'Settings';
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.check,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: ChangeCompetitionsToShow(),
    );
  }
}
