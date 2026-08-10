// ignore_for_file: dangling_library_doc_comments

import 'dart:math';

import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/screens/budget_planning.dart';
import 'package:budgie/utils/centre.dart';
import 'package:budgie/widgets/spending_overview/month_tile.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class SpendingOverviewPage extends StatefulWidget {
  const SpendingOverviewPage({super.key});

  @override
  State<SpendingOverviewPage> createState() => _SpendingOverviewPageState();
}

class _SpendingOverviewPageState extends State<SpendingOverviewPage> with TickerProviderStateMixin {
  List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

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

  FlBorderData get borderData => FlBorderData(
    show: true,
    border: Border(
      bottom: BorderSide(color: Color.fromARGB(255, 76, 81, 110), width: 1),
      left: BorderSide(color: Color.fromARGB(255, 76, 81, 110), width: 1),
      right: const BorderSide(color: Colors.transparent),
      top: BorderSide(color: Color.fromARGB(255, 76, 81, 110), width: 1),
    ),
  );

  SideTitles get bottomTitles =>
      SideTitles(showTitles: true, reservedSize: 32, interval: 1, getTitlesWidget: bottomTitleWidgets);

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontWeight: FontWeight.w600, fontSize: 14);
    String text = switch (value.toInt()) {
      1 => 'Feb',
      3 => 'Apr',
      5 => 'Jun',
      7 => 'Aug',
      9 => 'Oct',
      11 => 'Dec',
      _ => '',
    };

    return SideTitleWidget(
      meta: meta,
      space: 10,
      child: Text(text, style: style),
    );
  }

  double getChartInterval(double maxValue) {
    if (maxValue <= 60) {
      return 10;
    } else if (maxValue <= 100) {
      return 20;
    } else if (maxValue <= 200) {
      return 40;
    } else if (maxValue <= 400) {
      return 50;
    } else if (maxValue <= 600) {
      return 100;
    } else if (maxValue <= 800) {
      return 100;
    } else if (maxValue <= 1000) {
      return 100;
    }
    return 200;
  }

  late final AnimationController controller = AnimationController(
    duration: const Duration(milliseconds: 1300),
    vsync: this,
  );
  late final Animation<double> animation = CurvedAnimation(parent: controller, curve: Curves.fastLinearToSlowEaseIn);
  bool isPortrait = true;

  late final List<Color> categoryColors;

  @override
  void initState() {
    super.initState();
    categoryColors = List.generate(categories.length, (_) => Centre.colors[Random().nextInt(54)]);
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget categoryBoxes() {
    return BlocBuilder<SpendingCategoriesToggledCubit, List<String>>(
      builder: (_, categoriesToggled) {
        return ScrollbarTheme(
          data: ScrollbarThemeData(
            thumbColor: WidgetStateProperty.all(const Color.fromARGB(255, 76, 81, 110)),
            thickness: WidgetStateProperty.all(2.0),
            radius: const Radius.circular(10),
            trackColor: WidgetStateProperty.all(Color.fromARGB(255, 178, 183, 211)),
          ),
          child: Scrollbar(
            trackVisibility: true,
            scrollbarOrientation: ScrollbarOrientation.left,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 5.h),
                  Wrap(
                    direction: MediaQuery.orientationOf(context) == Orientation.portrait
                        ? Axis.horizontal
                        : Axis.vertical,
                    alignment: isPortrait ? WrapAlignment.center : WrapAlignment.start,
                    runSpacing: 1.5.h,
                    spacing: isPortrait ? 5.w : 3.w,
                    children: [
                      for (int i = 0; i < categories.length; i++)
                        GestureDetector(
                          onTap: () {
                            context.read<SpendingCategoriesToggledCubit>().toggleCategory(categories[i]);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                            decoration: BoxDecoration(
                              color: categoriesToggled.contains(categories[i]) ? categoryColors[i] : Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                              border: BoxBorder.all(color: categoryColors[i], width: 0.4.w),
                            ),
                            child: Text(
                              categories[i],
                              style: Centre.listText.copyWith(
                                fontSize: isPortrait ? 14.sp : 13.5.sp,
                                fontWeight: FontWeight.bold,
                                color: categoriesToggled.contains(categories[i]) ? Centre.bgColor : categoryColors[i],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Centre.bgColor,
        body: Stack(
          children: [
            ConditionalScrollView(
              enabled: isPortrait,
              child: BlocBuilder<SpendingGraphViewToggleCubit, bool>(
                builder: (_, graphviewEnabled) {
                  return !graphviewEnabled
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
                                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      SizedBox(
                                        height: 40.h,
                                        child: BlocBuilder<SpendingCategoriesToggledCubit, List<String>>(
                                          builder: (_, categoriesToggled) {
                                            final lineBars = [
                                              for (MapEntry<String, List<double>> e in categoriesData.entries)
                                                if (categoriesToggled.contains(e.key) || categoriesToggled.isEmpty)
                                                  LineChartBarData(
                                                    color: categoryColors[categories.indexOf(e.key)],
                                                    barWidth: 2.5,
                                                    spots: [
                                                      for (int i = 0; i < e.value.length; i++)
                                                        FlSpot(i.toDouble(), e.value[i]),
                                                    ],
                                                  ),
                                            ];
                                            final maxValue = categoriesData.entries
                                                .where(
                                                  (entry) =>
                                                      categoriesToggled.isEmpty ||
                                                      categoriesToggled.contains(entry.key),
                                                )
                                                .expand((entry) => entry.value)
                                                .reduce((a, b) => a > b ? a : b);

                                            return LineChart(
                                              duration: const Duration(milliseconds: 500),
                                              curve: Curves.easeInOut,
                                              LineChartData(
                                                lineTouchData: LineTouchData(
                                                  touchTooltipData: LineTouchTooltipData(
                                                    fitInsideVertically: true,
                                                    fitInsideHorizontally: true,
                                                    maxContentWidth: 30.w,
                                                    getTooltipColor: (touchedSpot) =>
                                                        Centre.bgColor.withValues(alpha: 0.8),
                                                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                                                      return touchedSpots.map((spot) {
                                                        final category = categoriesData.keys
                                                            .where(
                                                              (key) =>
                                                                  categoriesToggled.isEmpty ||
                                                                  categoriesToggled.contains(key),
                                                            )
                                                            .elementAt(spot.barIndex);

                                                        return LineTooltipItem(
                                                          '$category: ',
                                                          TextStyle(
                                                            color: categoryColors[categories.indexOf(category)],
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                          children: [
                                                            TextSpan(
                                                              text: spot.y.toString(),
                                                              style: TextStyle(
                                                                color: categoryColors[categories.indexOf(category)],
                                                                fontWeight: FontWeight.normal,
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      }).toList();
                                                    },
                                                  ),
                                                  handleBuiltInTouches: true,
                                                  getTouchedSpotIndicator:
                                                      (LineChartBarData barData, List<int> spotIndexes) {
                                                        return spotIndexes.map((spotIndex) {
                                                          return TouchedSpotIndicatorData(
                                                            FlLine(
                                                              color:
                                                                  barData.color?.withValues(alpha: 0.5) ?? Colors.grey,
                                                              strokeWidth: 2,
                                                              dashArray: [5, 5], // dashed line
                                                            ),
                                                            FlDotData(show: true),
                                                          );
                                                        }).toList();
                                                      },
                                                ),
                                                gridData: FlGridData(
                                                  show: true,
                                                  drawVerticalLine: false,
                                                  horizontalInterval: getChartInterval(maxValue),
                                                  getDrawingHorizontalLine: (value) {
                                                    return FlLine(
                                                      color: Color.fromARGB(255, 76, 81, 110),
                                                      strokeWidth: 1,
                                                    );
                                                  },
                                                ),
                                                titlesData: FlTitlesData(
                                                  bottomTitles: AxisTitles(sideTitles: bottomTitles),
                                                  rightTitles: const AxisTitles(
                                                    sideTitles: SideTitles(showTitles: false),
                                                  ),
                                                  topTitles: const AxisTitles(
                                                    sideTitles: SideTitles(showTitles: false),
                                                  ),
                                                  leftTitles: AxisTitles(
                                                    sideTitles: SideTitles(
                                                      getTitlesWidget: (double value, TitleMeta meta) {
                                                        const style = TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 13,
                                                        );

                                                        return SideTitleWidget(
                                                          meta: meta,
                                                          child: Text(
                                                            value.toInt().toString(),
                                                            style: style,
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        );
                                                      },
                                                      showTitles: true,
                                                      interval: getChartInterval(maxValue),
                                                      reservedSize: 7.5.w,
                                                    ),
                                                  ),
                                                ),
                                                borderData: borderData,
                                                lineBarsData: lineBars,
                                                minX: 0,
                                                maxX: 12,
                                                maxY:
                                                    (maxValue / getChartInterval(maxValue)).ceil() *
                                                        getChartInterval(maxValue) +
                                                    getChartInterval(maxValue),
                                                minY: 0,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 3.h),
                                      categoryBoxes(),
                                      // TODO: Add toggle to have graph show values of data points
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.only(right: 4.w, left: 2.w),
                                  child: Row(
                                    children: [
                                      Expanded(child: categoryBoxes()),
                                      BlocBuilder<SpendingCategoriesToggledCubit, List<String>>(
                                        builder: (_, categoriesToggled) {
                                          final lineBars = [
                                            for (MapEntry<String, List<double>> e in categoriesData.entries)
                                              if (categoriesToggled.contains(e.key) || categoriesToggled.isEmpty)
                                                LineChartBarData(
                                                  color: categoryColors[categories.indexOf(e.key)],
                                                  barWidth: 2.5,
                                                  spots: [
                                                    for (int i = 0; i < e.value.length; i++)
                                                      FlSpot(i.toDouble(), e.value[i]),
                                                  ],
                                                ),
                                          ];
                                          final maxValue = categoriesData.entries
                                              .where(
                                                (entry) =>
                                                    categoriesToggled.isEmpty || categoriesToggled.contains(entry.key),
                                              )
                                              .expand((entry) => entry.value)
                                              .reduce((a, b) => a > b ? a : b);

                                          return SizedBox(
                                            width: 60.h,
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 8.h, bottom: 2.h, left: 1.w),
                                              child: LineChart(
                                                duration: const Duration(milliseconds: 500),
                                                curve: Curves.easeInOut,
                                                LineChartData(
                                                  lineTouchData: LineTouchData(
                                                    touchTooltipData: LineTouchTooltipData(
                                                      fitInsideVertically: true,
                                                      fitInsideHorizontally: true,
                                                      maxContentWidth: 30.w,
                                                      getTooltipColor: (touchedSpot) =>
                                                          Centre.bgColor.withValues(alpha: 0.8),
                                                      getTooltipItems: (List<LineBarSpot> touchedSpots) {
                                                        return touchedSpots.map((spot) {
                                                          final category = categoriesData.keys
                                                              .where(
                                                                (key) =>
                                                                    categoriesToggled.isEmpty ||
                                                                    categoriesToggled.contains(key),
                                                              )
                                                              .elementAt(spot.barIndex);

                                                          return LineTooltipItem(
                                                            categoriesToggled.length == 1 ? '' : '$category: ',
                                                            TextStyle(
                                                              color: categoryColors[categories.indexOf(category)],
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                            children: [
                                                              TextSpan(
                                                                text: spot.y.toString(),
                                                                style: TextStyle(
                                                                  color: categoryColors[categories.indexOf(category)],
                                                                  fontWeight: FontWeight.normal,
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        }).toList();
                                                      },
                                                    ),
                                                    handleBuiltInTouches: true,
                                                    getTouchedSpotIndicator:
                                                        (LineChartBarData barData, List<int> spotIndexes) {
                                                          return spotIndexes.map((spotIndex) {
                                                            return TouchedSpotIndicatorData(
                                                              FlLine(
                                                                color:
                                                                    barData.color?.withValues(alpha: 0.5) ??
                                                                    Colors.grey,
                                                                strokeWidth: 2,
                                                                dashArray: [5, 5], // dashed line
                                                              ),
                                                              FlDotData(show: true),
                                                            );
                                                          }).toList();
                                                        },
                                                  ),
                                                  gridData: FlGridData(
                                                    show: true,
                                                    drawVerticalLine: false,
                                                    horizontalInterval: getChartInterval(maxValue),
                                                    getDrawingHorizontalLine: (value) {
                                                      return FlLine(
                                                        color: Color.fromARGB(255, 76, 81, 110),
                                                        strokeWidth: 1,
                                                      );
                                                    },
                                                  ),
                                                  titlesData: FlTitlesData(
                                                    bottomTitles: AxisTitles(sideTitles: bottomTitles),
                                                    rightTitles: const AxisTitles(
                                                      sideTitles: SideTitles(showTitles: false),
                                                    ),
                                                    topTitles: const AxisTitles(
                                                      sideTitles: SideTitles(showTitles: false),
                                                    ),
                                                    leftTitles: AxisTitles(
                                                      sideTitles: SideTitles(
                                                        getTitlesWidget: (double value, TitleMeta meta) {
                                                          const style = TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 13,
                                                          );

                                                          return SideTitleWidget(
                                                            meta: meta,
                                                            child: Text(
                                                              value.toInt().toString(),
                                                              style: style,
                                                              textAlign: TextAlign.center,
                                                            ),
                                                          );
                                                        },
                                                        showTitles: true,
                                                        interval: getChartInterval(maxValue),
                                                        reservedSize: 7.5.w,
                                                      ),
                                                    ),
                                                  ),
                                                  borderData: borderData,
                                                  lineBarsData: lineBars,
                                                  minX: 0,
                                                  maxX: 12,
                                                  maxY:
                                                      (maxValue / getChartInterval(maxValue)).ceil() *
                                                          getChartInterval(maxValue) +
                                                      getChartInterval(maxValue),
                                                  minY: 0,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                        );
                },
              ),
            ),
            RotatedBox(
              quarterTurns: isPortrait ? 0 : 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,

                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: SizedBox()),

                  DateRangeDropDownMenu(isPortrait: isPortrait),
                  !isPortrait
                      ? Expanded(child: Container(color: Colors.transparent))
                      : Expanded(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: IconButton.outlined(
                              onPressed: () {
                                context.read<SpendingGraphViewToggleCubit>().toggle();
                              },
                              iconSize: 6.w,
                              color: Centre.accentColor,
                              icon: BlocBuilder<SpendingGraphViewToggleCubit, bool>(
                                builder: (_, graphviewEnabled) {
                                  return ClipOval(
                                    child: AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 200),
                                      reverseDuration: const Duration(milliseconds: 200),

                                      transitionBuilder: (Widget child, Animation<double> animation) {
                                        final isIncoming = child.key == (graphviewEnabled ? ValueKey(1) : ValueKey(2));
                                        final offsetAnimation = Tween<Offset>(
                                          begin: isIncoming
                                              ? const Offset(0, 1) // New icon starts below
                                              : const Offset(0, -1),
                                          end: Offset.zero,
                                        ).animate(animation);
                                        return SlideTransition(position: offsetAnimation, child: child);
                                      },
                                      child: graphviewEnabled
                                          ? Icon(Icons.auto_graph_sharp, key: ValueKey(1), color: Centre.colors[42])
                                          : Icon(Icons.list, key: ValueKey(2), color: Centre.colors[42]),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
            BlocBuilder<SpendingGraphViewToggleCubit, bool>(
              builder: (_, graphviewEnabled) {
                return graphviewEnabled
                    ? Align(
                        alignment: AlignmentGeometry.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 2.h, right: 2.h, left: isPortrait ? 0 : 2.h),
                          child: IconButton(
                            style: IconButton.styleFrom(backgroundColor: Centre.dialogBgColor),
                            onPressed: () {
                              setState(() {
                                isPortrait = !isPortrait;
                              });
                            },
                            iconSize: 6.w,

                            icon: Icon(Icons.screen_rotation_alt, color: Centre.colors[33]),
                          ),
                        ),
                      )
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
        ),
      ),
    );
  }
}

class ConditionalScrollView extends StatelessWidget {
  final bool enabled;
  final Widget child;

  const ConditionalScrollView({super.key, required this.enabled, required this.child});

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    return SingleChildScrollView(child: child);
  }
}
