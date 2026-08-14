import 'dart:math';

import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/utils/centre.dart';
import 'package:budgie/widgets/icon_button.dart';
import 'package:budgie/widgets/settings_page/category_textfields.dart';
import 'package:budgie/widgets/settings_page/choose_color_button.dart';
import 'package:budgie/widgets/settings_page/month_year_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final formKey = GlobalKey<FormState>();
  final TextEditingController editingController = TextEditingController(text: "");

  // Value notifiers to send events to their respective blocs when needed since shouldn't call context in async gaps
  final ValueNotifier<List<dynamic>?> editingYearMonthResults = // [dateRangeID, 0 / 1 {startDate OR endDate}, newDate ]
  ValueNotifier<List<dynamic>?>([
    null,
  ]);
  final ValueNotifier<List<DateTime?>> addingYearMonthResults = ValueNotifier<List<DateTime?>>([null, null]);

  final Map<String, int> categories = {
    "Entertainment": Centre.colors[Random().nextInt(54)].toARGB32(),
    "Grocery": Centre.colors[Random().nextInt(54)].toARGB32(),
    "Gas": Centre.colors[Random().nextInt(54)].toARGB32(),
    "Ava - Cat Supplies": Centre.colors[Random().nextInt(54)].toARGB32(),
  };

  // dateRangeID, [startDate, endDate]
  final Map<int, List<DateTime>> dateRanges = {
    0: [DateTime(2023, 1, 1), DateTime(2023, 12, 31)],
    1: [DateTime(2024, 1, 1), DateTime(2025, 12, 31)],
    2: [DateTime(2026, 1, 1), DateTime.now()],
  };

  List<Widget> categoryEditingList({
    required BuildContext context,
    required Map<String, int> categories,
    String? editingName,
  }) {
    List<Widget> categoryList = [];
    categories.forEach((name, color) {
      categoryList.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: 0.6.h),
          child: Row(
            children: [
              editingName == null || editingName != name
                  ? GestureDetector(
                      onTap: () {
                        context.read<SettingsEditingTextCubit>().editing(name: name);
                      },
                      child: Text(name, style: Centre.listText),
                    )
                  : CategoryTextField(
                      existingCategories: categories.keys.toList(),
                      formKey: formKey,
                      controller: editingController..text = name,
                    ),
              const Spacer(),
              BlocProvider<SettingsAddColorCubit>(
                create: (context) => SettingsAddColorCubit(null),
                child: ChooseColorBtn(color: color, categoryName: name),
              ),
              SizedBox(width: 3.w),
              editingName == null || editingName != name
                  ? const SizedBox()
                  : GestureDetector(
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          // TODO: Update category from old "name" to new "editingcontroller.text"
                          editingController.clear();
                          context.read<SettingsEditingTextCubit>().editing(name: "");
                        }
                      },
                      child: const SizedBox(child: Center(child: Icon(Icons.check))),
                    ),
              name == "Other"
                  ? const SizedBox()
                  : CustomIconButton(
                      onTap: () {
                        if (editingName == null || editingName != name) {
                          // If not in editing mode, then delete button shows
                          //TODO:  Delete category
                        } else {
                          // If in editing mode, just clear
                          editingController.clear();
                          context.read<SettingsEditingTextCubit>().editing(name: "");
                        }
                      },
                      child: Icon(
                        editingName == null || editingName != name ? Icons.delete : Icons.close,
                        size: 5.w,
                        color: Centre.primaryColor,
                      ),
                    ),
            ],
          ),
        ),
      );
    });
    return [
      ...categoryList,
      SizedBox(height: 0.6.h),

      BlocProvider<SettingsAddColorCubit>(
        create: (_) => SettingsAddColorCubit(null),
        child: AddCategoryTextField(existingCategories: categories.keys.toList()),
      ),
    ];
  }

  List<Widget> dateRangeList(BuildContext context) {
    List<Widget> rangeList = [];
    dateRanges.forEach((id, startEndDates) {
      rangeList.add(
        Padding(
          padding: EdgeInsets.only(bottom: 2.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MonthYearEditingRangeButton(id: id, isStartDate: true, dialogResult: editingYearMonthResults),
              Text(" - ", style: Centre.semiTitleText),
              MonthYearEditingRangeButton(id: id, isStartDate: false, dialogResult: editingYearMonthResults),
            ],
          ),
        ),
      );
    });
    return [
      ...rangeList,
      Flex(direction: Axis.horizontal),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),

          MonthYearAddingRangeButton(isStartDate: true, dialogResult: addingYearMonthResults),
          Text(" - ", style: Centre.semiTitleText),
          MonthYearAddingRangeButton(isStartDate: false, dialogResult: addingYearMonthResults),
          Expanded(
            child: Align(
              alignment: Alignment.topRight,
              child: CustomIconButton(
                onTap: () {},
                child: Icon(Icons.add, size: 5.w, color: Centre.primaryColor),
              ),
            ),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // TODO: replace editing value notifiers with settings bloc updates when updating existing date ranges
    // editingYearMonthResults.addListener(() {
    //   context.read<SettingsBloc().update(editingYearMonthResults.value);
    // });
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
    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: Centre.bgColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            child: Column(
              children: [
                Text("Manage Categories", style: Centre.semiTitleText),
                SizedBox(height: 1.h),
                Divider(color: Centre.colors[36]),
                SizedBox(height: 2.h),
                ...categoryEditingList(context: context, categories: categories),
                SizedBox(height: 4.h),
                Text("Budget Planning Date Ranges", style: Centre.semiTitleText),
                SizedBox(height: 1.h),

                Divider(color: Centre.colors[36]),
                SizedBox(height: 2.h),
                ...dateRangeList(context),

                BlocBuilder<TempIncludeFixedCubit, bool>(
                  builder: (_, enabled) {
                    return GestureDetector(
                      onTap: () {
                        context.read<TempIncludeFixedCubit>().toggle();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(enabled ? Icons.check_box_sharp : Icons.check_box_outline_blank_sharp, size: 5.w),
                            SizedBox(width: 3.w),
                            Text("Include Fixed Costs in Bar Graphs", style: Centre.semiTitle2Text),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
