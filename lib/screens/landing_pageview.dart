import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/screens/all_trip_planning_page.dart';
import 'package:budgie/screens/budget_planning.dart';
import 'package:budgie/screens/settings_page.dart';
import 'package:budgie/screens/yearly_spending_overview.dart';
import 'package:budgie/utils/centre.dart';
import 'package:budgie/widgets/bottom_nav_bar.dart';
import 'package:budgie/widgets/budget_planning/category_box.dart';
import 'package:budgie/widgets/budget_planning/fixed_formfield_row.dart';
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
            : BottomAppBar(
                height: 9.2.h,
                color: Centre.dialogBgColor,
                shape: CircularNotchedRectangle(),
                notchMargin: 0.8.h,
                child: BlocBuilder<NavbarCubit, PageSelected>(
                  builder: (_, pageSelected) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        navBarBtn(controller, PageSelected.Overview, Icons.auto_graph_sharp, "Overview", pageSelected),
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
              ),
        floatingActionButton: MediaQuery.of(context).viewInsets.bottom > 0
            ? null
            : BlocBuilder<FABIconCubit, IconData>(
                builder: (_, icon) {
                  return SizedBox(
                    height: 15.w,
                    width: 15.w,
                    child: FloatingActionButton(
                      shape: const CircleBorder(),
                      onPressed: () {},
                      backgroundColor: Centre.secondaryColor,
                      elevation: 5,

                      child: Icon(icon, color: Centre.offWhite, size: 6.w),
                    ),
                  );
                },
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
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
              ],
              child: const SpendingOverviewPage(),
            ),

            const AllTripPlanningPage(),
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
                BlocProvider<SettingsEditingTextCubit>(create: (context) => SettingsEditingTextCubit()),
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
