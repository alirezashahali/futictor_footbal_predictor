import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:futictor_football_predictor/Models/Predictions.dart';
import 'package:futictor_football_predictor/components/DayToPredict.dart';
import 'package:provider/provider.dart';

import './PointsScreen.dart';
import './SettingsScreen.dart';

// first screen that comes up and shows todays matches and your predictions
// it is also prefered to add a rolling topbar to have the choice to see future games
class PredictionScreen extends StatefulWidget {
  static String route = 'Predictions';
  @override
  _PredictionScreenState createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  var _isInit = true;
  DateTime todayDate = DateTime.now().toUtc();

  Future infoAddingProcess() async {
    Predictions Preds = Provider.of<Predictions>(context);
    await Preds.settingsReader();
    await Preds.matchesPopulate();
    await Preds.initPreds();
    await Preds.initHistory();
    Preds.popInfoForHisReq();
    Preds.CheckForShouldDelete();
  }

  void makeToday() {
    setState(() {
      todayDate = DateTime.now().toUtc();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    makeToday();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      infoAddingProcess();
      setState(() {
        _isInit = false;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // List matches = preds.matches.where((match) => match);
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          leading: Icon(MaterialCommunityIcons.crystal_ball),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.calendar_today,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, PointsScreen.route);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, SettingsScreen.route);
              },
            )
          ],
          title: Text('Predictions'),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            tabs: [
              Tab(child: Text('Today')),
              Tab(child: Text('Tommorow')),
              Tab(child: dayTexter(2, todayDate)),
              Tab(child: dayTexter(3, todayDate)),
              Tab(child: dayTexter(4, todayDate)),
              Tab(child: dayTexter(5, todayDate)),
              Tab(child: dayTexter(6, todayDate))
            ],
          ),
        ),
        body: TabBarView(
          children: [
            DayToPredict(todayDate, 0),
            DayToPredict(todayDate, 1),
            DayToPredict(todayDate, 2),
            DayToPredict(todayDate, 3),
            DayToPredict(todayDate, 4),
            DayToPredict(todayDate, 5),
            DayToPredict(todayDate, 6)
          ],
        ),
      ),
    );
//     return Scaffold(
//       resizeToAvoidBottomPadding: true,
//       appBar: AppBar(
//         title: Text('Predictions'),
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(
//               Icons.calendar_today,
//               color: Colors.white,
//             ),
//             onPressed: () {
//               Navigator.pushNamed(context, PointsScreen.route);
//             },
//           ),
//           IconButton(
//             icon: Icon(
//               Icons.settings,
//               color: Colors.white,
//             ),
//             onPressed: () {
//               Navigator.pushNamed(context, SettingsScreen.route);
//             },
//           )
//         ],
//       ),
//       body: preds.fetching
//           ? Center(
//               child: CircularProgressIndicator(),
//             )
//           : Container(
//               child: ListView.builder(
//                   padding: const EdgeInsets.all(8),
//                   itemCount: preds.matches.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     return Container(
//                       height: 90.0,
//                       child: Center(
//                           child: PredictionCard(preds.matches[index], preds)),
//                     );
//                   })),
//     );
//   }
// }
  }
}

Map<int, String> monthName = {
  1: 'Jan',
  2: 'Feb',
  3: 'Mar',
  4: 'Apr',
  5: 'May',
  6: 'June',
  7: 'July',
  8: 'Aug',
  9: 'Sept',
  10: 'Oct',
  11: 'Nov',
  12: 'Dec'
};

Widget dayTexter(dayToadd, todayDate) {
  return Text(monthName[todayDate.add(Duration(days: dayToadd)).month] +
      ' ' +
      todayDate.add(Duration(days: dayToadd)).day.toString());
}
