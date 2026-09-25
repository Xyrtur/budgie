import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/screens/landing_pageview.dart';
import 'package:budgie/utils/centre.dart';
import 'package:budgie/widgets/settings_page/budget_planning_periods_section.dart';
import 'package:budgie/widgets/settings_page/manage_categories_section.dart';
import 'package:budgie/widgets/settings_page/savings_balances_section.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final GlobalKey<FormState> categoriesFormKey = GlobalKey<FormState>();

  final GlobalKey<FormState> savingsFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WarmModeToggleCubit, bool>(
      builder: (_, warmModeToggled) {
        return ConditionalWarmFilter(
          enabled: warmModeToggled,
          child: SafeArea(
            bottom: false,
            child: Scaffold(
              backgroundColor: Centre.bgColor,
              body: Builder(
                builder: (context) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
                      child: Column(
                        children: [
                          Text("Settings", style: Centre.titleText),
                          SizedBox(height: 0.5.h),
                          Divider(),
                          BlocBuilder<TempIncludeFixedCubit, bool>(
                            builder: (_, enabled) {
                              return GestureDetector(
                                onTap: () {
                                  context.read<TempIncludeFixedCubit>().toggle();
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(top: 1.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Transform.scale(
                                        scale: 0.8,
                                        child: Switch(
                                          thumbIcon: Centre.thumbIcon,
                                          thumbColor: Centre.thumbColor,
                                          trackColor: Centre.trackColor,
                                          trackOutlineColor: Centre.trackOutlineColor,

                                          value: enabled,
                                          onChanged: (bool value) {
                                            context.read<TempIncludeFixedCubit>().toggle();
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 3.w),
                                      Text("Include Fixed Costs in Bar Graphs", style: Centre.semiTitle2Text),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          BlocBuilder<WarmModeToggleCubit, bool>(
                            builder: (_, enabled) {
                              return GestureDetector(
                                onTap: () {
                                  context.read<WarmModeToggleCubit>().toggle();
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 2.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Transform.scale(
                                        scale: 0.8,
                                        child: Switch(
                                          thumbIcon: Centre.thumbIcon,
                                          thumbColor: Centre.thumbColor,
                                          trackColor: Centre.trackColor,
                                          trackOutlineColor: Centre.trackOutlineColor,

                                          value: enabled,
                                          onChanged: (bool value) {
                                            context.read<WarmModeToggleCubit>().toggle();
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 3.w),
                                      Text("Toggle warm mode", style: Centre.semiTitle2Text),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          ManageCategoriesSection(formKey: categoriesFormKey),
                          SizedBox(height: 4.h),

                          BudgetPlanningPeriodsSection(),
                          SizedBox(height: 4.h),

                          SavingsBalancesSection(formKey: savingsFormKey),
                          SizedBox(height: 15.h),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
