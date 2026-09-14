import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/utils/centre.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class ChooseColorDialog extends StatelessWidget {
  final List<Color> colorsToChooseFrom;
  final bool inSettingsPage;
  const ChooseColorDialog({super.key, required this.colorsToChooseFrom, required this.inSettingsPage});

  @override
  Widget build(BuildContext context) {
    Widget colourBtn(int i) {
      return GestureDetector(
        onTap: () {
          context.read<ChooseColorCubit>().selectColor(
            color: colorsToChooseFrom[i].toARGB32(),
            inSettingsPage: inSettingsPage,
          );
        },
        child: BlocBuilder<ChooseColorCubit, List<int>>(
          builder: (context, colorList) {
            return Container(
              width: 6.w,
              height: 6.w,
              decoration: BoxDecoration(
                color: colorsToChooseFrom[i],
                border: Border.all(color: Colors.white, width: 1.5),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: colorList.contains(colorsToChooseFrom[i].toARGB32())
                  ? Icon(Icons.check, size: 5.w, color: Centre.bgColor)
                  : null,
            );
          },
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
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

      width: 67.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          inSettingsPage
              ? SizedBox(height: 0)
              : BlocBuilder<ChooseColorCubit, List<int>>(
                  builder: (context, colorList) {
                    return Material(
                      color: Colors.transparent,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 1.5.h),
                        child: Ink(
                          decoration: colorList.isEmpty
                              ? null
                              : BoxDecoration(borderRadius: BorderRadius.circular(4), color: Centre.bgSplashColor),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(4),
                            onTap: () {
                              context.read<ChooseColorCubit>().selectColor(
                                color: Colors.transparent.toARGB32(),
                                inSettingsPage: inSettingsPage,
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 0.5.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.format_color_reset),
                                  SizedBox(width: 1.w),
                                  Text("Transparent"),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
          Wrap(
            spacing: 4.w,
            runSpacing: 1.5.h,
            children: [for (int i = 0; i < colorsToChooseFrom.length; i++) colourBtn(i)],
          ),
        ],
      ),
    );
  }
}
