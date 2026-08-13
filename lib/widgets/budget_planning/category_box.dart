import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/utils/centre.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

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
    context.read<LiveBudgetTotalTrackerCubit>().updateTotal(value: budget + (double.tryParse(value) ?? 0));
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
