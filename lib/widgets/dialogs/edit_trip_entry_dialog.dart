import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/utils/centre.dart';
import 'package:budgie/widgets/dialogs/dialog_textfield.dart';
import 'package:budgie/widgets/icon_button.dart';
import 'package:budgie/widgets/settings_page/choose_color_button.dart';
import 'package:budgie/widgets/settings_page/month_year_picker.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class EditTripEntryDialog extends StatelessWidget {
  final String name;
  final List<int> colors;
  final double amount;
  final List<DateTime?> dates;
  EditTripEntryDialog({super.key, required this.name, required this.colors, required this.amount, required this.dates});
  final formKey = GlobalKey<FormState>();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final ValueNotifier<DateTime?> startDateResult = ValueNotifier<DateTime?>(null);
  final ValueNotifier<DateTime?> endDateResult = ValueNotifier<DateTime?>(null);

  @override
  Widget build(BuildContext context) {
    startDateResult.addListener(() {
      context.read<DatesSelectedCubit>().updateStart(date: startDateResult.value!);
    });
    endDateResult.addListener(() {
      context.read<DatesSelectedCubit>().updateEnd(date: endDateResult.value!);
    });

    return AlertDialog(
      contentPadding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
      backgroundColor: Centre.dialogBgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      elevation: 1,

      content: SizedBox(
        width: 75.w,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Row(
                  children: [
                    DialogInfoTextField(isName: true, controller: nameController),
                    CustomIconButton(
                      onTap: () {
                        //TODO: delete the entry
                      },
                      child: Icon(Icons.delete, size: 6.w, color: Centre.primaryColor),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3.h),
              Row(
                children: [
                  Text("Colors", style: Centre.listText),
                  SizedBox(width: 3.w),
                  ChooseColorBtn(categoryName: null, inTripsPage: true, colorsToChooseFrom: (Centre.colors)),
                ],
              ),
              Row(
                children: [
                  Column(
                    children: [
                      CustomIconButton(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (unUsedContext) =>
                                CustomMonthPicker(dateSelected: context.read<DatesSelectedCubit>().state.first),
                          ).then((date) {
                            if (date != null) {
                              startDateResult.value = date;
                            }
                          });
                        },
                        child: Icon(Icons.calendar_month, color: Centre.primaryColor),
                      ),
                      SizedBox(height: 1.h),
                      BlocBuilder<DatesSelectedCubit, List<DateTime?>>(
                        builder: (unUsedcontext, dateChosen) {
                          return Text(
                            dateChosen.first != null ? DateFormat('MMM d').format(dateChosen.first!) : "",
                            style: Centre.semiTitle2Text,
                          );
                        },
                      ),
                    ],
                  ),
                  Icon(Icons.arrow_forward),
                  Column(
                    children: [
                      CustomIconButton(
                        onTap: () async {
                          List<DateTime?>? results = await showCalendarDatePicker2Dialog(
                            dialogBackgroundColor: Centre.dialogBgColor,
                            barrierColor: Colors.transparent,
                            borderRadius: BorderRadius.circular(40),
                            context: context,
                            config: CalendarDatePicker2WithActionButtonsConfig(
                              weekdayLabelTextStyle: Centre.semiTitle2Text.copyWith(color: Centre.accentColor),
                              controlsTextStyle: Centre.semiTitle2Text,
                              gapBetweenCalendarAndButtons: 0,
                              closeDialogOnCancelTapped: true,
                              cancelButtonTextStyle: Centre.semiTitle2Text,
                              okButton: Container(
                                margin: EdgeInsets.only(right: 3.w),
                                child: Text("OK", style: Centre.semiTitle2Text),
                              ),
                              dayTextStyle: Centre.listText,
                              calendarType: CalendarDatePicker2Type.single,
                              firstDate: DateTime.now().subtract(Duration(days: 365)),
                              lastDate: DateTime.now().add(Duration(days: 365)),
                              currentDate: DateTime.now(),
                              selectedDayHighlightColor: Centre.secondaryColor,
                            ),
                            dialogSize: Size(85.w, 53.h),
                            value: [context.read<DatesSelectedCubit>().state.last],
                          );
                          if (results != null) {
                            endDateResult.value = results.first;
                          }
                        },
                        child: Icon(Icons.calendar_month, color: Centre.primaryColor),
                      ),
                      SizedBox(height: 1.h),
                      BlocBuilder<DatesSelectedCubit, List<DateTime?>>(
                        builder: (unUsedcontext, dateChosen) {
                          return Text(
                            dateChosen.last != null ? DateFormat('MMM d').format(dateChosen.last!) : "",
                            style: Centre.semiTitle2Text,
                          );
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Amount", style: Centre.semiTitleText),
                      SizedBox(width: 3.w),

                      SizedBox(
                        width: 20.w,
                        child: DialogInfoTextField(isName: false, controller: amountController),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CustomIconButton(
                        onTap: () {},
                        child: Icon(Icons.check, color: Centre.primaryColor),
                      ),
                      SizedBox(width: 3.w),
                      CustomIconButton(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.close, color: Centre.primaryColor),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
