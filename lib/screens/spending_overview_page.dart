// ignore_for_file: dangling_library_doc_comments

import 'package:budgie/utils/centre.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/**
 * Actions:
 * 
 * Click on month for MonthlySpendingPage
 * Click on date range button 
 * Swap to graphview
 * Add expense
 * 
 * 
 * UI

 * if SpendingViewSwapCubit.state == listview
 * 		SpendingListview
 * else
 * 		SpendingGraphView
 * 
 * 
 */

class SpendingOverviewPage extends StatefulWidget {
  const SpendingOverviewPage({super.key});

  @override
  State<SpendingOverviewPage> createState() => _SpendingOverviewPageState();
}

class _SpendingOverviewPageState extends State<SpendingOverviewPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Centre.bgColor,
        body: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(color: Centre.colors[5], width: 0.5.w),
                    ),
                    child: Text("2023", style: Centre.semiTitleText),
                  ),
                ),
                SizedBox(width: 5.w),
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: Centre.colors[7], width: 0.5.w),
                    ),
                    child: Icon(Icons.auto_graph_sharp),
                  ),
                ),
              ],
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: []),
            Align(
              alignment: AlignmentGeometry.bottomLeft,
              child: Container(
                margin: EdgeInsets.only(left: 3.w, bottom: 2.h),
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                decoration: BoxDecoration(
                  border: Border.all(color: Centre.colors[5], width: 0.5.w),
                ),
                child: Text("Over total"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
