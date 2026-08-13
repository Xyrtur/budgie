import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/widgets/dialogs/choose_color_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class ChooseColorBtn extends StatelessWidget {
  final int? color;
  final String? categoryName;
  const ChooseColorBtn({super.key, required this.color, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsAddColorCubit, int?>(
      builder: (_, chosenColor) {
        return Builder(
          builder: (context) {
            return GestureDetector(
              onTap: () {
                showAlignedDialog(
                  followerAnchor: Alignment.topRight,
                  targetAnchor: Alignment.bottomRight,
                  barrierColor: Colors.transparent,
                  offset: Offset(0, 1.h),
                  context: context,
                  builder: (BuildContext dialogContext) => BlocProvider<SettingsAddColorCubit>.value(
                    value: context.read<SettingsAddColorCubit>(),
                    child: const ChooseColorDialog(),
                  ),
                ).then((_) {
                  if (context.read<SettingsAddColorCubit>().state != null) {
                    // TODO: update category color
                    print(categoryName);
                  }
                });
              },
              child: Container(
                margin: EdgeInsets.only(right: 2.w),
                width: 6.w,
                height: 6.w,
                decoration: BoxDecoration(
                  color: Color(chosenColor ?? color!),
                  border: Border.all(color: Colors.white, width: 1.5),
                  borderRadius: const BorderRadius.all(Radius.circular(40)),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
