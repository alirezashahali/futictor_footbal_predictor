import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:futictor_football_predictor/secretie/secret.secret.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

import './utils/PredictionsUtils.dart';
import '../utils/constants.dart';

class Predictions with ChangeNotifier {
  final database;
  String _secretKey;
  Predictions(this.database) {
    _secretKeyInitializer();
  }

  Future<void> _secretKeyInitializer() async {
    _secretKey = await keeperOfSecrets().secretGiver();
  }

  bool _fetching = true;

  bool get fetching {
    return _fetching;
  }

  //map of results for games
  Map _preds = {};
  Map get preds {
    return {..._preds};
  }

  Future<void> initPreds() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('preds');
    Map returnie = {};

    for (Map pred in maps) {
      returnie[pred['id']] = {
        'awayTeam': pred['awayTeam'],
        'homeTeam': pred['homeTeam'],
        'utcDate': pred['utcDate']
      };
    }
    _preds = returnie;
  }

  Future<void> _insertPreds(Map data) async {
    final Database db = await database;
    await db.insert(
      'preds',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _deletePreds(id) async {
    final Database db = await database;
    await db.delete(
      'preds',
      // Use a `where` clause to delete a specific dog.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  void populatePreds(match, int away, int home) {
    // print('populatePreds');
    var _matchTime = DateTime.parse(match['utcDate']).toLocal();
    if (DateTime.now().isBefore(_matchTime)) {
      _preds[match['id']] = {
        'awayTeam': away,
        'homeTeam': home,
        'utcDate': match['utcDate']
      };
      Map<String, dynamic> data = {
        'id': match['id'],
        'awayTeam': away,
        'homeTeam': home,
        'utcDate': match['utcDate'],
      };
      notifyListeners();
      _insertPreds(data);
    }
  }

  void depopulatePreds(match) {
    // print('depopulate Preds');
    var _matchTime = DateTime.parse(match['utcDate']).toLocal();
    if (DateTime.now().isBefore(_matchTime) && _preds[match['id']] != null) {
      _preds.remove(match['id']);
      _deletePreds(match['id']);
    }
  }

  //name of clubs to be watched
  Map _clubSettings = kClubSettings;

  Future<void> settingsReader() async {
    Database db = await database;
    // _clubSettings = kClubSettings;
    // notifyListeners();
    // // List _maps;
    // await db.insert(
    //   'settings',
    //   {'clubs': convert.jsonEncode(_clubSettings), 'id': 1},
    //   conflictAlgorithm: ConflictAlgorithm.replace,
    // );
    try {
      List _maps = await db.query('settings');
      print(_maps.length);
      if (_maps.length != 0) {
        _clubSettings = convert.jsonDecode(_maps[0]['clubs']);
        notifyListeners();
      } else {
        _clubSettings = kClubSettings;
        notifyListeners();
        await db.insert(
          'settings',
          {'clubs': convert.jsonEncode(_clubSettings), 'id': 1},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    } on DatabaseException {
      print('just entered exception!');
      // await db.insert(
      //   'settings',
      //   {'clubs': convert.jsonEncode(_clubSettings), 'id': 1},
      //   conflictAlgorithm: ConflictAlgorithm.replace,
      // );
    }
  }

  void clubSettingsToggler(key) async {
    _clubSettings[key] = !_clubSettings[key];
    notifyListeners();
    Database db = await database;
    await db.insert(
      'settings',
      {'clubs': convert.jsonEncode(_clubSettings), 'id': 1},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Map<String, bool> get getClubSettings {
    return {..._clubSettings};
  }

  List _matches = [];

  List get matches {
    return _matches;
  }

  void matchesPopulate() async {
    try {
      _fetching = true;
      String url = urlBuilderForNextWeek(_clubSettings);
      var response = await http.get(url, headers: {'X-Auth-Token': kToken});
      // var response = await Dio()
      //     .get(url, options: Options(headers: {'X-Auth-Token': kToken}));
      // print(response.statusCode.toString());
      if (response.statusCode == 200) {
        _fetching = false;
        var jsonResponse = convert.jsonDecode(response.body);
        print(jsonResponse['count'].toString());
        for (var match in jsonResponse['matches']) {
          _matches.add({
            'id': match['id'],
            'competition': {
              'id': match['competition']['id'],
              'name': match['competition']['name']
            },
            'season': match['season'],
            'status': match['status'],
            'matchday': match['matchday'],
            'score': match['score'],
            'homeTeam': match['homeTeam']['name'],
            'awayTeam': match['awayTeam']['name'],
            'utcDate': match['utcDate']
          });
        }
        notifyListeners();
      } else {
        _fetching = false;
      }
    } catch (err) {
      print('error occured');
      print(err);
      _fetching = false;
      throw (err);
    }
  }

  Map _infoForHisReq = {'ids': []};

  Map _history = {};

  Map get history {
    return {..._history};
  }

  Future<void> initHistory() async {
    final Database db = await database;
    final List<Map> maps = await db.query('history');
    Map _returnie = {};
    for (Map map in maps) {
      _returnie[map['id']] = {
        'id': map['id'],
        'home': convert.jsonDecode(map['home']),
        'away': convert.jsonDecode(map['away']),
        'pred': convert.jsonDecode(map['pred']),
        'result': convert.jsonDecode(map['result']),
        'utcDate': map['utcDate'],
        'point': map['point']
      };
    }
    _history = _returnie;
  }

  Future<void> _insertHistory(Map data) async {
    final Database db = await database;
    await db.insert(
      'history',
      {
        'id': data['id'],
        'home': encode(data['homeTeam']),
        'away': encode(data['away']),
        'pred': encode(data['pred']),
        'result': encode(data['score']['fullTime']),
        'utcDate': encode(data['utcDate']),
        'point': encode(data['point'])
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  void popInfoForHisReq() {
    _infoForHisReq = {'ids': []};
    if (_preds.length > 0) {
      DateTime minDate = DateTime.now().toUtc();
      DateTime maxDate;
      _preds.forEach((k, v) {
        DateTime endTime =
            DateTime.parse(v['utcDate']).add(Duration(minutes: kMinToAdd));
        if (endTime.isBefore(DateTime.now().toUtc())) {
          if (endTime.isBefore(minDate)) {
            minDate = endTime;
          }
          if (maxDate == null || endTime.isAfter(maxDate)) {
            maxDate = endTime;
          }
          //check if the game is in matches
          //i made matches in list form so fuck it so time consuming
          _infoForHisReq['ids'] = [..._infoForHisReq['ids'], k];
        }
      });
      _infoForHisReq['minDate'] = minDate;
      _infoForHisReq['maxDate'] = maxDate;
      // batchiseDates(_infoForHisReq);
      popHisFromInfo(_infoForHisReq);
    }
  }

  void popHisFromInfo(_infoForHisReq) async {
    String _url = urlTextBuilder(
        kClubSettings, _infoForHisReq['minDate'], _infoForHisReq['maxDate']);
    try {
      _fetching = true;
      var response = await http.get(_url, headers: {'X-Auth-Token': kToken});
      if (response.statusCode == 200) {
        _fetching = false;
        var jsonResponse = convert.jsonDecode(response.body);
        print(jsonResponse['count'].toString());
        for (var match in jsonResponse['matches']) {
          if (match['status'] == 'FINISHED' && _preds[match['id']] != null) {
            _history[match['id']] = {
              'id': match['id'],
              'home': match['homeTeam'],
              'away': match['away'],
              'pred': _preds[match['id']],
              'result': match['score']['fullTime'],
              'utcDate': match['utcDate'],
              'point':
                  pointGiver(match['score']['fullTime'], _preds[match['id']])
            };

            _insertHistory(_history[match['id']]);

            if (isTodayFromUtcDate(_preds[match['id']]['utcDate'])) {
              _preds[match['id']]['shouldDelete'] = true;
            } else {
              _preds.remove(match['id']);
              _deletePreds(match['id']);
            }
          }
        }
        _infoForHisReq = {'ids': []};
      } else {
        _fetching = false;
      }
    } catch (err) {
      print('error occured!');
      print(err);
      throw (err);
    }
  }

  //check if any _pred member is marked as should delete to be removed if its not a today match
  void CheckForShouldDelete() {
    _preds.forEach((key, value) {
      if (value['shouldDelete'] != null &&
          value['shouldDelete'] &&
          !isTodayFromUtcDate(value['utcDate'])) {
        _preds.remove(key);
        _deletePreds(key);
      }
    });
  }
}
