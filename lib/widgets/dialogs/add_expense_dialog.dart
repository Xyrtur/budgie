import 'dart:math';

import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/utils/centre.dart';
import 'package:budgie/widgets/icon_button.dart';
import 'package:budgie/widgets/settings_page/month_year_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class AddExpenseDialog extends StatelessWidget {
  AddExpenseDialog({super.key});

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
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  late final TextEditingController amountController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ValueNotifier<DateTime?> dateResult = ValueNotifier<DateTime?>(null);

  @override
  Widget build(BuildContext context) {
    dateResult.addListener(() {
      context.read<DateSelectedCubit>().update(date: dateResult.value);
    });

    return AlertDialog(
      contentPadding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
      backgroundColor: Centre.dialogBgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      elevation: 1,

      content: SizedBox(
        width: 75.w,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: ExpenseInfoTextField(isName: true, controller: nameController),
              ),
              SizedBox(height: 3.h),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                decoration: BoxDecoration(color: const Color(0xFF232536), borderRadius: BorderRadius.circular(10)),
                child: RawScrollbar(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  interactive: false,
                  trackVisibility: true,
                  thumbVisibility: true,
                  controller: scrollController,
                  thumbColor: Centre.primaryColor.withAlpha(200),
                  radius: const Radius.circular(8),
                  thickness: 0.5.h,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    child: BlocBuilder<AddExpenseCategoryBtnsCubit, String>(
                      builder: (unUsedcontext, categorySelected) {
                        return Row(
                          children: [
                            for (String category in categories)
                              GestureDetector(
                                onTap: () {
                                  context.read<AddExpenseCategoryBtnsCubit>().update(category: category);
                                },
                                child: Container(
                                  constraints: BoxConstraints(minWidth: 18.w),
                                  margin: EdgeInsets.only(bottom: 1.5.h),
                                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: categorySelected == category
                                        ? Border.all(color: Centre.colors[Random(category.length).nextInt(54)])
                                        : null,
                                  ),
                                  child: Column(
                                    children: [
                                      Text(category.toString()),
                                      Icon(
                                        Icons.ac_unit_sharp,
                                        size: 5.w,
                                        color: Centre.colors[Random(category.length).nextInt(54)],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Row(
                  children: [
                    Text("Amount", style: Centre.semiTitleText),
                    SizedBox(width: 3.w),

                    SizedBox(
                      width: 20.w,
                      child: ExpenseInfoTextField(isName: false, controller: amountController),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 2.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomIconButton(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (unUsedContext) =>
                                      CustomMonthPicker(dateSelected: context.read<DateSelectedCubit>().state),
                                ).then((date) {
                                  if (date != null) {
                                    dateResult.value = date;
                                  }
                                });
                              },
                              child: Icon(Icons.calendar_month, color: Centre.primaryColor),
                            ),
                            SizedBox(width: 2.w),
                            BlocBuilder<DateSelectedCubit, DateTime?>(
                              builder: (unUsedcontext, dateChosen) {
                                return Text(
                                  dateChosen != null ? DateFormat('MMM, y').format(dateChosen) : "",
                                  style: Centre.semiTitle2Text,
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CustomIconButton(
                              onTap: () {},
                              child: Icon(Icons.check, color: Centre.primaryColor),
                            ),
                            SizedBox(width: 3.w),
                            CustomIconButton(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.close, color: Centre.primaryColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Spacer(),

                  GestureDetector(
                    onTap: () {
                      context.read<IsIncomeToggleCubit>().toggle();
                    },
                    child: Container(
                      decoration: BoxDecoration(color: Centre.shadowbgColor, borderRadius: BorderRadius.circular(12)),
                      padding: EdgeInsets.all(1.h),
                      margin: EdgeInsets.only(right: 1.w),
                      child: BlocBuilder<IsIncomeToggleCubit, bool>(
                        builder: (unUsedcontext, isIncome) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeInOut,
                                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                                decoration: BoxDecoration(
                                  color: isIncome ? Centre.secondaryColor : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text("Income", style: Centre.semiTitle2Text),
                              ),

                              SizedBox(height: 1.h),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeInOut,
                                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                                decoration: BoxDecoration(
                                  color: !isIncome ? Centre.secondaryColor : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text("Expense", style: Centre.semiTitle2Text),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
            ],
          ),
        ),
      ),
    );
  }
}

class ExpenseInfoTextField extends StatefulWidget {
  // It's either name or amount
  final bool isName;
  final TextEditingController controller;
  const ExpenseInfoTextField({super.key, required this.isName, required this.controller});
  @override
  State<ExpenseInfoTextField> createState() => _ExpenseInfoTextFieldState();
}

class _ExpenseInfoTextFieldState extends State<ExpenseInfoTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      autofocus: widget.isName,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (text) {
        if (text == null || text.isEmpty) {
          return 'Can\'t be empty';
        } else if (text.length > 100) {
          return 'Too long';
        }
        return null;
      },
      style: widget.isName ? Centre.titleText : Centre.semiTitleText,
      keyboardType: widget.isName ? null : TextInputType.number,

      decoration: InputDecoration(
        prefixIcon: widget.isName
            ? null
            : Text('\$ ', style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 14)),
        prefixIconConstraints: widget.isName ? null : BoxConstraints(minWidth: 0, minHeight: 0),
        errorStyle: TextStyle(height: 0.5),

        hintText: widget.isName ? "Expense name" : "123.45",
        hintStyle: widget.isName
            ? Centre.titleText.copyWith(color: const Color.fromARGB(255, 181, 181, 181))
            : Centre.semiTitleText.copyWith(color: Colors.grey),
        isDense: true,
      ),
    );
  }
}
