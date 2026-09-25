import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/utils/centre.dart';
import 'package:budgie/widgets/icon_button.dart';
import 'package:budgie/widgets/settings_page/month_year_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class BudgetPlanningPeriodsSection extends StatefulWidget {
  const BudgetPlanningPeriodsSection({super.key});

  @override
  State<BudgetPlanningPeriodsSection> createState() => _BudgetPlanningPeriodsSectionState();
}

class _BudgetPlanningPeriodsSectionState extends State<BudgetPlanningPeriodsSection> {
  // dateRangeID, [startDate, endDate]

  // Value notifiers to send events to their respective blocs when needed since shouldn't call context in async gaps
  final ValueNotifier<List<dynamic>?> editingYearMonthResults = // [dateRangeID, 0 / 1 {startDate OR endDate}, newDate ]
  ValueNotifier<List<dynamic>?>([
    null,
  ]);

  final ValueNotifier<List<DateTime?>> addingYearMonthResults = ValueNotifier<List<DateTime?>>([null, null]);

  @override
  void initState() {
    super.initState();
    editingYearMonthResults.addListener(() {
      context.read<TempEditingDateRangesCubit>().update(
        editingYearMonthResults.value![0],
        editingYearMonthResults.value![1],
        editingYearMonthResults.value![2],
      );
    });
    addingYearMonthResults.addListener(() {
      context.read<AddingDateRangeCubit>().updateDates(addingYearMonthResults.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: replace editing value notifiers with settings bloc updates when updating existing date ranges
    // editingYearMonthResults.addListener(() {
    //   context.read<SettingsBloc().update(editingYearMonthResults.value);
    // });

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Edit Budget Planning Periods", style: Centre.semiTitleText),
        SizedBox(height: 0.5.h),

        Divider(),
        Text(
          "Tap to change start and end dates of each period",
          style: Centre.listText.copyWith(fontSize: 15.sp, fontStyle: FontStyle.italic),
        ),
        SizedBox(height: 2.h),
        for (MapEntry<int, List<DateTime>> range in context.read<TempEditingDateRangesCubit>().state.entries)
          Container(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            margin: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: range.key % 2 == 0 ? Centre.dialogBgColor : Centre.navBarColor,
              border: range.key != 2
                  ? Border(
                      bottom: BorderSide(color: Centre.buttonBorderColor, width: 0.1.h),
                    )
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MonthYearEditingRangeButton(id: range.key, isStartDate: true, dialogResult: editingYearMonthResults),
                SizedBox(width: 5.w),
                MonthYearEditingRangeButton(id: range.key, isStartDate: false, dialogResult: editingYearMonthResults),
              ],
            ),
          ),

        SizedBox(height: 1.5.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),

            MonthYearAddingRangeButton(isStartDate: true, dialogResult: addingYearMonthResults),
            Text(" - ", style: Centre.semiTitleText),
            MonthYearAddingRangeButton(isStartDate: false, dialogResult: addingYearMonthResults),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 5.w),
                  child: CustomIconButton(
                    onTap: () {},
                    child: Icon(Icons.add, size: 5.w, color: Centre.primaryColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
