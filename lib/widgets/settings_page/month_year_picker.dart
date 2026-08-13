import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/utils/centre.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:sizer/sizer.dart';

Future<DateTime?> showCustomMonthPicker(BuildContext context) {
  return showMonthPicker(
    context: context,

    initialDate: DateTime.now(),
    monthStylePredicate: (DateTime val) {
      if (val.month == DateTime.now().month && val.year == DateTime.now().year) {
        return TextButton.styleFrom(backgroundColor: Centre.colors[33]);
      }
      return null;
    },
    yearStylePredicate: (int val) {
      if (val == DateTime.now().year) {
        return TextButton.styleFrom(backgroundColor: Centre.colors[33]);
      }
      return null;
    },
    monthPickerDialogSettings: MonthPickerDialogSettings(
      dialogSettings: PickerDialogSettings(
        verticalScrolling: false,
        dialogBackgroundColor: Centre.dialogBgColor,
        dialogRoundedCornersRadius: 12,
      ),
      headerSettings: PickerHeaderSettings(
        headerPadding: EdgeInsets.only(top: 4.w, left: 4.w, right: 4.w),
        headerBackgroundColor: Centre.dialogBgColor,
        headerCurrentPageTextStyle: Centre.semiTitleText,
        headerSelectedIntervalTextStyle: Centre.semiTitle2Text,
        headerIconsColor: Colors.white,
      ),
      dateButtonsSettings: PickerDateButtonsSettings(
        selectedMonthBackgroundColor: Centre.colors[42],
        selectedMonthTextColor: Centre.bgColor,
        unselectedMonthsTextColor: Centre.colors[42],
        currentMonthTextColor: Centre.bgColor,
        monthTextStyle: Centre.listText,
      ),
      actionBarSettings: PickerActionBarSettings(
        confirmWidget: Padding(
          padding: EdgeInsets.all(3.w),
          child: Text('OK', style: Centre.listText),
        ),
        cancelWidget: Padding(
          padding: EdgeInsets.all(3.w),
          child: Text('Cancel', style: Centre.listText),
        ),
      ),
    ),
  );
}

class MonthYearAddingRangeButton extends StatelessWidget {
  final bool isStartDate;
  final ValueNotifier<List<DateTime?>> dialogResult;
  const MonthYearAddingRangeButton({super.key, required this.isStartDate, required this.dialogResult});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddingDateRangeCubit, List<DateTime?>>(
      builder: (_, newDates) {
        return newDates[0] == null
            ? IconButton.outlined(
                onPressed: () {
                  showCustomMonthPicker(context).then((date) {
                    if (date != null) {
                      dialogResult.value = isStartDate ? [null, date] : [date, null];
                    }
                  });
                },
                iconSize: 8.w,
                color: Colors.white,
                icon: Icon(Icons.calendar_month),
              )
            : GestureDetector(
                onTap: () {
                  showCustomMonthPicker(context).then((date) {
                    if (date != null) {
                      dialogResult.value = isStartDate ? [null, date] : [date, null];
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
    return GestureDetector(
      onTap: () {
        showCustomMonthPicker(context).then((date) {
          if (date != null) {
            dialogResult.value = [id, isStartDate ? 0 : 1, date];
          }
        });
      },
      child: BlocBuilder<TempEditingDateRangesCubit, Map<int, List<DateTime>>>(
        builder: (_, dateRangeMap) {
          return Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 1.5),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: Text(DateFormat('yMMM').format(dateRangeMap[id]![isStartDate ? 0 : 1]), style: Centre.listText),
          );
        },
      ),
    );
  }
}
