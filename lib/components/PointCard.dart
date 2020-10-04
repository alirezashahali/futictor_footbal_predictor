import 'package:flutter/material.dart';

class PointCard extends StatelessWidget {
  var data;
  PointCard(this.data);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      child: Center(
        child: Row(children: [
          Row(
            children: [Text('Earned Points: '), Text(data['point'].toString())],
          ),
          Column(
            children: [
              Row(
                children: [
                  Text('result:'),
                  Text(data['result']['homeTeam'].toString() +
                      "-" +
                      data['result']['awayTeam'].toString())
                ],
              ),
              Row(children: [
                Text('prediction:'),
                Text(data['pred']['homeTeam'].toString() +
                    '-' +
                    data['pred']['awayTeam'])
              ])
            ],
          )
        ]),
      ),
    );
  }
}
