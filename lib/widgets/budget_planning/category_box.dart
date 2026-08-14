import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/utils/centre.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class CategoryBox extends StatefulWidget {
  final GlobalKey<CategoryBoxState> textFieldKey;
  final String categoryName;
  final Color categoryColor;
  final int categoryIndex;
  final String initialText;

  const CategoryBox({
    super.key,
    required this.textFieldKey,
    required this.categoryName,
    required this.categoryColor,
    required this.categoryIndex,
    required this.initialText,
  });

  @override
  State<CategoryBox> createState() => CategoryBoxState();
}

class CategoryBoxState extends State<CategoryBox> {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  String previousCost = '';

  void updateBudgetTotal(double value) {
    double budget = context.read<LiveBudgetTotalTrackerCubit>().state;
    budget -= double.tryParse(previousCost) ?? 0;
    context.read<LiveBudgetTotalTrackerCubit>().updateTotal(value: budget + value);
    previousCost = value.toString();
  }

  @override
  void initState() {
    super.initState();
    controller.text = widget.initialText;
    previousCost = widget.initialText;
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        updateBudgetTotal(double.tryParse(controller.text) ?? 0);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28.w,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Color.lerp(const Color(0xff20243A), widget.categoryColor, 0.02),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Color(0xff4A506F).withValues(alpha: 0.8)),

        boxShadow: [
          BoxShadow(
            color: Centre.shadowbgColor, // Shadow color
            blurRadius: 6, // Softens the shadow edges
            offset: const Offset(0, 4), // Positions shadow (x-axis, y-axis)
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: const Color(0xff292D46),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Color.lerp(const Color(0xff363B56), widget.categoryColor, 0.4)!),
            ),

            child: Text(widget.categoryName),
          ),
          TextFormField(
            key: widget.textFieldKey,
            controller: controller,
            focusNode: focusNode,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixIcon: Text('\$ ', style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 14)),
              prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
            ),
            onFieldSubmitted: (value) {
              updateBudgetTotal(double.tryParse(value) ?? 0);
            },
          ),
        ],
      ),
    );
  }
}
