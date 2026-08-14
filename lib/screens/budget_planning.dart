/*  Set limits for each budget category, as well as any fixed costs
*/
import 'dart:math';

import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/utils/centre.dart';
import 'package:budgie/widgets/budget_planning/category_box.dart';
import 'package:budgie/widgets/budget_planning/fixed_formfield_row.dart';
import 'package:budgie/widgets/dialogs/date_range_dropdown_menu.dart';
import 'package:budgie/widgets/icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class BudgetPlanningPage extends StatelessWidget {
  BudgetPlanningPage({super.key});

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Centre.bgColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 3.h),
              Text("Budget Planning Period", style: Centre.titleText),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                child: Divider(),
              ),

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
              Container(
                width: 70.w,

                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 2.h),
                    Text("Fixed Costs", style: Centre.semiTitleText),

                    BlocBuilder<FixedLabelsAndCostsCubit, List<String>>(
                      builder: (_, labelsCostsText) {
                        return BlocBuilder<FixedCostFieldKeysCubit, List<GlobalKey<FixedFormFieldRowState>>>(
                          builder: (_, fixedCostKeys) {
                            List<Widget> fieldRows = [];
                            for (int i = 0; i < fixedCostKeys.length; i++) {
                              fieldRows.add(
                                FixedFormFieldRow(
                                  key: fixedCostKeys[i],
                                  labelText: labelsCostsText[i * 2],
                                  costText: labelsCostsText[i * 2 + 1],
                                  index: i,
                                ),
                              );
                            }

                            return Column(mainAxisSize: MainAxisSize.min, children: fieldRows);
                          },
                        );
                      },
                    ),
                    SizedBox(height: 2.h),
                    CustomIconButton(
                      onTap: () {
                        context.read<FixedCostFieldKeysCubit>().add();
                        context.read<FixedLabelsAndCostsCubit>().add();
                      },
                      child: Icon(Icons.add, size: 6.w, color: Centre.primaryColor),
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
              SizedBox(height: 4.h),

              Text("Category Limits", style: Centre.titleText),
              SizedBox(height: 3.h),
              BlocBuilder<CategoryBoxKeysCubit, List<GlobalKey<CategoryBoxState>>>(
                builder: (_, categoryBoxKeys) {
                  return BlocBuilder<CategoryBoxTextsCubit, Map<String, String>>(
                    builder: (_, categoryBoxTexts) {
                      return Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 3.w,
                        runSpacing: 5.h,
                        children: [
                          for (int i = 0; i < categories.length; i++)
                            CategoryBox(
                              textFieldKey: categoryBoxKeys[i],
                              initialText: categoryBoxTexts[categories[i]]!,
                              categoryName: categories[i],
                              categoryColor: Centre.colors[Random().nextInt(18)],
                              categoryIndex: i,
                            ),
                        ],
                      );
                    },
                  );
                },
              ),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom > 0 ? 2.h : 18.h),
            ],
          ),
        ),
      ),
    );
  }
}
