import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/utils/centre.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class MultiYearPickerDialog extends StatefulWidget {
  final int startYear;
  final int endYear;
  final List<int> initialYears;
  final bool isPortrait;
  const MultiYearPickerDialog({super.key, required this.endYear, required this.startYear, required this.initialYears, required this.isPortrait});

  @override
  State<MultiYearPickerDialog> createState() => _MultiYearPickerDialogState();
}

class _MultiYearPickerDialogState extends State<MultiYearPickerDialog> {
  late final List<int> years;
  final List<int> yearsSelected = [];

  @override
  void initState() {
    super.initState();
    years = List<int>.generate(widget.endYear - widget.startYear + 1, (int index) => index + widget.startYear);
    yearsSelected.addAll(widget.initialYears);
  }

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: widget.isPortrait ? 0 : 1,
      child: AlertDialog(
        contentPadding: EdgeInsets.only(left: 4.w, top: 3.h, right: 4.w, bottom: 1.h),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
        backgroundColor: Centre.dialogBgColor,
        elevation: 0,
        content: SizedBox(
          width: widget.isPortrait ? 65.w : 75.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Text("View Expenses From", style: Centre.semiTitle2Text),
              Divider(),
              SizedBox(height: 2.h),
              Wrap(
                spacing: 5.w,
                runSpacing: 2.h,
                children: [
                  for (int year in years)
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      splashColor: Color(0xFF8F647F),

                      onTap: () {
                        setState(() {
                          if (yearsSelected.contains(year)) {
                            yearsSelected.remove(year);
                          } else {
                            yearsSelected.add(year);
                          }
                        });
                      },
                      child: Ink(
                        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
                        decoration: BoxDecoration(
                          color: yearsSelected.contains(year) ? Centre.accentColor : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: BoxBorder.all(color: Centre.accentColor, width: 0.4.w),
                        ),
                        child: Text(
                          year.toString(),
                          style: Centre.listText.copyWith(
                            fontSize: widget.isPortrait ? 14.sp : 13.5.sp,
                            fontWeight: FontWeight.w400,
                            color: yearsSelected.contains(year) ? Centre.bgColor : Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 1.h),

              TextButton(
                onPressed: () {
                  context.read<YearsSelectedCubit>().updateSelectedYears(yearsSelected);
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  child: Text("OK"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
