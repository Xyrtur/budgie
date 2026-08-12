import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/utils/centre.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class SpendingGraph extends StatelessWidget {
  final bool isPortrait;
  final Map<String, List<double>> categoriesData;
  final List<Color> categoryColors;
  final List<String> categories;
  final void Function() toggleLandscapeOnPressed;

  const SpendingGraph({
    super.key,
    required this.isPortrait,
    required this.categoriesData,
    required this.categoryColors,
    required this.categories,
    required this.toggleLandscapeOnPressed,
  });

  double getChartInterval(double maxValue) {
    if (maxValue <= 60) {
      return 10;
    } else if (maxValue <= 100) {
      return 20;
    } else if (maxValue <= 200) {
      return 40;
    } else if (maxValue <= 400) {
      return 50;
    } else if (maxValue <= 1000) {
      return 100;
    } else if (maxValue <= 2000) {
      return 200;
    } else if (maxValue <= 4000) {
      return 500;
    }
    return 1000;
  }

  FlBorderData get borderData => FlBorderData(
    show: true,
    border: Border(
      bottom: BorderSide(color: Centre.graphLinesColor),
      left: BorderSide(color: Centre.graphLinesColor),
      right: const BorderSide(color: Colors.transparent),
      top: BorderSide(color: Centre.graphLinesColor),
    ),
  );

  SideTitles get bottomTitles => SideTitles(showTitles: true, reservedSize: 32, interval: 1, getTitlesWidget: bottomTitleWidgets);

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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpendingCategoriesToggledCubit, List<String>>(
      builder: (_, categoriesToggled) {
        final lineBars = [
          for (MapEntry<String, List<double>> e in categoriesData.entries)
            if (categoriesToggled.contains(e.key))
              LineChartBarData(
                color: categoryColors[categories.indexOf(e.key)],
                barWidth: 2.5,
                spots: [for (int i = 0; i < e.value.length; i++) FlSpot(i.toDouble(), e.value[i])],
              ),
        ];
        final maxValue = categoriesToggled.isEmpty
            ? 0.0
            : categoriesData.entries
                  .where((entry) => categoriesToggled.contains(entry.key))
                  .expand((entry) => entry.value)
                  .reduce((a, b) => a > b ? a : b);

        return Expanded(
          flex: isPortrait ? 0 : 1,
          child: Padding(
            padding: isPortrait ? EdgeInsets.zero : EdgeInsets.only(bottom: 2.h, left: 1.w, top: 1.h),
            child: Stack(
              children: [
                categoriesToggled.isEmpty
                    ? Container(
                        margin: EdgeInsets.only(left: 9.5.w, bottom: 3.h),
                        decoration: BoxDecoration(
                          border: BoxBorder.fromLTRB(
                            left: BorderSide(color: Centre.graphLinesColor),
                            bottom: BorderSide(color: Centre.graphLinesColor),
                          ),
                        ),
                        child: Center(child: Text("No data", style: Centre.semiTitleText)),
                      )
                    : LineChart(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        LineChartData(
                          lineTouchData: LineTouchData(
                            touchTooltipData: LineTouchTooltipData(
                              fitInsideVertically: true,
                              fitInsideHorizontally: true,
                              maxContentWidth: 30.w,
                              getTooltipColor: (touchedSpot) => Centre.bgColor.withValues(alpha: 0.8),
                              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                                return touchedSpots.map((spot) {
                                  final category = categoriesData.keys.where((key) => categoriesToggled.contains(key)).elementAt(spot.barIndex);

                                  return LineTooltipItem(
                                    categoriesToggled.length == 1 ? '' : '$category: ',
                                    TextStyle(color: categoryColors[categories.indexOf(category)], fontWeight: FontWeight.bold),
                                    children: [
                                      TextSpan(
                                        text: spot.y.toStringAsFixed(2),
                                        style: TextStyle(color: categoryColors[categories.indexOf(category)], fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  );
                                }).toList();
                              },
                            ),
                            handleBuiltInTouches: true,
                            getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
                              return spotIndexes.map((spotIndex) {
                                return TouchedSpotIndicatorData(
                                  FlLine(
                                    color: barData.color?.withValues(alpha: 0.5) ?? Colors.grey,
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
                              return FlLine(color: Centre.graphLinesColor, strokeWidth: 1);
                            },
                          ),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(sideTitles: bottomTitles),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                getTitlesWidget: (double value, TitleMeta meta) {
                                  const style = TextStyle(fontWeight: FontWeight.w500, fontSize: 13);

                                  return SideTitleWidget(
                                    meta: meta,
                                    child: Text(value.toInt().toString(), style: style, textAlign: TextAlign.center),
                                  );
                                },
                                showTitles: true,
                                interval: getChartInterval(maxValue),
                                reservedSize: 9.5.w,
                              ),
                            ),
                          ),
                          borderData: borderData,
                          lineBarsData: lineBars,
                          minX: 0,
                          maxX: 12,
                          maxY: (maxValue / getChartInterval(maxValue)).ceil() * getChartInterval(maxValue) + getChartInterval(maxValue),
                          minY: 0,
                        ),
                      ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    style: IconButton.styleFrom(backgroundColor: Centre.dialogBgColor),
                    onPressed: toggleLandscapeOnPressed,
                    iconSize: 5.w,

                    icon: Icon(Icons.screen_rotation_alt, color: Centre.colors[33]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
