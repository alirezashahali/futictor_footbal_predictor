import 'dart:convert' as convert;

String urlBuilderForNextWeek(clubSettings) {
  String _dateFrom = DateTime.now().toUtc().toString().split(" ")[0];
  String _dateTo =
      DateTime.now().toUtc().add(Duration(days: 7)).toString().split(" ")[0];

  return urlTextBuilder(clubSettings, _dateFrom, _dateTo);
}

String urlTextBuilder(clubSettings, dateFrom, dateTo) {
  String _comps = '';

  List _clubSettingsList = clubSettings.keys.toList();
  for (int i = 0; i < _clubSettingsList.length; i++) {
    if (clubSettings[_clubSettingsList[i]]) {
      if (i == _clubSettingsList.length - 1) {
        _comps += _clubSettingsList[i];
      } else {
        _comps += _clubSettingsList[i] + ',';
      }
    }
  }
  var _url = 'https://api.football-data.org/v2/matches/?'
          'dateFrom=' +
      dateFrom.toString() +
      '&' +
      'dateTo=' +
      dateTo.toString();
  print(_url);
  return _url;
}

List<List> batchiseDates(Map info) {
  final difference = info['minDate'].difference(info['maxDate']).inDays;
  //if bigger than 10 should make distribute it to more req cause api does not allow more than 10 days of difference
  //but i change my mind cause now the app does not allow for more than 7 days of prediction so it is useless
}

double pointGiver(result, pred) {
  //for results 1 is home team winning, 0 draw, -1 homeTeam loosing
  // Map realRes = {
  //   'result': ,
  //   'goalDiff': ,
  //   'goalsSum': ,
  // }
  // Map predRes = {
  //   'result': ,
  //   'goalDiff': ,
  //   'goalsSum': ,
  // }
  Map _resultAdded = supplierHelper(result);
  Map _predAdded = supplierHelper(pred);
  return pointCal(_resultAdded, _predAdded);
}

//adds result, goalSum and goalDiff
Map supplierHelper(Map input) {
  Map _outPut = {...input};
  int _diffTeams = input['homeTeam'] - input['awayTeam'];

  if (_diffTeams > 0) {
    _outPut['result'] = 1;
  } else if (_diffTeams == 0) {
    _outPut['result'] = 0;
  } else {
    _outPut['result'] = -1;
  }

  int _goalSums = input['homeTeam'] + input['awayTeam'];
  _outPut['goalSum'] = _goalSums;

  _outPut['goalDiff'] = _diffTeams;
  return {..._outPut};
}

double pointCal(result, pred) {
  //w_l win or lose, GD goalDiff, GS goalSum, res result correct 1lw 1level wrong win or loose and then draw
  Map<String, double> _points = {
    'fulCorrect': 3,
    'w_l_GD_correct': 1.5,
    'w_l_res_correct': 1,
    'w_l_1lw_correct': -2.5,
    'd_res_correct': 1,
    'd_fulWrong': -2,
    'fulWrong': -3
  };
  //win or loose
  if (pred['result'] == 1 || pred['result'] == -1) {
    //result is currectly predicted
    if (pred['result'] == result['result']) {
      // goal difference is correct
      if (result['goalDiff'] == pred['goalDiff']) {
        //goalSum is equal
        if (result['goalSum'] == pred['goalSum']) {
          return _points['fulCorrect'];
        } else {
          return _points['w_l_GD_correct'];
        }
      } else {
        return _points['w_l_res_correct'];
      }
    } else {
      if ((pred['result'] - result['result']).abs() > 1) {
        return _points['fulWrong'];
      } else {
        return _points['w_l_1lw_correct'];
      }
    }
    // draw
  } else {
    //result is right
    if (pred['result'] == result['result']) {
      if (pred['goalSum'] == result['goalSum']) {
        return _points['fulCorrect'];
      } else {
        return _points['d_res_correct'];
      }
    } else {
      return _points['d_fulWrong'];
    }
  }
}

bool isTodayFromUtcDate(utcDate) {
  return (DateTime.parse(utcDate).toString().split(' ')[0] ==
      DateTime.now().toUtc().toString().split(' ')[0]);
}

String encode(input) {
  return convert.jsonEncode(input);
}

dynamic decode(String input) {
  return convert.jsonDecode(input);
}
