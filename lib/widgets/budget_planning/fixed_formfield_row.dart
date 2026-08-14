import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/utils/centre.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class FixedFormFieldRow extends StatefulWidget {
  final int index;
  final String labelText;
  final String costText;

  const FixedFormFieldRow({super.key, required this.labelText, required this.costText, required this.index});

  @override
  State<FixedFormFieldRow> createState() => FixedFormFieldRowState();
}

class FixedFormFieldRowState extends State<FixedFormFieldRow> {
  final TextEditingController labelController = TextEditingController();
  final FocusNode labelFocusNode = FocusNode();
  final TextEditingController costController = TextEditingController();
  final FocusNode costFocusNode = FocusNode();
  String previousCost = '';

  @override
  void initState() {
    super.initState();
    labelController.text = widget.labelText;
    costController.text = widget.costText;

    previousCost = costController.text;

    costFocusNode.addListener(() {
      if (!costFocusNode.hasFocus) {
        updateBudgetTotal(double.tryParse(costController.text) ?? 0);
      }
    });
  }

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
    budget -= double.tryParse(previousCost) ?? 0;
    context.read<LiveBudgetTotalTrackerCubit>().updateTotal(value: budget + value);
    previousCost = value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 2.w),

        IconButton(
          padding: EdgeInsets.all(2.w),
          onPressed: () {
            double budget = context.read<LiveBudgetTotalTrackerCubit>().state;

            budget -= double.tryParse(costController.text) ?? 0;

            context.read<LiveBudgetTotalTrackerCubit>().updateTotal(value: budget);
            context.read<FixedCostFieldKeysCubit>().delete(index: widget.index);
            context.read<FixedLabelsAndCostsCubit>().delete(index: widget.index);
          },
          icon: Icon(Icons.delete_outline, color: Centre.primaryColor),
        ),
        Expanded(
          child: TextFormField(
            textAlign: TextAlign.center,
            controller: labelController,
            focusNode: labelFocusNode,
            decoration: InputDecoration(
              hintText: 'Eg. Utility costs',
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.35)),
            ),
          ),
        ),
        SizedBox(width: 5.w),
        SizedBox(
          width: 15.w,
          child: TextFormField(
            controller: costController,
            focusNode: costFocusNode,
            textAlign: TextAlign.end,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixIcon: Text('\$ ', style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 13)),
              prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),

              hintText: '12.34',
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.35)),
            ),

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
