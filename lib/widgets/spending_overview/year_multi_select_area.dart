import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/utils/centre.dart';
import 'package:budgie/widgets/dialogs/multi_year_picker_dialog.dart';
import 'package:budgie/widgets/icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class YearMultiSelectArea extends StatefulWidget {
  final bool isPortrait;
  final bool expandWithinRow;
  const YearMultiSelectArea({super.key, required this.isPortrait, required this.expandWithinRow});

  @override
  State<YearMultiSelectArea> createState() => _YearMultiSelectAreaState();
}

class _YearMultiSelectAreaState extends State<YearMultiSelectArea> {
  final ScrollController yearScrollController = ScrollController();

  @override
  void dispose() {
    yearScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Wanted to return both icon button and scrolling area in one widget, so had to wrap with expanded + row
    return Expanded(
      flex: widget.expandWithinRow ? 1 : 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconButton(
            onTap: () {
              showDialog(
                context: context,
                builder: (unUsedContext) => BlocProvider.value(
                  value: context.read<YearsSelectedCubit>(),
                  child: MultiYearPickerDialog(
                    startYear: 2025,
                    endYear: 2035,
                    initialYears: context.read<YearsSelectedCubit>().state.keys.toList(), // pre-selected items
                    isPortrait: widget.isPortrait,
                  ),
                ),
              );
            },
            child: Icon(Icons.calendar_month, size: 6.w, color: Centre.primaryColor),
          ),
          SizedBox(width: 3.w),
          BlocBuilder<YearsSelectedCubit, Map<int, bool>>(
            builder: (_, yearsSelected) {
              return Expanded(
                child: ScrollbarTheme(
                  data: ScrollbarThemeData(
                    thumbColor: WidgetStateProperty.all(Centre.dialogBgColor),
                    trackBorderColor: WidgetStateProperty.all(Centre.scrollTrackColor),
                    thickness: WidgetStateProperty.all(4.0),
                    radius: const Radius.circular(8),
                    trackColor: WidgetStateProperty.all(Centre.scrollTrackColor),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: MediaQuery.removePadding(
                      context: context,
                      removeBottom: true,
                      child: Scrollbar(
                        thumbVisibility: true,
                        trackVisibility: true,

                        controller: yearScrollController,
                        child: SingleChildScrollView(
                          controller: yearScrollController,
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: widget.isPortrait ? 2.h : 1.5.h),
                            child: Row(
                              spacing: 5.w,

                              children: [
                                for (MapEntry<int, bool> e in yearsSelected.entries)
                                  GestureDetector(
                                    onTap: () => context.read<YearsSelectedCubit>().toggleYear(e.key),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(e.key.toString(), style: Centre.listText.copyWith(fontSize: 15.sp)),

                                        Container(
                                          height: 4.5.w,
                                          width: 4.5.w,
                                          margin: EdgeInsets.only(top: 0.5.h),
                                          decoration: BoxDecoration(
                                            color: e.value ? Centre.secondaryColor : Colors.transparent,
                                            borderRadius: BorderRadius.circular(3),
                                            border: BoxBorder.all(width: 1.5, color: Centre.secondaryColor),
                                          ),
                                          child: e.value ? Icon(Icons.check, size: 4.w, color: Centre.offWhite) : null,
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
