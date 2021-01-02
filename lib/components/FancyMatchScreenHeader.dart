import 'dart:math';

import 'package:flutter/material.dart';
import 'package:futictor_football_predictor/utils/constants.dart';

import './../components/PredictionCardUtils.dart';
import './../components/TimeOrResult.dart';

class FancyMatchScreenHeader extends SliverPersistentHeaderDelegate {
  final double mxExtent;
  final double mnExtent;
  final TabBar tabList;
  final Map match;

  FancyMatchScreenHeader(
      {@required this.mxExtent,
      @required this.mnExtent,
      this.tabList,
      this.match});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // TODO: implement build
    final double headDiff = maxExtent - minExtent;
    final double paddingVertical = max(headDiff / 2 - shrinkOffset / 2, 5.0);
    final double calcWidth =
        max(minExtent / 2, headDiff - shrinkOffset / 2 - 5.0);
    // get tab index to see if the index is 1 then add another Container under the fucking appBar
    // final int tabIndex = DefaultTabController.of(context).index;
    // print(shrinkOffset);
    // print(headDiff - shrinkOffset / 2);
    return Container(
      color: kPrimaryColor,
      child: AppBar(
        elevation: 5.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        bottom: this.tabList,
        flexibleSpace: Container(
            padding: EdgeInsets.symmetric(
                vertical: paddingVertical, horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                clubWidg(calcWidth, match['homeTeamId']),
                TimeOrResult(match['utcDate'], match['score'], match['status']),
                clubWidg(calcWidth, match['awayTeamId'])
              ],
            )),
      ),
    );
    // if (tabIndex == 1)
    //   Positioned(
    //       top: calcWidth + paddingVertical + 10.0,
    //       child: Container(child: Text('suckers')));
  }

  @override
  double get maxExtent => mxExtent;

  @override
  double get minExtent => mnExtent;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    print('oldDelegate');
    print(oldDelegate);
    return false;
  }
}

// class NetworkingPageHeader implements SliverPersistentHeaderDelegate {
//   NetworkingPageHeader({
//     this.minExtent,
//     @required this.maxExtent,
//   });
//   final double minExtent;
//   final double maxExtent;
//
//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Stack(
//       fit: StackFit.expand,
//       children: [
//         Image.asset(
//           'assets/ronnie-mayo-361348-unsplash.jpg',
//           fit: BoxFit.cover,
//         ),
//         Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.transparent, Colors.black54],
//               stops: [0.5, 1.0],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               tileMode: TileMode.repeated,
//             ),
//           ),
//         ),
//         Positioned(
//           left: 16.0,
//           right: 16.0,
//           bottom: 16.0,
//           child: Text(
//             'Lorem ipsum',
//             style: TextStyle(
//               fontSize: 32.0,
//               color: Colors.white.withOpacity(titleOpacity(shrinkOffset)),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   double titleOpacity(double shrinkOffset) {
//     // simple formula: fade out text as soon as shrinkOffset > 0
//     return 1.0 - max(0.0, shrinkOffset) / maxExtent;
//     // more complex formula: starts fading out text when shrinkOffset > minExtent
//     //return 1.0 - max(0.0, (shrinkOffset - minExtent)) / (maxExtent - minExtent);
//   }
//
//   @override
//   bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
//     return true;
//   }
//
//   @override
//   FloatingHeaderSnapConfiguration get snapConfiguration => null;
// }
