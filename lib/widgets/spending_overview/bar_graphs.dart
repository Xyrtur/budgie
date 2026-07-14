// Detailed Bar Graph

// For current month / monthly spending page

/*
Information needed

limits of each genre
amount spent in each genre

UI

Animate to slide open on creation or rebuild of this widget

have certain length for whole bar

totalLength

totalLengthMoney = for each genre, += (amountSpent > limit ? amountSpent : limit)

perDollarLength = totalLength / totalLengthMoney


Row(for each genre, 

Container(width: (amountSpent > limit ? limit : amountSpent )* perDollarLength)
Container(width: (amountSpent == limit ? 0 : abs(amountSpent - limit)) * perDollarLength, redOutline and filled if amountSpent - limit > 0, colored outline and empty otherwise)


Row (for each genre, colored dot with amountSpent after)



*/

// Simple Bar Graph

// For all other months in spending overview pages

/*
Information needed

amount spent in each genre

Need perDollarLength depending on other months from spendingOverviewPage

UI

Animate to slide open on creation or rebuild of this widget

Row (for each genre,

Container(width: amountSpent * perDollarLength)



\
*/

// FutureBarGraph

// need limits in each genre

// Grayed out version of graph with only limits

import 'dart:math';

import 'package:budgie/utils/centre.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sizer/sizer.dart';

class BarGraphBoxes extends StatefulWidget {
  const BarGraphBoxes({super.key});

  @override
  State<BarGraphBoxes> createState() => _BarGraphBoxesState();
}

class _BarGraphBoxesState extends State<BarGraphBoxes>
    with TickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    duration: const Duration(milliseconds: 1300),
    vsync: this,
  );
  late final Animation<double> animation = CurvedAnimation(
    parent: controller,
    curve: Curves.fastLinearToSlowEaseIn,
  );

  @override
  void initState() {
    super.initState();
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      axis: Axis.horizontal,
      alignment: Alignment.topCenter,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: barGraphBoxes(),
      ),
    );
  }
}

List<Widget> barGraphBoxes() {
  List<Widget> boxes = [];

  boxes.add(
    Container(
      height: 2.h,
      width: 18.w,
      color: Centre.colors[Random().nextInt(18)],
    ),
  );
  boxes.add(
    Container(
      height: 2.h,
      width: 15.w,
      color: Centre.colors[Random().nextInt(18)],
    ),
  );
  boxes.add(
    Container(
      height: 2.h,
      width: 10.w,
      color: Centre.colors[Random().nextInt(18)],
    ),
  );
  boxes.add(
    Container(
      height: 2.h,
      width: 12.w,
      decoration: BoxDecoration(
        border: Border.all(
          color: Centre.colors[Random().nextInt(18)],
          width: 0.5.w,
        ),
      ),
    ),
  );
  boxes.add(
    Container(
      height: 2.h,
      width: 30.w,
      color: Centre.colors[Random().nextInt(18)],
    ),
  );
  return boxes;
}

List<Widget> barGraphLegend() {
  List<Widget> keys = [];

  keys.add(
    Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 0.6.h,
          width: 0.6.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            color: Centre.colors[Random().nextInt(18)],
          ),

          margin: EdgeInsets.only(right: 1.w),
        ),
        Text("\$570.23"),
      ],
    ),
  );
  keys.add(
    Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 0.6.h,
          width: 0.6.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            color: Centre.colors[Random().nextInt(18)],
          ),
          margin: EdgeInsets.only(right: 1.w),
        ),
        Text("\$57.23"),
      ],
    ),
  );
  keys.add(
    Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 0.6.h,
          width: 0.6.h,
          decoration: BoxDecoration(
            color: Centre.colors[Random().nextInt(18)],
            borderRadius: BorderRadius.circular(9),
          ),
          margin: EdgeInsets.only(right: 1.w),
        ),
        Text("\$657.23"),
      ],
    ),
  );
  keys.add(
    Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 0.6.h,
          width: 0.6.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            color: Centre.colors[Random().nextInt(18)],
          ),
          margin: EdgeInsets.only(right: 1.w),
        ),
        Text("\$357.23"),
      ],
    ),
  );
  keys.add(
    Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 0.6.h,
          width: 0.6.h,
          decoration: BoxDecoration(
            color: Centre.colors[Random().nextInt(18)],
            borderRadius: BorderRadius.circular(9),
          ),
          margin: EdgeInsets.only(right: 1.w),
        ),
        Text("\$357.23"),
      ],
    ),
  );
  return keys;
}
