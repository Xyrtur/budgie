import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/utils/centre.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class CustomMonthPicker extends StatefulWidget {
  final DateTime? dateSelected;
  const CustomMonthPicker({super.key, this.dateSelected});

  @override
  State<CustomMonthPicker> createState() => CustomMonthPickerState();
}

class CustomMonthPickerState extends State<CustomMonthPicker> {
  final DateTime firstDate = DateTime.now().subtract(Duration(days: 700));
  final DateTime lastDate = DateTime.now().add(Duration(days: 700));
  DateTime dateChosen = DateTime.now();

  @override
  void initState() {
    super.initState();

    dateChosen = widget.dateSelected ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      backgroundColor: Centre.dialogBgColor,
      elevation: 1,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 30.h,
            child: MonthPicker.single(
              datePickerStyles: DatePickerStyles(
                selectedDateStyle: Centre.semiTitle2Text,
                selectedSingleDateDecoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Centre.accentColor),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              selectedDate: dateChosen,

              onChanged: (value) {
                setState(() {
                  dateChosen = value;
                });
              },
              firstDate: firstDate,
              lastDate: lastDate,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, dateChosen);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Text("OK"),
            ),
          ),
        ],
      ),
    );
  }
}

class MonthYearAddingRangeButton extends StatelessWidget {
  final bool isStartDate;
  final ValueNotifier<List<DateTime?>> dialogResult;
  const MonthYearAddingRangeButton({super.key, required this.isStartDate, required this.dialogResult});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddingDateRangeCubit, List<DateTime?>>(
      builder: (_, newDates) {
        return newDates[isStartDate ? 0 : 1] == null
            ? IconButton.outlined(
                onPressed: () {
                  showDialog(context: context, builder: (unUsedContext) => CustomMonthPicker()).then((date) {
                    if (date != null) {
                      dialogResult.value = isStartDate ? [date, null] : [null, date];
                    }
                  });
                },
                iconSize: 8.w,
                color: Colors.white,
                icon: Icon(Icons.calendar_month),
              )
            : GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (unUsedContext) => CustomMonthPicker(dateSelected: newDates[isStartDate ? 0 : 1]),
                  ).then((date) {
                    if (date != null) {
                      dialogResult.value = isStartDate ? [date, null] : [null, date];
                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1.5),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Text(DateFormat('yMMM').format(newDates[isStartDate ? 0 : 1]!), style: Centre.listText),
                ),
              );
      },
    );
  }
}

class MonthYearEditingRangeButton extends StatelessWidget {
  final ValueNotifier<List<dynamic>?> dialogResult;
  final int id;
  final bool isStartDate;
  const MonthYearEditingRangeButton({
    super.key,
    required this.id,
    required this.isStartDate,
    required this.dialogResult,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TempEditingDateRangesCubit, Map<int, List<DateTime>>>(
      builder: (_, dateRangeMap) {
        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (unUsedContext) => CustomMonthPicker(dateSelected: dateRangeMap[id]![isStartDate ? 0 : 1]),
            ).then((date) {
              if (date != null) {
                dialogResult.value = [id, isStartDate ? 0 : 1, date];
              }
            });
          },
          child: Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 1.5),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: Text(DateFormat('yMMM').format(dateRangeMap[id]![isStartDate ? 0 : 1]), style: Centre.listText),
          ),
        );
      },
    );
  }
}
