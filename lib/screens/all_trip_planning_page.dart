import 'package:budgie/utils/centre.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AllTripPlanningPage extends StatelessWidget {
  const AllTripPlanningPage({super.key});

  @override
  Widget build(BuildContext context) {
    const List<String> tripNames = [
      "After Grad",
      "Europe",
      "Japan",
      "Australia Trip",
    ];

    return SafeArea(
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
                Expanded(child: SizedBox()),
                Text(
                  "Trip Planning",
                  textAlign: TextAlign.center,
                  style: Centre.titleText,
                ),

                Expanded(
                  child: Padding(
                    padding: EdgeInsetsGeometry.only(left: 3.w),
                    child: Align(
                      alignment: AlignmentGeometry.bottomLeft,
                      child: SortButton(),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              child: Divider(),
            ),
            Expanded(
              child: ListView(
                children: [
                  for (String i in tripNames)
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 1.h,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 1.5.h,
                        horizontal: 3.w,
                      ),
                      decoration: BoxDecoration(
                        color: Centre.dialogBgColor,
                        borderRadius: BorderRadius.circular(8),

                        boxShadow: [
                          BoxShadow(
                            color: Centre.shadowbgColor, // Shadow color
                            spreadRadius:
                                1, // Extends the shadow past the box shape
                            blurRadius: 2, // Softens the shadow edges
                            offset: const Offset(
                              -1,
                              4,
                            ), // Positions shadow (x-axis, y-axis)
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            i,
                            style: Centre.semiTitle2Text,
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            "Jul 2024 - Aug 2024",
                            style: Centre.listText.copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
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
    return IconButton.outlined(
      onPressed: () {
        setState(() {
          isAscending = !isAscending;
        });
      },
      iconSize: 6.w,
      color: Centre.accentColor,
      icon: AnimatedRotation(
        // 0.5 turns equals exactly 180 degrees flip
        turns: isAscending ? 0 : 0.5,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }
}
