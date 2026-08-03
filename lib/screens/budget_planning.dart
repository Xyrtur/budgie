/*  Set limits for each budget category, as well as any fixed costs


*/
import 'dart:math';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/utils/centre.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class BudgetPlanningPage extends StatefulWidget {
  const BudgetPlanningPage({super.key});

  @override
  State<BudgetPlanningPage> createState() => _BudgetPlanningPageState();
}

class _BudgetPlanningPageState extends State<BudgetPlanningPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> heightAnimation;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String selectedRole = "Jan 2024 - Current";
  final List<String> options = [
    "Jan 2024 - Current",
    "Jan 2023 - Dec 2023",
    "Jan 2022 - Dec 2022",
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
  ];
  double currentBudget = 0;
  List<double> fixedFormFieldCostValues = [];
  List<String> fixedFormFieldLabelValues = [];
  List<double> categoryCostValues = [];

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    heightAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );
    categoryCostValues = List.generate(categories.length, (_) => 0);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget dateRangeDropdownMenu() {
    return Builder(
      builder: (context) {
        return GestureDetector(
          onTap: () {
            controller.forward();
            showAlignedDialog(
              followerAnchor: Alignment.topLeft,
              targetAnchor: Alignment.bottomLeft,
              barrierColor: Colors.transparent,
              offset: Offset(0, 1.h),
              avoidOverflow: true,
              context: context,
              builder: (BuildContext ycontext) {
                return SizeTransition(
                  sizeFactor: heightAnimation,
                  alignment: Alignment.topCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Centre.dialogBgColor,
                      boxShadow: [
                        BoxShadow(
                          color: Centre.shadowbgColor, // Shadow color
                          spreadRadius:
                              1, // Extends the shadow past the box shape
                          blurRadius: 2, // Softens the shadow edges
                          offset: const Offset(
                            -1,
                            4,
                          ), // Positions shadow (x-axis, y-axis)
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: options.map((item) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedRole = item;
                            });
                            controller.reset();
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 1.5.h,
                            ),
                            child: Text(item, style: Centre.semiTitle2Text),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ).then((_) {
              controller.reset();
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.5.h),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white, width: 0.2.w),
              ),
            ),
            child: Row(
              children: [
                Text(selectedRole, style: Centre.semiTitle2Text),
                SizedBox(width: 7.w),
                RotationTransition(
                  turns: Tween(begin: 0.0, end: 0.5).animate(heightAnimation),
                  child: const Icon(Icons.keyboard_arrow_down),
                ),
              ],
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
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [dateRangeDropdownMenu()],
              ),
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
                      return Text(
                        "Monthly Budget: ${currentBudget.toStringAsFixed(2)}",
                      );
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
                        for (
                          var i = 0;
                          i < fixedFormFieldCostValues.length;
                          i++
                        )
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

class FixedFormFieldRow extends StatefulWidget {
  final List<double> fixedCosts;
  final int index;
  final List<String> fixedLabels;

  const FixedFormFieldRow({
    super.key,
    required this.index,
    required this.fixedCosts,
    required this.fixedLabels,
  });

  @override
  State<FixedFormFieldRow> createState() => _FixedFormFieldRowState();
}

class _FixedFormFieldRowState extends State<FixedFormFieldRow> {
  final TextEditingController labelController = TextEditingController();
  final FocusNode labelFocusNode = FocusNode();
  final TextEditingController costController = TextEditingController();
  final FocusNode costFocusNode = FocusNode();

  @override
  void dispose() {
    labelController.dispose();
    labelFocusNode.dispose();
    costController.dispose();
    costFocusNode.dispose();
    super.dispose();
  }

  void updateBudgetTotal(double value) {
    double budget = context.read<LiveBudgetTotalTrackerCubit>().state;
    budget -= widget.fixedCosts[widget.index];
    widget.fixedCosts[widget.index] = value;
    context.read<LiveBudgetTotalTrackerCubit>().updateTotal(
      value: budget + value,
    );
  }

  @override
  Widget build(BuildContext context) {
    labelFocusNode.addListener(() {
      if (!labelFocusNode.hasFocus) {
        widget.fixedLabels[widget.index] = labelController.text;
      }
    });
    costFocusNode.addListener(() {
      if (!costFocusNode.hasFocus) {
        updateBudgetTotal(double.tryParse(costController.text) ?? 0);
      }
    });
    return Row(
      children: [
        SizedBox(width: 2.w),
        IconButton(
          padding: EdgeInsets.all(2.w),
          onPressed: () {
            setState(() {
              widget.fixedCosts.removeAt(widget.index);
              widget.fixedLabels.removeAt(widget.index);
            });
          },
          icon: Icon(Icons.delete_outline),
        ),
        Expanded(
          child: TextFormField(
            textAlign: TextAlign.center,
            controller: labelController,
            focusNode: labelFocusNode,
            onFieldSubmitted: (value) {
              widget.fixedLabels[widget.index] = value;
            },
          ),
        ),
        SizedBox(width: 5.w),
        SizedBox(
          width: 15.w,
          child: TextFormField(
            controller: costController,
            focusNode: costFocusNode,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,

            onFieldSubmitted: (value) {
              updateBudgetTotal(double.tryParse(value) ?? 0);
            },
          ),
        ),
        SizedBox(width: 2.w),
      ],
    );
  }
}

class CategoryBox extends StatefulWidget {
  final String categoryName;
  final Color categoryColor;
  final List<double> categoryCosts;
  final int categoryIndex;

  const CategoryBox({
    super.key,
    required this.categoryName,
    required this.categoryColor,
    required this.categoryCosts,
    required this.categoryIndex,
  });

  @override
  State<CategoryBox> createState() => _CategoryBoxState();
}

class _CategoryBoxState extends State<CategoryBox> {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  void updateBudgetTotal(String value) {
    double budget = context.read<LiveBudgetTotalTrackerCubit>().state;
    budget -= widget.categoryCosts[widget.categoryIndex];
    widget.categoryCosts[widget.categoryIndex] = double.tryParse(value) ?? 0;
    context.read<LiveBudgetTotalTrackerCubit>().updateTotal(
      value: budget + (double.tryParse(value) ?? 0),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        updateBudgetTotal(controller.text);
      }
    });
    return Container(
      width: 28.w,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Centre.dialogBgColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white),

        boxShadow: [
          BoxShadow(
            color: Centre.shadowbgColor, // Shadow color
            spreadRadius: 1, // Extends the shadow past the box shape
            blurRadius: 2, // Softens the shadow edges
            offset: const Offset(-1, 4), // Positions shadow (x-axis, y-axis)
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              border: Border.all(color: widget.categoryColor),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(widget.categoryName),
          ),
          Row(
            children: [
              Text("\$", style: Centre.listText),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  onFieldSubmitted: (value) {
                    updateBudgetTotal(value);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
