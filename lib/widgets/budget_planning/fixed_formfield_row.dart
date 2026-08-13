import 'package:budgie/blocs/cubits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class FixedFormFieldRow extends StatefulWidget {
  final List<double> fixedCosts;
  final int index;
  final List<String> fixedLabels;

  const FixedFormFieldRow({super.key, required this.index, required this.fixedCosts, required this.fixedLabels});

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
    context.read<LiveBudgetTotalTrackerCubit>().updateTotal(value: budget + value);
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
