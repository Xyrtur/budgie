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
    return GestureDetector(
      onTap: () {
        controller.forward();

        showAlignedDialog(
          followerAnchor: Alignment.topCenter,
          targetAnchor: Alignment.bottomCenter,
          barrierColor: Colors.transparent,
          context: context,
          builder: (BuildContext ycontext) {
            return SizeTransition(
              sizeFactor: heightAnimation,
              alignment: Alignment.bottomCenter,
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
                  mainAxisSize: MainAxisSize.min,
                  children: options.map((item) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedRole = item;
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
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.white, width: 0.2.w),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
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
    );
  }
}
