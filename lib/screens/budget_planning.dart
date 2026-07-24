/*  Set limits for each budget category, as well as any fixed costs


*/
import 'package:budgie/utils/centre.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class BudgetPlanningPage extends StatefulWidget {
  const BudgetPlanningPage({super.key});

  @override
  State<BudgetPlanningPage> createState() => _BudgetPlanningPageState();
}

class _BudgetPlanningPageState extends State<BudgetPlanningPage> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> heightAnimation;
  bool _isOpen = false;
  String selectedRole = "Jan 2024 - Current";
  final List<String> options = ["Jan 2024 - Current", "Jan 2023 - Dec 2023", "Jan 2022 - Dec 2022"];

  void toggleMenu() {
    setState(() {
      if (_isOpen) {
        controller.reverse();
      } else {
        controller.forward();
      }
      _isOpen = !_isOpen;
    });
  }

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

  Widget dateRangeDropdownMenu() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Dropdown Header / Trigger Button
        GestureDetector(
          onTap: () {
            toggleMenu();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.5.h),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white, width: 0.2.w),
              ),
            ),
            child: Row(
              children: [
                Text(selectedRole, style: Centre.semiTitle2Text),
                SizedBox(width: 7.w),
                RotationTransition(
                  turns: Tween(begin: 0.0, end: 0.5).animate(heightAnimation),
                  child: const Icon(Icons.keyboard_arrow_down),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 0.5.h),
        SizeTransition(
          sizeFactor: heightAnimation,
          alignment: Alignment.topCenter,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Centre.dialogBgColor,
              boxShadow: [
                BoxShadow(
                  color: Centre.shadowbgColor, // Shadow color
                  spreadRadius: 1, // Extends the shadow past the box shape
                  blurRadius: 2, // Softens the shadow edges
                  offset: const Offset(-1, 4), // Positions shadow (x-axis, y-axis)
                ),
              ],
            ),
            child: Column(
              children: options.map((item) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedRole = item;
                    });
                    toggleMenu(); // Automatically close menu
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
                    child: Text(item, style: Centre.semiTitle2Text),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            if (_isOpen) {
              controller.reverse();
            }
            _isOpen = !_isOpen;
          });
        },
        child: Scaffold(
          backgroundColor: Centre.bgColor,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [dateRangeDropdownMenu()]),
            ],
          ),
        ),
      ),
    );
  }
}
