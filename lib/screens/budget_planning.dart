/*  Set limits for each budget category, as well as any fixed costs


*/
import 'package:budgie/utils/centre.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class BudgetPlanningPage extends StatelessWidget {
  const BudgetPlanningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Centre.bgColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [DateRangeDropdownMenu()],
            ),
          ],
        ),
      ),
    );
  }
}

class DateRangeDropdownMenu extends StatefulWidget {
  const DateRangeDropdownMenu({super.key});

  @override
  State<DateRangeDropdownMenu> createState() => _DateRangeDropdownMenuState();
}

class _DateRangeDropdownMenuState extends State<DateRangeDropdownMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> heightAnimation;
  bool _isOpen = false;
  String selectedRole = "Jan 2024 - Current";
  final List<String> options = [
    "Jan 2024 - Current",
    "Jan 2023 - Dec 2023",
    "Jan 2022 - Dec 2022",
  ];

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
    controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    heightAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Dropdown Header / Trigger Button
        GestureDetector(
          onTap: () {
            toggleMenu();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white, width: 0.2.w),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(selectedRole, style: Centre.semiTitle2Text),
                RotationTransition(
                  turns: Tween(begin: 0.0, end: 0.5).animate(heightAnimation),
                  child: const Icon(Icons.keyboard_arrow_down),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 2.h),
        SizeTransition(
          sizeFactor: heightAnimation,
          alignment: Alignment.topCenter,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Centre.shadowbgColor, // Shadow color
                  spreadRadius: 1, // Extends the shadow past the box shape
                  blurRadius: 2, // Softens the shadow edges
                  offset: const Offset(
                    -1,
                    4,
                  ), // Positions shadow (x-axis, y-axis)
                ),
              ],
            ),
            child: Column(
              children: options.map((item) {
                return ListTile(
                  title: Text(item),
                  onTap: () {
                    setState(() {
                      selectedRole = item;
                    });
                    toggleMenu(); // Automatically close menu
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
