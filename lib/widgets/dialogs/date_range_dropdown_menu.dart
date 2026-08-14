import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:budgie/utils/centre.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DateRangeDropDownMenu extends StatefulWidget {
  const DateRangeDropDownMenu({super.key});

  @override
  State<DateRangeDropDownMenu> createState() => _DateRangeDropDownMenuState();
}

class _DateRangeDropDownMenuState extends State<DateRangeDropDownMenu> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> heightAnimation;
  String selectedRole = "Jan 2024 - Current";
  final List<String> options = ["Jan 2024 - Current", "Jan 2023 - Dec 2023", "Jan 2022 - Dec 2022"];

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);
    heightAnimation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff131524),
        borderRadius: BorderRadius.circular(18),

        // Outer depth
        boxShadow: const [BoxShadow(color: Color(0xff080912), offset: Offset(4, 4), blurRadius: 3)],
      ),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),

            // Creates the "pressed" edge
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xff2A2F4A), Color(0xff22263D), Color(0xff282C46)],
            ),
          ),
          child: InkWell(
            splashColor: Centre.bgSplashColor,
            highlightColor: Centre.bgSplashColor,
            borderRadius: BorderRadius.circular(18),
            radius: 100,
            onTap: () {
              controller.forward();

              showAlignedDialog(
                followerAnchor: Alignment.topCenter,
                targetAnchor: Alignment.bottomCenter,
                barrierColor: Colors.transparent,
                offset: Offset(0, 4),
                context: context,
                builder: (BuildContext ycontext) {
                  return SizeTransition(
                    sizeFactor: heightAnimation,
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xff242943), Color(0xff1B1F33)],
                        ),
                        border: Border.all(color: const Color(0xff363B56)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.30),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: options.map((item) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedRole = item;
                                //TODO: reload all values for FixedCostFieldKeysCubit, LiveBudgetTotalTrackerCubit, FixedLabelsAndCostsCubit, CategoryBoxKeysCubit, CategoryBoxTextsCubit
                              });
                              controller.reset();
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
                              child: Text(item, style: Centre.semiTitle2Text),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ).then((_) {
                controller.reset();
              });
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(selectedRole, style: Centre.semiTitle2Text),
                  SizedBox(width: 4.w),
                  RotationTransition(
                    turns: Tween(begin: 0.0, end: 0.5).animate(heightAnimation),
                    child: const Icon(Icons.keyboard_arrow_down),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
