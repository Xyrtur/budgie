import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/utils/centre.dart';
import 'package:budgie/widgets/spending_overview/barrel.dart';

class SpendingOverviewPage extends StatefulWidget {
  const SpendingOverviewPage({super.key});

  @override
  State<SpendingOverviewPage> createState() => _SpendingOverviewPageState();
}

class _SpendingOverviewPageState extends State<SpendingOverviewPage> with TickerProviderStateMixin {
  List<String> months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

  final List<String> categories = [
    "Groceries",
    "Entertainment",
    "House",
    "Gas",
    "Junk Food",
    "Ava",
    "Category 1",
    "Category 2",
    "Category 3",
    "Category 4",
  ];

  final Map<String, List<double>> categoriesData = {
    "Entertainment": [289.01, 168.97, 647.89, 624.31, 210.56, 709.89, 167.45, 134.30, 475.23, 345.87, 250.65, 127.63],
    "Gas": [119.05, 107.51, 195.39, 296.93, 178.21, 273.08, 107.83, 150, 119.05, 107.51, 195.39, 296.93],
    "Ava": [58.43, 72.91, 149.18, 104.67, 91.25, 136.84, 63.09, 117.53, 82.46, 145.02, 99.71, 54.38],
    "Groceries": [412.37, 278.94, 365.21, 491.63, 326.48, 453.79, 297.56, 384.12, 468.35, 251.87, 339.64, 425.09],
    "House": [23.47, 68.12, 41.85, 75.63, 16.29, 52.74, 34.91, 79.08, 27.56, 61.43, 45.77, 12.68],
    "Junk Food": [34.72, 48.15, 27.63, 41.89, 22.47, 36.54, 49.26, 31.78, 44.03, 25.91, 38.67, 20.84],
    "Category 1": [127.84, 263.51, 198.37, 241.62, 156.93, 289.45, 214.76, 173.28, 298.14, 132.59, 225.47, 187.65],
    "Category 2": [214.67, 327.41, 158.92, 289.35, 246.18, 119.54, 341.73, 275.86, 193.47, 305.29, 137.68, 228.91],
    "Category 3": [214.67, 327.41, 158.92, 289.35, 246.18, 119.54, 341.73, 275.86, 193.47, 305.29, 137.68, 228.91],
    "Category 4": [214.67, 327.41, 158.92, 289.35, 246.18, 119.54, 341.73, 275.86, 193.47, 305.29, 137.68, 228.91],
  };

  late final AnimationController controller = AnimationController(duration: const Duration(milliseconds: 1300), vsync: this);
  late final Animation<double> animation = CurvedAnimation(parent: controller, curve: Curves.fastLinearToSlowEaseIn);
  bool isPortrait = true;

  late final List<Color> categoryColors;

  @override
  void initState() {
    super.initState();

    // Add a "Total Expenses" category
    categories.insert(0, "Total Expenses");
    categoriesData["Total Expenses"] = List<double>.generate(12, (int index) => 0);
    for (int i = 0; i < 12; i++) {
      for (String category in categoriesData.keys) {
        if (category == "Total Expenses") continue;
        categoriesData["Total Expenses"]![i] += categoriesData[category]![i];
      }
    }

    categoryColors = List.generate(categories.length, (_) => Centre.colors[Random().nextInt(54)]);
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Centre.bgColor,
        body: BlocBuilder<SpendingGraphViewToggleCubit, bool>(
          builder: (_, graphviewEnabled) {
            return Stack(
              children: [
                ConditionalScrollView(
                  enabled: isPortrait,
                  child: !graphviewEnabled
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: 6.h),
                            for (String i in months) MonthTile(month: i, controller: controller, animation: animation),
                          ],
                        )
                      : RotatedBox(
                          quarterTurns: isPortrait ? 0 : 1,
                          child: isPortrait
                              ? Padding(
                                  padding: EdgeInsets.only(left: 2.w, right: 4.w),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                                        child: Row(
                                          children: [
                                            Text("Spending Graphview", style: Centre.titleText),
                                            Spacer(),

                                            !isPortrait ? Expanded(child: Container(color: Colors.transparent)) : ToggleGraphviewButton(),
                                          ],
                                        ),
                                      ),
                                      YearMultiSelectArea(isPortrait: isPortrait, expandWithinRow: false),
                                      SizedBox(height: 1.h),
                                      SizedBox(
                                        height: 40.h,
                                        child: SpendingGraph(
                                          isPortrait: isPortrait,
                                          categoriesData: categoriesData,
                                          categoryColors: categoryColors,
                                          categories: categories,
                                          toggleLandscapeOnPressed: () {
                                            setState(() {
                                              isPortrait = !isPortrait;
                                            });
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 2.w, top: 2.h),
                                        child: Text("Toggle Categories Shown", style: Centre.semiTitle2Text),
                                      ),
                                      ToggleCategoryArea(isPortrait: isPortrait, categories: categories, categoryColors: categoryColors),
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.only(right: 4.w, left: 2.w),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: ToggleCategoryArea(isPortrait: isPortrait, categories: categories, categoryColors: categoryColors),
                                      ),

                                      SizedBox(
                                        width: 60.h,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,

                                              children: [
                                                Text("Spending Graphview", style: Centre.titleText),
                                                SizedBox(width: 10.w),
                                                YearMultiSelectArea(isPortrait: isPortrait, expandWithinRow: true),
                                              ],
                                            ),
                                            SpendingGraph(
                                              isPortrait: isPortrait,
                                              categoriesData: categoriesData,
                                              categoryColors: categoryColors,
                                              categories: categories,
                                              toggleLandscapeOnPressed: () {
                                                setState(() {
                                                  isPortrait = !isPortrait;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                ),
                graphviewEnabled ? SizedBox() : SpendingListviewHeader(isPortrait: isPortrait),

                BlocBuilder<SpendingGraphViewToggleCubit, bool>(
                  builder: (_, graphviewEnabled) {
                    return graphviewEnabled
                        ? SizedBox()
                        : Align(
                            alignment: AlignmentGeometry.bottomLeft,
                            child: Container(
                              margin: EdgeInsets.only(left: 3.w, bottom: 2.h),
                              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                              decoration: BoxDecoration(
                                color: Centre.bgColor,
                                border: Border.all(color: Centre.colors[5], width: 0.5.w),
                              ),
                              child: Text("Over total"),
                            ),
                          );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
