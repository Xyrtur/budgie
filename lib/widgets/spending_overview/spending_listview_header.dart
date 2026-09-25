import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/utils/centre.dart';
import 'package:budgie/widgets/spending_overview/toggle_graphview_button.dart';
import 'package:budgie/widgets/spending_overview/year_picker_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class SpendingListviewHeader extends StatelessWidget {
  SpendingListviewHeader({super.key});
  final Map<String, double> savings = {"Emerg": 12345, "Savings": 15647.56, "Total": 34000};
  final bool showTotal = true;

  final NumberFormat numberFormat = NumberFormat("#,##0.00", "en_US");
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Centre.bgSplashColor,
        highlightColor: Centre.bgSplashColor,
        onTap: () {
          context.read<ToggleCubit>().toggle();
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 350),
          curve: Curves.fastLinearToSlowEaseIn,
          padding: EdgeInsets.only(bottom: 0.h),
          color: Centre.bgColor,

          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Spending Overview : ", style: Centre.titleText),

                      BlocProvider.value(
                        value: context.read<WarmModeToggleCubit>(),
                        child: YearPickerMenu(startYear: 2025, endYear: 2029, initialYear: 2026),
                      ),
                      Spacer(),
                      ToggleGraphviewButton(),
                    ],
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.fastLinearToSlowEaseIn,
                  child: BlocBuilder<ToggleCubit, bool>(
                    builder: (_, isToggled) {
                      return isToggled
                          ? Padding(
                              padding: EdgeInsets.only(top: 2.h, left: 3.w, right: 3.w),
                              child: Wrap(
                                runSpacing: 1.h,
                                spacing: 8.w,
                                alignment: WrapAlignment.center,
                                children: [
                                  for (MapEntry<String, double> e in savings.entries)
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "${e.key} ",
                                          style: Centre.semiTitle2Text.copyWith(fontWeight: FontWeight.bold),
                                        ),

                                        Text(
                                          "\$${numberFormat.format(e.value)}",
                                          style: Centre.titleText.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: Centre.offWhite,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            )
                          : SizedBox();
                    },
                  ),
                ),
                BlocBuilder<ToggleCubit, bool>(
                  builder: (_, isToggled) {
                    return Padding(
                      padding: EdgeInsets.only(top: 1.h),
                      child: Text(
                        !isToggled ? "Show savings" : "Hide savings",
                        style: Centre.listText.copyWith(fontSize: 14.sp, fontStyle: FontStyle.italic),
                      ),
                    );
                  },
                ),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ConditionalScrollView extends StatelessWidget {
  final ScrollController controller;
  final bool enabled;
  final Widget child;

  const ConditionalScrollView({super.key, required this.enabled, required this.child, required this.controller});
  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    return SingleChildScrollView(controller: controller, child: child);
  }
}
