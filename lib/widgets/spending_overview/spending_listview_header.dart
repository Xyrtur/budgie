import 'package:budgie/utils/centre.dart';
import 'package:budgie/widgets/spending_overview/toggle_graphview_button.dart';
import 'package:budgie/widgets/spending_overview/year_picker_menu.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SpendingListviewHeader extends StatelessWidget {
  const SpendingListviewHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 0.h),
      decoration: BoxDecoration(
        color: Centre.bgColor,
        border: Border(bottom: BorderSide(width: 1.5, color: Centre.dialogBgColor)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: Text("Spending Overview : ", style: Centre.titleText),
            ),
            YearPickerMenu(startYear: 2025, endYear: 2029, initialYear: 2026),
            Spacer(),
            ToggleGraphviewButton(),
          ],
        ),
      ),
    );
  }
}

class ConditionalScrollView extends StatelessWidget {
  final bool enabled;
  final Widget child;

  const ConditionalScrollView({super.key, required this.enabled, required this.child});
  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    return SingleChildScrollView(child: child);
  }
}
