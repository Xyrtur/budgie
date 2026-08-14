import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:budgie/utils/centre.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class YearPickerMenu extends StatefulWidget {
  final int startYear;
  final int endYear;
  final int initialYear;
  const YearPickerMenu({super.key, required this.startYear, required this.endYear, required this.initialYear});

  @override
  State<YearPickerMenu> createState() => YearPickerMenuState();
}

class YearPickerMenuState extends State<YearPickerMenu> with SingleTickerProviderStateMixin {
  late FixedExtentScrollController scrollController;

  late AnimationController controller;
  late Animation<double> heightAnimation;
  late DateTime selectedDate;
  late List<int> yearsToScroll;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);
    heightAnimation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    // Generate list of years
    yearsToScroll = List<int>.generate(widget.endYear - widget.startYear + 1, (index) => widget.startYear + index);
    selectedDate = DateTime(widget.initialYear);
    int initialIndex = yearsToScroll.indexOf(widget.initialYear);
    scrollController = FixedExtentScrollController(initialItem: initialIndex != -1 ? initialIndex : 0);
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
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
                  colors: [Color(0xff22263D), Color(0xff191C30), Color(0xff1E2135)],
                ),
              ),
              child: InkWell(
                splashColor: Centre.bgSplashColor,
                highlightColor: Centre.bgSplashColor,
                borderRadius: BorderRadius.circular(18),
                radius: 40,
                onTap: () {
                  controller.forward();
                  showAlignedDialog(
                    followerAnchor: Alignment.topCenter,

                    targetAnchor: Alignment.bottomCenter,

                    barrierColor: Colors.transparent,
                    offset: Offset(0, 1),
                    context: context,
                    builder: (BuildContext ycontext) {
                      return SizeTransition(
                        sizeFactor: heightAnimation,
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: EdgeInsets.all(1.h),
                          width: 20.w,
                          height: 15.h,
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
                          child: ListWheelScrollView.useDelegate(
                            controller: scrollController,
                            itemExtent: 42, // Height of each individual year row
                            perspective: 0.005, // Subtle 3D cylinder curve effect
                            diameterRatio: 1.2,
                            physics: const FixedExtentScrollPhysics(), // Snaps perfectly to items
                            onSelectedItemChanged: (index) {
                              setState(() {
                                selectedDate = DateTime(yearsToScroll[index]);
                              });
                            },

                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: yearsToScroll.length,
                              builder: (context, index) {
                                return Center(child: Text(yearsToScroll[index].toString(), style: Centre.listText));
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ).then((_) {
                    controller.reset();
                  });
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.5.h),

                  child: Row(
                    children: [
                      Text(selectedDate.year.toString(), style: Centre.semiTitle2Text),
                      SizedBox(width: 3.w),
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
      },
    );
  }
}
