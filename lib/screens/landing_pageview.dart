import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/blocs/spending_overview_bloc.dart';
import 'package:budgie/screens/all_trip_planning_page.dart';
import 'package:budgie/screens/budget_planning.dart';
import 'package:budgie/screens/settings_page.dart';
import 'package:budgie/utils/centre.dart';
import 'package:budgie/widgets/page_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LandingPageView extends StatefulWidget {
  const LandingPageView({super.key});

  @override
  State<LandingPageView> createState() => _LandingPageViewState();
}

class _LandingPageViewState extends State<LandingPageView> {
  PageController controller = PageController(
    initialPage: 0,
  );

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
        body: Stack(
          children: [
            PageView(
              onPageChanged: (index) => context.read<NavbarCubit>().changePage(page: PageSelected.values[index]),
              controller: controller,
              children: [
                MultiBlocProvider(providers: [], child: SpendingOverviewPage()),
                MultiBlocProvider(providers: [], child: const AllTripPlanningPage()),
                MultiBlocProvider(providers: [], child: const BudgetPlanningPage()),
                MultiBlocProvider(providers: [], child: const SettingsPage())
              ],
            ),
            PageNavigationBar(
              pageController: controller,
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
