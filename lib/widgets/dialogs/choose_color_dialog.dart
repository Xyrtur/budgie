import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/utils/centre.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class ChooseColorDialog extends StatelessWidget {
  const ChooseColorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    Widget colourBtn(int i) {
      return GestureDetector(
        onTap: () {
          context.read<SettingsAddColorCubit>().selectColor(color: Centre.colors[i].toARGB32());
        },
        child: BlocBuilder<SettingsAddColorCubit, int?>(
          builder: (context, chosenColor) {
            return Container(
              width: 6.w,
              height: 6.w,
              decoration: BoxDecoration(
                color: Centre.colors[i],
                border: Border.all(color: Colors.white, width: 1.5),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: chosenColor == Centre.colors[i].toARGB32()
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
      child: Wrap(spacing: 4.w, runSpacing: 1.5.h, children: [for (int i = 0; i < 54; i++) colourBtn(i)]),
    );
  }
}
