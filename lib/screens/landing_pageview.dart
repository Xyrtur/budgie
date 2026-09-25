import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/screens/all_trip_planning_page.dart';
import 'package:budgie/screens/budget_planning.dart';
import 'package:budgie/screens/settings_page.dart';
import 'package:budgie/screens/yearly_spending_overview.dart';
import 'package:budgie/utils/centre.dart';
import 'package:budgie/widgets/bottom_nav_bar.dart';
import 'package:budgie/widgets/budget_planning/category_box.dart';
import 'package:budgie/widgets/budget_planning/fixed_formfield_row.dart';
import 'package:budgie/widgets/dialogs/add_edit_expense_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class LandingPageView extends StatefulWidget {
  const LandingPageView({super.key});

  @override
  State<LandingPageView> createState() => _LandingPageViewState();
}

class _LandingPageViewState extends State<LandingPageView> {
  PageController controller = PageController(initialPage: 0);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: MediaQuery.of(context).viewInsets.bottom > 0
            ? null
            : BlocBuilder<WarmModeToggleCubit, bool>(
                builder: (_, warmModeToggled) {
                  return BottomAppBar(
                    height: 9.9.h,
                    color: warmModeToggled ? Color.fromARGB(255, 51, 46, 65) : Centre.navBarColor,
                    shape: CircularNotchedRectangle(),
                    notchMargin: 0.8.h,
                    child: BlocBuilder<NavbarCubit, PageSelected>(
                      builder: (_, pageSelected) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            navBarBtn(
                              controller,
                              PageSelected.Overview,
                              Icons.auto_graph_sharp,
                              "Overview",
                              pageSelected,
                            ),
                            navBarBtn(
                              controller,
                              PageSelected.TripPlanning,
                              Icons.checklist,
                              "Trip Planning",
                              pageSelected,
                            ),
                            SizedBox(width: 9.w),
                            navBarBtn(
                              controller,
                              PageSelected.BudgetPlanning,
                              Icons.attach_money,
                              "Set Budget",
                              pageSelected,
                            ),
                            navBarBtn(controller, PageSelected.UserSettings, Icons.settings, "Settings", pageSelected),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
        floatingActionButton: MediaQuery.of(context).viewInsets.bottom > 0
            ? null
            : BlocBuilder<FABIconCubit, PageSelected>(
                builder: (_, page) {
                  return SizedBox(
                    height: 15.w,
                    width: 15.w,
                    child: Builder(
                      builder: (context) {
                        return BlocBuilder<WarmModeToggleCubit, bool>(
                          builder: (_, warmModeToggled) {
                            return FloatingActionButton(
                              shape: const CircleBorder(),
                              onPressed: () {
                                switch (page) {
                                  // Case: Spending overview page
                                  case PageSelected.Overview:
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext dialogContext) {
                                        return MultiBlocProvider(
                                          providers: [
                                            BlocProvider<AddExpenseCategoryBtnsCubit>(
                                              create: (context) => AddExpenseCategoryBtnsCubit("Groceries"),
                                            ),
                                            BlocProvider<DatesSelectedCubit>(create: (context) => DatesSelectedCubit()),
                                            BlocProvider<IsIncomeToggleCubit>(
                                              create: (context) => IsIncomeToggleCubit(),
                                            ),
                                            BlocProvider<WarmModeToggleCubit>.value(
                                              value: context.read<WarmModeToggleCubit>(),
                                            ),
                                          ],
                                          child: AddEditExpenseDialog(editingExpense: null),
                                        );
                                      },
                                    );
                                  case PageSelected.TripPlanning:
                                  case PageSelected.BudgetPlanning:
                                  case PageSelected.UserSettings:
                                }
                              },
                              backgroundColor: warmModeToggled
                                  ? Color.fromARGB(255, 106, 71, 94)
                                  : Centre.secondaryColor,
                              elevation: 5,

                              child: Icon(
                                page == PageSelected.Overview || page == PageSelected.TripPlanning
                                    ? Icons.add
                                    : page == PageSelected.BudgetPlanning
                                    ? Icons.check
                                    : page == PageSelected.UserSettings
                                    ? Icons.import_export
                                    : null,
                                color: Centre.offWhite,
                                size: 6.w,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: PageView(
          onPageChanged: (index) {
            context.read<NavbarCubit>().changePage(page: PageSelected.values[index]);
            context.read<FABIconCubit>().changeIcon(page: PageSelected.values[index]);
          },
          controller: controller,
          children: [
            MultiBlocProvider(
              providers: [
                BlocProvider<SpendingCategoriesToggledCubit>(create: (context) => SpendingCategoriesToggledCubit()),
                BlocProvider<YearsSelectedCubit>(create: (context) => YearsSelectedCubit()),
                BlocProvider<ToggleCubit>(create: (context) => ToggleCubit()),
              ],
              child: const SpendingOverviewPage(),
            ),
            MultiBlocProvider(
              providers: [BlocProvider<TempTripRecordsCubit>(create: (context) => TempTripRecordsCubit())],
              child: const AllTripPlanningPage(),
            ),

            MultiBlocProvider(
              providers: [
                BlocProvider<LiveBudgetTotalTrackerCubit>(
                  create: (context) {
                    double startingTotal = 0;
                    for (double i in [150, 37.25, 5.25]) {
                      startingTotal += i;
                    }
                    for (double i in [0, 0, 0, 0, 0, 0, 0, 0]) {
                      startingTotal += i;
                    }
                    return LiveBudgetTotalTrackerCubit(startingTotal);
                  },
                ),
                BlocProvider<FixedCostFieldKeysCubit>(
                  create: (context) {
                    List<GlobalKey<FixedFormFieldRowState>> newList = [];
                    for (int i = 0; i < 3; i++) {
                      newList.add(GlobalKey<FixedFormFieldRowState>());
                    }
                    return FixedCostFieldKeysCubit(newList);
                  },
                ),
                BlocProvider<FixedLabelsAndCostsCubit>(
                  create: (context) {
                    List<String> newList = [];
                    newList.addAll(["utilities", "150", "phone", "37.25", "spotify", "5.25"]);

                    return FixedLabelsAndCostsCubit(newList);
                  },
                ),
                BlocProvider<CategoryBoxKeysCubit>(
                  create: (context) {
                    List<GlobalKey<CategoryBoxState>> newList = [];
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
                    for (int i = 0; i < categories.length; i++) {
                      newList.add(GlobalKey<CategoryBoxState>());
                    }
                    return CategoryBoxKeysCubit(newList);
                  },
                ),
                BlocProvider<CategoryBoxTextsCubit>(
                  create: (context) {
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

                    Map<String, String> newMap = {};
                    for (int i = 0; i < categories.length; i++) {
                      newMap[categories[i]] = "";
                    }
                    return CategoryBoxTextsCubit(newMap);
                  },
                ),
              ],
              child: BudgetPlanningPage(),
            ),

            MultiBlocProvider(
              providers: [
                BlocProvider<TempIncludeFixedCubit>(create: (context) => TempIncludeFixedCubit()),
                BlocProvider<TempEditingDateRangesCubit>(create: (context) => TempEditingDateRangesCubit()),
                BlocProvider<AddingDateRangeCubit>(create: (context) => AddingDateRangeCubit()),
                BlocProvider<ToggleCubit>(create: (context) => ToggleCubit()),
                BlocProvider<SettingsEditingTextCubit>(create: (context) => SettingsEditingTextCubit()),
                BlocProvider<ExpenseAccountCubit>(create: (context) => ExpenseAccountCubit(accountName: "")),
                BlocProvider<EditingSavingsTextsCubit>(create: (context) => EditingSavingsTextsCubit()),
              ],
              child: SettingsPage(),
            ),

            // MultiBlocProvider(providers: [], child: SpendingOverviewPage()),
            // MultiBlocProvider(providers: [], child: const AllTripPlanningPage()),

            //

            // MultiBlocProvider(providers: [], child: const SettingsPage())
          ],
        ),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class ConditionalWarmFilter extends StatelessWidget {
  final bool enabled;
  final Widget child;

  const ConditionalWarmFilter({super.key, required this.enabled, required this.child});
  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    return ColorFiltered(
      colorFilter: const ColorFilter.matrix([
        0.432,
        0.374,
        0.038,
        0,
        0,
        0.111,
        0.657,
        0.031,
        0,
        0,
        0.023,
        0.076,
        0.711,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
      ]),
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          const Color.fromARGB(255, 187, 159, 168).withValues(alpha: enabled ? 0.8 : 0),
          BlendMode.softLight,
        ),
        child: child,
      ),
    );
  }
}
