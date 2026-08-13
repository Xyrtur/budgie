/*  Set limits for each budget category, as well as any fixed costs
*/
import 'dart:math';

import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/utils/centre.dart';
import 'package:budgie/widgets/budget_planning/category_box.dart';
import 'package:budgie/widgets/budget_planning/fixed_formfield_row.dart';
import 'package:budgie/widgets/dialogs/date_range_dropdown_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class BudgetPlanningPage extends StatefulWidget {
  const BudgetPlanningPage({super.key});

  @override
  State<BudgetPlanningPage> createState() => _BudgetPlanningPageState();
}

class _BudgetPlanningPageState extends State<BudgetPlanningPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final List<String> categories = [
    "Groceries",
    "Entertainment",
    "House",
    "Gas",
    "Junk Food",
    "Ava",
    "Category 1",
    "Category 2",
  ];
  double currentBudget = 0;
  List<double> fixedFormFieldCostValues = [];
  List<String> fixedFormFieldLabelValues = [];
  List<double> categoryCostValues = [];

  @override
  void initState() {
    super.initState();
    categoryCostValues = List.generate(categories.length, (_) => 0);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: Centre.bgColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DateRangeDropDownMenu(),
              SizedBox(height: 2.h),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: Centre.accentColor),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: BlocBuilder<LiveBudgetTotalTrackerCubit, double>(
                    builder: (_, currentBudget) {
                      return Text("Monthly Budget: ${currentBudget.toStringAsFixed(2)}");
                    },
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 3.w,
                runSpacing: 5.h,
                children: [
                  Container(
                    width: 70.w,

                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 2.h),
                        Text("Fixed", style: Centre.semiTitle2Text),
                        for (var i = 0; i < fixedFormFieldCostValues.length; i++)
                          FixedFormFieldRow(
                            index: i,
                            fixedCosts: fixedFormFieldCostValues,
                            fixedLabels: fixedFormFieldLabelValues,
                          ),
                        SizedBox(height: 2.h),

                        IconButton.outlined(
                          onPressed: () {
                            setState(() {
                              fixedFormFieldCostValues.add(0);
                              fixedFormFieldLabelValues.add('');
                            });
                          },
                          iconSize: 6.w,
                          color: Centre.accentColor,
                          icon: const Icon(Icons.add),
                        ),
                        SizedBox(height: 2.h),
                      ],
                    ),
                  ),
                  for (String i in categories)
                    CategoryBox(
                      categoryName: i,
                      categoryColor: Centre.colors[Random().nextInt(18)],
                      categoryCosts: categoryCostValues,
                      categoryIndex: categories.indexOf(i),
                    ),
                ],
              ),
              SizedBox(height: 5.h),
            ],
          ),
        ),
      ),
    );
  }
}
