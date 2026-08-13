import 'package:budgie/screens/monthly_spending_overview.dart';
import 'package:budgie/utils/centre.dart';
import 'package:budgie/widgets/spending_overview/bar_graphs.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class MonthTile extends StatelessWidget {
  final String month;
  final AnimationController controller;
  final Animation<double> animation;
  const MonthTile({super.key, required this.month, required this.controller, required this.animation});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
      child: Ink(
        decoration: BoxDecoration(
          color: Centre.bgColor,
          borderRadius: BorderRadius.circular(8),
          border: DateFormat("MMMM").format(DateTime.now()) == month
              ? Border.all(color: Centre.colors[1], width: 0.5.w)
              : null,

          // Outer depth
          boxShadow: const [
            BoxShadow(color: Color(0xff080912), offset: Offset(4, 4), blurRadius: 8),
            BoxShadow(color: Color.fromARGB(255, 42, 45, 69), offset: Offset(-4, -4), blurRadius: 8),
          ],
        ),

        child: InkWell(
          splashColor: Centre.bgSplashColor,
          highlightColor: Centre.bgSplashColor,
          borderRadius: BorderRadius.circular(8),

          onTap: () async {
            await Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => MonthlySpendingOverview(month: month)));

            controller.reset();
            controller.forward();
          },

          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(month, style: Centre.semiTitleText.copyWith(fontSize: 16.sp)),

                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: const Color.fromARGB(255, 97, 202, 101), width: 0.2.h),
                            ),
                          ),
                          child: Text("\$2317.86", style: Centre.listText),
                        ),
                        SizedBox(width: 3.w),
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: const Color.fromARGB(255, 224, 77, 84), width: 0.2.h),
                            ),
                          ),
                          child: Text("\$849.24", style: Centre.listText),
                        ),
                        SizedBox(width: 3.w),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 1.5.h),

                SizeTransition(
                  sizeFactor: animation,
                  axis: Axis.horizontal,
                  alignment: Alignment.topCenter,
                  child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: barGraphBoxes()),
                ),
                SizedBox(height: 1.h),

                Align(
                  alignment: AlignmentGeometry.bottomLeft,
                  child: SizedBox(
                    width: 70.w,
                    child: Align(
                      alignment: AlignmentGeometry.bottomLeft,
                      child: Wrap(spacing: 3.w, runSpacing: 0.4.h, children: barGraphLegend()),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
