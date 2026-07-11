import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/blocs/spending_overview_bloc.dart';
import 'package:budgie/screens/all_trip_planning_page.dart';
import 'package:budgie/screens/budget_planning.dart';
import 'package:budgie/screens/settings_page.dart';
import 'package:budgie/utils/centre.dart';
import 'package:budgie/widgets/bottom_nav_bar.dart';
import 'package:budgie/widgets/page_navigation_bar.dart';
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
        backgroundColor: Centre.bgColor,
        bottomNavigationBar: BottomAppBar(
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
                  navBarBtn(controller, PageSelected.TripPlanning, Icons.checklist, "Trip Planning", pageSelected),
                  SizedBox(width: 9.w),
                  navBarBtn(controller, PageSelected.BudgetPlanning, Icons.attach_money, "Set Budget", pageSelected),
                  navBarBtn(controller, PageSelected.UserSettings, Icons.settings, "Settings", pageSelected),
                ],
              );
            },
          ),
        ),
        floatingActionButton: Container(
          height: 15.w,
          width: 15.w,
          child: FloatingActionButton(
            shape: const CircleBorder(),
            onPressed: () {},
            backgroundColor: Centre.dialogBgColor,
            elevation: 5,
            child: Icon(Icons.add, color: Colors.white, size: 6.w),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Stack(
          children: [
            PageView(
              onPageChanged: (index) => context.read<NavbarCubit>().changePage(page: PageSelected.values[index]),
              controller: controller,
              children: [
                SpendingOverviewPage(), const AllTripPlanningPage(), const BudgetPlanningPage(), const SettingsPage(),
                // MultiBlocProvider(providers: [], child: SpendingOverviewPage()),
                // MultiBlocProvider(providers: [], child: const AllTripPlanningPage()),
                // MultiBlocProvider(providers: [], child: const BudgetPlanningPage()),
                // MultiBlocProvider(providers: [], child: const SettingsPage())
              ],
            ),
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
