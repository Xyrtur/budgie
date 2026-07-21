/*
Actions

Add monthly expense


Information Needed

soFarSpent query
monthlyBudget query 
^^^ need limits of genres as well as total budget(includes fixed but dont need fixed number)
incomeTxns query
expenseTxns query
^^^  sort into lists based on the genre 
^^^ blocs state will give out the genres and their colors, as well as a dictionary, key: genre, value: list of expenses


UI
BlocBuilder at top for when an expense gets added for that month, update whole page

Column

Row(Text(currentMonth), Text(soFarSpentQuery + " of " + monthlyBudgetQuery))

DetailedBarGraph

Container(Text(Income), list incomes using incomeTxnsQuery)

Text(Expenses)

>> Container for each genre using genresPresent Query 

Container(color: genreColor, Text(genreName), list of expenses)

*/
import 'dart:math';
import 'dart:math' as math;

import 'package:budgie/utils/centre.dart';
import 'package:budgie/widgets/spending_overview/bar_graphs.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MonthlySpendingOverview extends StatelessWidget {
  final String month;
  const MonthlySpendingOverview({super.key, required this.month});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Centre.bgColor,
        body: Padding(
          padding: EdgeInsetsGeometry.symmetric(vertical: 4.h, horizontal: 5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(month, style: Centre.titleText),

                  Text("\$1700 of \$2200", style: Centre.semiTitleText),
                ],
              ),
              SizedBox(height: 2.5.h),

              BarGraphBoxes(),
              SizedBox(height: 1.h),

              SizedBox(
                width: 90.w,
                child: Wrap(
                  spacing: 3.w,
                  runSpacing: 0.4.h,
                  children: barGraphLegend(),
                ),
              ),
              SizedBox(height: 3.h),

              Divider(thickness: 0.1.h, color: Colors.white),

              Expanded(
                child: ListView(
                  children: [
                    SizedBox(height: 2.5.h),

                    Text("Income", style: Centre.semiTitle2Text),
                    SizedBox(height: 1.h),

                    SizedBox(
                      width: 90.w,
                      child: Wrap(
                        spacing: 3.w,
                        runSpacing: 0.4.h,
                        children: incomeBoxes(),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text("Expenses", style: Centre.semiTitleText),
                    SizedBox(height: 1.h),

                    Wrap(
                      spacing: 5.w,
                      runSpacing: 3.h,
                      children: [...categories()],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<Widget> incomeBoxes() {
  List<Widget> incomeBoxes = [];
  incomeBoxes.add(
    Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: Colors.white, width: 0.5.w),
      ),
      child: Text("GST Rebate  \$87.25", style: Centre.listText),
    ),
  );

  return incomeBoxes;
}

List<Widget> categories() {
  List<Widget> categories = [];
  Color color1 = Centre.colors[Random().nextInt(54)];
  categories.add(
    Container(
      width: 40.w,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: color1, width: 0.5.w),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Center(
                child: Text(
                  "\$285.71",
                  style: Centre.listText.copyWith(
                    fontSize: 13.sp,
                    color: const Color.fromARGB(255, 233, 117, 109),
                  ),
                ),
              ),
              SizedBox(
                height: 9.h,
                width: 9.h,
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 0.6),
                  duration: const Duration(milliseconds: 3500),
                  curve: Curves.fastLinearToSlowEaseIn,
                  builder: (context, value, _) => Transform.rotate(
                    angle: math.pi,
                    child: CircularProgressIndicator(
                      value: value,
                      strokeWidth: 4.w,
                      strokeCap: StrokeCap.round,
                      color: color1,
                      backgroundColor: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.5.h),
          Text("Category 2", style: Centre.semiTitleText),
          Text(
            "\$120.71 remaining",
            style: Centre.listText.copyWith(
              fontSize: 13.sp,
              color: Colors.lightGreen,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("ice cream"), Text("\$18.56")],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("shoes"), Text("\$170.45")],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("boba"), Text("\$15.75")],
          ),
        ],
      ),
    ),
  );
  Color color2 = Centre.colors[Random().nextInt(54)];
  categories.add(
    Container(
      width: 40.w,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: color2, width: 0.5.w),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Center(
                child: Text(
                  "\$285.71",
                  style: Centre.listText.copyWith(
                    fontSize: 13.sp,
                    color: const Color.fromARGB(255, 233, 117, 109),
                  ),
                ),
              ),
              SizedBox(
                height: 9.h,
                width: 9.h,
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 0.6),
                  duration: const Duration(milliseconds: 3500),
                  curve: Curves.fastLinearToSlowEaseIn,
                  builder: (context, value, _) => Transform.rotate(
                    angle: math.pi,
                    child: CircularProgressIndicator(
                      value: value,
                      strokeWidth: 4.w,
                      strokeCap: StrokeCap.round,
                      color: color2,
                      backgroundColor: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.5.h),
          Text("Category 2", style: Centre.semiTitleText),
          Text(
            "\$120.71 remaining",
            style: Centre.listText.copyWith(
              fontSize: 13.sp,
              color: Colors.lightGreen,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("ice cream"), Text("\$18.56")],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("shoes"), Text("\$170.45")],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("boba"), Text("\$15.75")],
          ),
        ],
      ),
    ),
  );
  Color color3 = Centre.colors[Random().nextInt(54)];
  categories.add(
    Container(
      width: 40.w,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: color3, width: 0.5.w),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Center(
                child: Text(
                  "\$285.71",
                  style: Centre.listText.copyWith(
                    fontSize: 13.sp,
                    color: const Color.fromARGB(255, 233, 117, 109),
                  ),
                ),
              ),
              SizedBox(
                height: 9.h,
                width: 9.h,
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 0.6),
                  duration: const Duration(milliseconds: 3500),
                  curve: Curves.fastLinearToSlowEaseIn,
                  builder: (context, value, _) => Transform.rotate(
                    angle: math.pi,
                    child: CircularProgressIndicator(
                      value: value,
                      strokeWidth: 4.w,
                      strokeCap: StrokeCap.round,
                      color: color3,
                      backgroundColor: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.5.h),
          Text("Category 2", style: Centre.semiTitleText),
          Text(
            "\$120.71 remaining",
            style: Centre.listText.copyWith(
              fontSize: 13.sp,
              color: Colors.lightGreen,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("ice cream"), Text("\$18.56")],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("shoes"), Text("\$170.45")],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("boba"), Text("\$15.75")],
          ),
        ],
      ),
    ),
  );
  Color color4 = Centre.colors[Random().nextInt(54)];
  categories.add(
    Container(
      width: 40.w,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: color4, width: 0.5.w),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Center(
                child: Text(
                  "\$285.71",
                  style: Centre.listText.copyWith(
                    fontSize: 13.sp,
                    color: const Color.fromARGB(255, 233, 117, 109),
                  ),
                ),
              ),
              SizedBox(
                height: 9.h,
                width: 9.h,
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 0.6),
                  duration: const Duration(milliseconds: 3500),
                  curve: Curves.fastLinearToSlowEaseIn,
                  builder: (context, value, _) => Transform.rotate(
                    angle: math.pi,
                    child: CircularProgressIndicator(
                      value: value,
                      strokeWidth: 4.w,
                      strokeCap: StrokeCap.round,
                      color: color4,
                      backgroundColor: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.5.h),
          Text("Category 2", style: Centre.semiTitleText),
          Text(
            "\$120.71 remaining",
            style: Centre.listText.copyWith(
              fontSize: 13.sp,
              color: Colors.lightGreen,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("ice cream"), Text("\$18.56")],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("shoes"), Text("\$170.45")],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("boba"), Text("\$15.75")],
          ),
        ],
      ),
    ),
  );

  return categories;
}
