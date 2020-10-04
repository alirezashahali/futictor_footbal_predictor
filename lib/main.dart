import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import './Models/Predictions.dart';
import './screens/PointsScreen.dart';
import './screens/PredictionScreen.dart';
import './screens/SettingsScreen.dart';
import './utils/constants.dart';

void main() async {
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  final Future<Database> database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'futictor_database.db'),
    // When the database is first created, create a table to store futictor data.
    onCreate: (db, version) {
      db.execute(
        "CREATE TABLE history(id INTEGER PRIMARY KEY, home BLOB, away BLOB, pred BLOB, result BLOB, utcDate TEXT, point INTEGER)",
      );
      db.execute(
          "CREATE TABLE preds(id INTEGER PRIMARY KEY, homeTeam INTEGER, awayTeam INTEGER, utcDate TEXT)");
      db.execute("CREATE TABLE settings(id INTEGER PRIMARY KEY, clubs BLOB)");
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );
  runApp(ChangeNotifierProvider(
    create: (context) => Predictions(database),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        accentColor: kInfoColor,
        textTheme: TextTheme(
            bodyText1: TextStyle(fontSize: 16.0),
            bodyText2: TextStyle(fontSize: 20.0)),
      ),
      initialRoute: PredictionScreen.route,
      routes: {
        PredictionScreen.route: (_) => PredictionScreen(),
        PointsScreen.route: (_) => PointsScreen(),
        SettingsScreen.route: (_) => SettingsScreen()
      },
      // home: PredictionScreen(),
    );
  }
}
