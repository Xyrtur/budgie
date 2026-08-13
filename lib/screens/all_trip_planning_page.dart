import 'package:budgie/utils/centre.dart';
import 'package:budgie/widgets/icon_button.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AllTripPlanningPage extends StatelessWidget {
  const AllTripPlanningPage({super.key});

  @override
  Widget build(BuildContext context) {
    const List<String> tripNames = ["After Grad", "Europe", "Japan", "Australia Trip"];

    return SafeArea(
      bottom: false,

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
                Spacer(),
                Text("Trip Planning", textAlign: TextAlign.center, style: Centre.titleText),

                Expanded(
                  child: Padding(
                    padding: EdgeInsetsGeometry.only(left: 3.w),
                    child: Align(alignment: AlignmentGeometry.bottomLeft, child: SortButton()),
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
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                      child: Ink(
                        decoration: BoxDecoration(
                          color: const Color(0xff131524),
                          borderRadius: BorderRadius.circular(8),

                          // Outer depth
                          boxShadow: const [
                            BoxShadow(color: Color(0xff080912), offset: Offset(4, 4), blurRadius: 5),
                            BoxShadow(color: Color(0xff1D1F32), offset: Offset(-4, -4), blurRadius: 5),
                          ],
                        ),

                        child: InkWell(
                          splashColor: Centre.bgSplashColor,
                          highlightColor: Centre.bgSplashColor,
                          borderRadius: BorderRadius.circular(8),

                          onTap: () async {
                            // await Navigator.of(context).push(MaterialPageRoute(builder: (context) => MonthlySpendingOverview(month: month)));
                          },

                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
                            child: Column(
                              children: [
                                Text(i, style: Centre.semiTitle2Text, textAlign: TextAlign.start),
                                Text("Jul 2024 - Aug 2024", style: Centre.listText.copyWith(color: Colors.grey)),
                              ],
                            ),
                          ),
                        ),
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
    return CustomIconButton(
      onTap: () {
        setState(() {
          isAscending = !isAscending;
        });
      },
      child: AnimatedRotation(
        // 0.5 turns equals exactly 180 degrees flip
        turns: isAscending ? 0 : 0.5,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Icon(Icons.arrow_upward, size: 6.w, color: Centre.primaryColor),
      ),
    );
  }
}
