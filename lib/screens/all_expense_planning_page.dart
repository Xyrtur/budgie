import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/screens/landing_pageview.dart';
import 'package:budgie/screens/expense_planning_page.dart';
import 'package:budgie/utils/centre.dart';
import 'package:budgie/utils/datetime_ext.dart';
import 'package:budgie/widgets/icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class AllExpensePlanningPage extends StatelessWidget {
  const AllExpensePlanningPage({super.key});

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
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 2.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      Text("Expense Planning", textAlign: TextAlign.center, style: Centre.titleText),

                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsGeometry.only(left: 3.w),
                          child: Align(alignment: AlignmentGeometry.bottomLeft, child: SortButton()),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                    child: Divider(),
                  ),
                  BlocBuilder<TempTripRecordsCubit, Map<String, List<Record>>>(
                    builder: (_, plans) {
                      return Expanded(
                        child: ListView(
                          children: [
                            for (String i in plans.keys)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    color: Centre.cardColor,
                                    borderRadius: BorderRadius.circular(8),

                                    // Outer depth
                                    boxShadow: [
                                      BoxShadow(
                                        color: Centre.shadowbgColor,
                                        offset: Offset(0, 2),
                                        blurRadius: 6,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),

                                  child: InkWell(
                                    splashColor: Centre.bgSplashColor,
                                    highlightColor: Centre.bgSplashColor,
                                    borderRadius: BorderRadius.circular(8),

                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => MultiBlocProvider(
                                            providers: [
                                              BlocProvider.value(value: context.read<TempTripRecordsCubit>()),
                                              BlocProvider.value(value: context.read<WarmModeToggleCubit>()),
                                            ],
                                            child: ConditionalWarmFilter(
                                              enabled: context.read<WarmModeToggleCubit>().state,
                                              child: ExpensePlanningPage(
                                                planName: i,
                                                recordList: plans[i]!,
                                                startDate: DateTime.now(),
                                                endDate: DateTime.now(),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },

                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
                                      child: Column(
                                        children: [
                                          Text(i, style: Centre.semiTitle2Text, textAlign: TextAlign.start),
                                          Text(
                                            DateTime.now().add(Duration(days: 60)).isSameDate(other: DateTime.now())
                                                ? DateFormat('MMM, y').format(DateTime.now())
                                                : "${DateFormat('MMM, y').format(DateTime.now())} - ${DateFormat('MMM, y').format(DateTime.now().add(Duration(days: 60)))}",
                                            style: Centre.listText.copyWith(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class SortButton extends StatefulWidget {
  const SortButton({super.key});

  @override
  State<SortButton> createState() => _SortButtonState();
}

class _SortButtonState extends State<SortButton> {
  bool isAscending = false; // Show most recent dates first

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      onTap: () {
        setState(() {
          isAscending = !isAscending;
        });
      },
      child: AnimatedRotation(
        // 0.5 turns equals exactly 180 degrees flip
        turns: isAscending ? 0 : 0.5,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Icon(Icons.arrow_upward, size: 6.w, color: Centre.primaryColor),
      ),
    );
  }
}
