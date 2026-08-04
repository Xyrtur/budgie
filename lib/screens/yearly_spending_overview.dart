// ignore_for_file: dangling_library_doc_comments

import 'dart:math';

import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/screens/budget_planning.dart';
import 'package:budgie/utils/centre.dart';
import 'package:budgie/widgets/spending_overview/month_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class SpendingOverviewPage extends StatefulWidget {
  const SpendingOverviewPage({super.key});

  @override
  State<SpendingOverviewPage> createState() => _SpendingOverviewPageState();
}

class _SpendingOverviewPageState extends State<SpendingOverviewPage>
    with TickerProviderStateMixin {
  List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

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

  late final AnimationController controller = AnimationController(
    duration: const Duration(milliseconds: 1300),
    vsync: this,
  );
  late final Animation<double> animation = CurvedAnimation(
    parent: controller,
    curve: Curves.fastLinearToSlowEaseIn,
  );
  bool isPortrait = true;

  @override
  void initState() {
    super.initState();
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget categoryBoxes() {
    List<Color> categoryColors = List.generate(
      categories.length,
      (_) => Centre.colors[Random().nextInt(54)],
    );
    return BlocBuilder<SpendingCategoriesToggledCubit, List<String>>(
      builder: (_, categoriesToggled) {
        return Wrap(
          direction: MediaQuery.orientationOf(context) == Orientation.portrait
              ? Axis.horizontal
              : Axis.vertical,
          alignment: isPortrait ? WrapAlignment.center : WrapAlignment.start,
          runSpacing: 1.5.h,
          spacing: 5.w,
          children: [
            for (int i = 0; i < categories.length; i++)
              GestureDetector(
                onTap: () {
                  context.read<SpendingCategoriesToggledCubit>().toggleCategory(
                    categories[i],
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: categoriesToggled.contains(categories[i])
                        ? categoryColors[i]
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                    border: BoxBorder.all(
                      color: categoryColors[i],
                      width: 0.4.w,
                    ),
                  ),
                  child: Text(
                    categories[i],
                    style: Centre.listText.copyWith(
                      fontWeight: FontWeight.bold,
                      color: categoriesToggled.contains(categories[i])
                          ? Centre.bgColor
                          : categoryColors[i],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Centre.bgColor,
        body: Stack(
          children: [
            ConditionalScrollView(
              enabled: isPortrait,
              child: BlocBuilder<SpendingGraphViewToggleCubit, bool>(
                builder: (_, graphviewEnabled) {
                  return !graphviewEnabled
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: 6.h),
                            for (String i in months)
                              MonthTile(
                                month: i,
                                controller: controller,
                                animation: animation,
                              ),
                          ],
                        )
                      : RotatedBox(
                          quarterTurns: isPortrait ? 0 : 1,
                          child: isPortrait
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 8.h,
                                    horizontal: 4.w,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Container(
                                        color: Centre.colors[33],
                                        height: 35.h,
                                      ),
                                      SizedBox(height: 3.h),
                                      categoryBoxes(),
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 2.h,
                                    horizontal: 10.w,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(child: categoryBoxes()),
                                      Container(
                                        color: Colors.transparent,
                                        width: 50.h,
                                      ),
                                    ],
                                  ),
                                ),
                        );
                },
              ),
            ),
            RotatedBox(
              quarterTurns: isPortrait ? 0 : 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,

                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: SizedBox()),

                  DateRangeDropDownMenu(isPortrait: isPortrait),
                  !isPortrait
                      ? Expanded(child: Container(color: Colors.transparent))
                      : Expanded(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: IconButton.outlined(
                              onPressed: () {
                                context
                                    .read<SpendingGraphViewToggleCubit>()
                                    .toggle();
                              },
                              iconSize: 6.w,
                              color: Centre.accentColor,
                              icon: BlocBuilder<SpendingGraphViewToggleCubit, bool>(
                                builder: (_, graphviewEnabled) {
                                  return ClipOval(
                                    child: AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      reverseDuration: const Duration(
                                        milliseconds: 200,
                                      ),

                                      transitionBuilder:
                                          (
                                            Widget child,
                                            Animation<double> animation,
                                          ) {
                                            final isIncoming =
                                                child.key ==
                                                (graphviewEnabled
                                                    ? ValueKey(1)
                                                    : ValueKey(2));
                                            final offsetAnimation = Tween<Offset>(
                                              begin: isIncoming
                                                  ? const Offset(
                                                      0,
                                                      1,
                                                    ) // New icon starts below
                                                  : const Offset(0, -1),
                                              end: Offset.zero,
                                            ).animate(animation);
                                            return SlideTransition(
                                              position: offsetAnimation,
                                              child: child,
                                            );
                                          },
                                      child: graphviewEnabled
                                          ? Icon(
                                              Icons.auto_graph_sharp,
                                              key: ValueKey(1),
                                              color: Centre.colors[42],
                                            )
                                          : Icon(
                                              Icons.list,
                                              key: ValueKey(2),
                                              color: Centre.colors[42],
                                            ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),

            BlocBuilder<SpendingGraphViewToggleCubit, bool>(
              builder: (_, graphviewEnabled) {
                return graphviewEnabled
                    ? Align(
                        alignment: isPortrait
                            ? AlignmentGeometry.bottomRight
                            : AlignmentGeometry.bottomLeft,
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: 2.h,
                            right: 2.h,
                            left: isPortrait ? 0 : 2.h,
                          ),
                          child: IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: Centre.dialogBgColor,
                            ),
                            onPressed: () {
                              setState(() {
                                isPortrait = !isPortrait;
                              });
                            },
                            iconSize: 6.w,

                            icon: Icon(
                              Icons.screen_rotation_alt,
                              color: Centre.colors[33],
                            ),
                          ),
                        ),
                      )
                    : Align(
                        alignment: AlignmentGeometry.bottomLeft,
                        child: Container(
                          margin: EdgeInsets.only(left: 3.w, bottom: 2.h),
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                            vertical: 1.h,
                          ),
                          decoration: BoxDecoration(
                            color: Centre.bgColor,
                            border: Border.all(
                              color: Centre.colors[5],
                              width: 0.5.w,
                            ),
                          ),
                          child: Text("Over total"),
                        ),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ConditionalScrollView extends StatelessWidget {
  final bool enabled;
  final Widget child;

  const ConditionalScrollView({
    super.key,
    required this.enabled,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    return SingleChildScrollView(child: child);
  }
}
