import 'package:budgie/utils/centre.dart';
import 'package:budgie/widgets/spending_overview/toggle_graphview_button.dart';
import 'package:budgie/widgets/spending_overview/year_picker_menu.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SpendingListviewHeader extends StatelessWidget {
  final bool isPortrait;
  const SpendingListviewHeader({super.key, required this.isPortrait});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 1.h),
      decoration: BoxDecoration(
        color: Centre.bgColor,
        border: Border(bottom: BorderSide(width: 1.5, color: Centre.dialogBgColor)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
              child: Text("Spending Overview : ", style: Centre.semiTitleText),
            ),
            YearPickerMenu(startYear: 2025, endYear: 2029, initialYear: 2026),
            Spacer(),
            !isPortrait ? SizedBox() : ToggleGraphviewButton(),
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
