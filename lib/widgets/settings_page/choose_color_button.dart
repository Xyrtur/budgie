import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/utils/centre.dart';
import 'package:budgie/widgets/dialogs/choose_color_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class ChooseColorBtn extends StatelessWidget {
  final String? categoryName;
  final bool inTripsPage;
  final List<Color> colorsToChooseFrom;
  const ChooseColorBtn({super.key, required this.categoryName, this.inTripsPage = false, this.colorsToChooseFrom = Centre.colors});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChooseColorCubit, List<int>>(
      builder: (_, colorList) {
        return Builder(
          builder: (context) {
            return !inTripsPage
                ? GestureDetector(
                    onTap: () {
                      showAlignedDialog(
                        followerAnchor: Alignment.topRight,
                        targetAnchor: Alignment.bottomRight,
                        barrierColor: Colors.transparent,
                        offset: Offset(0, 1.h),
                        context: context,
                        builder: (BuildContext dialogContext) => BlocProvider<ChooseColorCubit>.value(
                          value: context.read<ChooseColorCubit>(),
                          child: ChooseColorDialog(colorsToChooseFrom: colorsToChooseFrom, inSettingsPage: true),
                        ),
                      ).then((_) {
                        // if (context.read<ChooseColorCubit>().state.isNotEmpty) {
                        //   // TODO: update category color in db
                        //   print(categoryName);
                        // }
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 2.w),
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        color: colorList.isEmpty ? Colors.transparent : Color(colorList[0]),
                        border: Border.all(color: Colors.white, width: 1.5),
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      // Stops focus from going back to text fields after dialog closes
                      FocusManager.instance.primaryFocus?.unfocus();

                      showAlignedDialog(
                        followerAnchor: Alignment.topLeft,
                        targetAnchor: Alignment.bottomLeft,
                        barrierColor: Colors.transparent,
                        offset: Offset(0, 1.h),
                        context: context,
                        builder: (BuildContext dialogContext) => BlocProvider<ChooseColorCubit>.value(
                          value: context.read<ChooseColorCubit>(),
                          child: ChooseColorDialog(colorsToChooseFrom: colorsToChooseFrom, inSettingsPage: false),
                        ),
                      ).then((_) {
                        if (context.read<ChooseColorCubit>().state.isNotEmpty) {
                          // TODO: update colors in trip records
                        }
                      });
                    },
                    child: colorList.isEmpty
                        ? Container(
                            width: 6.w,
                            height: 6.w,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(color: Colors.white, width: 1.5),
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                          )
                        : Row(
                            spacing: 2.w,
                            children: [
                              for (int color in colorList)
                                Container(
                                  width: 6.w,
                                  height: 6.w,
                                  decoration: BoxDecoration(
                                    color: Color(color),
                                    border: Border.all(color: Colors.white, width: 1.5),
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                  ),
                                ),
                            ],
                          ),
                  );
          },
        );
      },
    );
  }
}
