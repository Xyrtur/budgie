import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/utils/centre.dart';
import 'package:budgie/widgets/dialogs/add_edit_expense_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class ViewCategoryExpensesDialog extends StatelessWidget {
  final List<Expense> expenseList;
  const ViewCategoryExpensesDialog({super.key, required this.expenseList});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 8.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: Centre.dialogBgColor,
      insetPadding: EdgeInsets.symmetric(horizontal: 10.w),
      elevation: 1,
      content: Container(
        constraints: BoxConstraints(minHeight: 25.h, maxHeight: 50.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("${expenseList.first.category} Expense List", style: Centre.semiTitleText),
            SizedBox(
              height: 0.2.h,
              width: double.infinity,
              child: ColoredBox(color: Color.fromARGB(255, 54, 57, 80)),
            ),
            SizedBox(height: 0.5.h),

            Text(
              "Select an expense to edit",
              style: Centre.listText.copyWith(fontSize: 14.sp, fontStyle: FontStyle.italic),
            ),
            Align(
              alignment: AlignmentGeometry.centerEnd,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Centre.bgSplashColor,
                  borderRadius: BorderRadius.circular(7),

                  onTap: () {
                    context.read<CategoryIsDescendingCubit>().toggle();
                  },

                  child: Ink(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.5.w),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,

                        children: [
                          BlocBuilder<CategoryIsDescendingCubit, bool>(
                            builder: (_, isDescending) {
                              return Stack(
                                children: [
                                  AnimatedRotation(
                                    turns: isDescending ? 0 : 0.5,
                                    duration: const Duration(milliseconds: 300),
                                    child: Icon(Icons.south, size: 3.5.w, color: Centre.offWhite),
                                  ),
                                  Positioned(
                                    left: 3.w,
                                    child: Icon(Icons.sort, size: 4.w, color: Centre.offWhite),
                                  ),
                                  SizedBox(width: 8.w),
                                ],
                              );
                            },
                          ),

                          Text("Amount", style: Centre.listText),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Flexible(
              child: RawScrollbar(
                crossAxisMargin: -3.w,
                interactive: false,
                scrollbarOrientation: ScrollbarOrientation.left,
                trackVisibility: true,
                thumbVisibility: true,
                thumbColor: Centre.graphLinesColor.withAlpha(200),
                radius: const Radius.circular(8),
                thickness: 0.3.h,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 0.2.h,
                        width: double.infinity,
                        child: ColoredBox(color: Color.fromARGB(255, 42, 45, 63)),
                      ),
                      for (int i = 0; i < expenseList.length; i++) ...[
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext dialogContext) {
                                return MultiBlocProvider(
                                  providers: [
                                    BlocProvider<AddExpenseCategoryBtnsCubit>(
                                      create: (context) => AddExpenseCategoryBtnsCubit(expenseList[i].category),
                                    ),
                                    BlocProvider<DatesSelectedCubit>(
                                      create: (context) => DatesSelectedCubit(dates: [expenseList[i].date]),
                                    ),
                                    BlocProvider<IsIncomeToggleCubit>(
                                      create: (context) => IsIncomeToggleCubit(isIncome: expenseList[i].isExpense),
                                    ),
                                  ],
                                  child: AddEditExpenseDialog(editingExpense: expenseList[i]),
                                );
                              },
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 1.8.h, horizontal: 8.w),
                            color: i % 2 == 0 ? Centre.dialogBgColor : Centre.navBarColor,

                            child: Row(
                              children: [
                                Text(expenseList[i].name, style: Centre.listText.copyWith(fontSize: 15.sp)),
                                Spacer(),
                                Text(
                                  expenseList[i].value.toStringAsFixed(2),
                                  style: Centre.listText.copyWith(fontSize: 15.sp),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 0.2.h,
                          width: double.infinity,
                          child: ColoredBox(color: Color.fromARGB(255, 42, 45, 63)),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
