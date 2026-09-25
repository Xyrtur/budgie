import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/screens/landing_pageview.dart';
import 'package:budgie/utils/centre.dart';
import 'package:budgie/widgets/dialogs/dialog_textfield.dart';
import 'package:budgie/widgets/icon_button.dart';
import 'package:budgie/widgets/settings_page/choose_color_button.dart';
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
  final bool isEntry;
  EditTripEntryDialog.entry({
    super.key,
    required this.name,
    required this.colors,
    required this.amount,
    required this.dates,
  }) : isEntry = true;
  EditTripEntryDialog.title({super.key, required this.name}) : colors = [], amount = 0, dates = [], isEntry = false;
  final formKey = GlobalKey<FormState>();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final ValueNotifier<DateTime?> startDateResult = ValueNotifier<DateTime?>(null);
  final ValueNotifier<DateTime?> endDateResult = ValueNotifier<DateTime?>(null);

  @override
  Widget build(BuildContext context) {
    nameController.text = name;
    amountController.text = amount.toStringAsFixed(2);

    startDateResult.addListener(() {
      context.read<DatesSelectedCubit>().updateStart(date: startDateResult.value!);
    });
    endDateResult.addListener(() {
      context.read<DatesSelectedCubit>().updateEnd(date: endDateResult.value!);
    });

    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Centre.dialogBgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      elevation: 1,
      insetPadding: EdgeInsets.symmetric(horizontal: isEntry ? 0 : 15.w),
      content: BlocBuilder<WarmModeToggleCubit, bool>(
        builder: (_, warmModeToggled) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: ConditionalWarmFilter(
              enabled: warmModeToggled,
              child: Material(
                color: Centre.dialogBgColor,
                borderRadius: BorderRadius.circular(30),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.w),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF232536),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: DialogInfoTextField(isName: true, controller: nameController),
                                ),
                              ),
                              if (isEntry) ...[
                                SizedBox(width: 3.w),
                                CustomIconButton(
                                  onTap: () {
                                    //TODO: delete the entry
                                  },
                                  child: Icon(Icons.delete, size: 6.w, color: Centre.primaryColor),
                                ),
                              ],
                            ],
                          ),
                        ),
                        SizedBox(height: 3.h),
                        if (isEntry) ...[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: Row(
                              children: [
                                Text("Colors:", style: Centre.semiTitleText),
                                SizedBox(width: 3.w),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF232536),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: ChooseColorBtn(
                                    categoryName: null,
                                    inTripsPage: true,
                                    colorsToChooseFrom: (Centre.colors),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 1.h),

                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 5.w),
                            padding: EdgeInsets.symmetric(vertical: 1.5.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFF232536),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Text("Start Date", style: Centre.semiTitleText),
                                    CustomIconButton(
                                      onTap: () async {
                                        // Stops focus from going back to text fields after dialog closes
                                        FocusManager.instance.primaryFocus?.unfocus();

                                        List<DateTime?>? results = await showCalendarDatePicker2Dialog(
                                          dialogBackgroundColor: Centre.dialogBgColor,
                                          barrierColor: Colors.transparent,
                                          borderRadius: BorderRadius.circular(40),
                                          context: context,
                                          config: CalendarDatePicker2WithActionButtonsConfig(
                                            weekdayLabelTextStyle: Centre.semiTitle2Text.copyWith(
                                              color: Centre.accentColor,
                                            ),
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
                                            centerAlignModePicker: true,
                                            modePickerBuilder:
                                                ({
                                                  required DateTime monthDate,
                                                  required CalendarDatePicker2Mode viewMode,
                                                  bool? isMonthPicker,
                                                }) {
                                                  if (isMonthPicker ?? false) {
                                                    return Center(
                                                      child: Text(
                                                        DateFormat('   MMMM').format(monthDate),
                                                        style: Centre.semiTitleText,
                                                      ),
                                                    );
                                                  }

                                                  return const SizedBox.shrink();
                                                },
                                            firstDate: DateTime.now().subtract(Duration(days: 365)),
                                            lastDate: DateTime.now().add(Duration(days: 365)),
                                            currentDate: DateTime.now(),
                                            selectedDayTextStyle: Centre.listText.copyWith(color: Colors.black),
                                            selectedDayHighlightColor: Centre.primaryColor,
                                          ),
                                          dialogSize: Size(85.w, 53.h),
                                          value: [context.read<DatesSelectedCubit>().state.last],
                                        );
                                        if (results != null) {
                                          startDateResult.value = results.first;
                                        }
                                      },
                                      child: Icon(Icons.calendar_month, size: 6.w, color: Centre.primaryColor),
                                    ),
                                    SizedBox(height: 0.5.h),
                                    BlocBuilder<DatesSelectedCubit, List<DateTime?>>(
                                      builder: (_, dateChosen) {
                                        return Text(
                                          dateChosen.first != null
                                              ? DateFormat('MMM d').format(dateChosen.first!)
                                              : "N/A",
                                          style: Centre.semiTitle2Text,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                                  child: Icon(Icons.chevron_right, size: 6.w, color: Centre.offWhite),
                                ),
                                Column(
                                  children: [
                                    Text("End Date", style: Centre.semiTitleText),
                                    CustomIconButton(
                                      onTap: () async {
                                        // Stops focus from going back to text fields after dialog closes
                                        FocusManager.instance.primaryFocus?.unfocus();

                                        List<DateTime?>? results = await showCalendarDatePicker2Dialog(
                                          dialogBackgroundColor: Centre.dialogBgColor,
                                          barrierColor: Colors.transparent,
                                          borderRadius: BorderRadius.circular(40),
                                          context: context,
                                          config: CalendarDatePicker2WithActionButtonsConfig(
                                            weekdayLabelTextStyle: Centre.semiTitle2Text.copyWith(
                                              color: Centre.accentColor,
                                            ),
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
                                            centerAlignModePicker: true,
                                            modePickerBuilder:
                                                ({
                                                  required DateTime monthDate,
                                                  required CalendarDatePicker2Mode viewMode,
                                                  bool? isMonthPicker,
                                                }) {
                                                  if (isMonthPicker ?? false) {
                                                    return Center(
                                                      child: Text(
                                                        DateFormat('   MMMM').format(monthDate),
                                                        style: Centre.semiTitleText,
                                                      ),
                                                    );
                                                  }

                                                  return const SizedBox.shrink();
                                                },
                                            firstDate: DateTime.now().subtract(Duration(days: 365)),
                                            lastDate: DateTime.now().add(Duration(days: 365)),
                                            currentDate: DateTime.now(),
                                            selectedDayTextStyle: Centre.listText.copyWith(color: Colors.black),
                                            selectedDayHighlightColor: Centre.primaryColor,
                                          ),
                                          dialogSize: Size(85.w, 53.h),
                                          value: [context.read<DatesSelectedCubit>().state.last],
                                        );
                                        if (results != null) {
                                          endDateResult.value = results.first;
                                        }
                                      },
                                      child: Icon(Icons.calendar_month, size: 6.w, color: Centre.primaryColor),
                                    ),
                                    SizedBox(height: 0.5.h),
                                    BlocBuilder<DatesSelectedCubit, List<DateTime?>>(
                                      builder: (_, dateChosen) {
                                        return Text(
                                          dateChosen.last != null
                                              ? DateFormat('MMM d').format(dateChosen.last!)
                                              : "N/A",
                                          style: Centre.semiTitle2Text,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
                            child: Row(
                              children: [
                                Text("Amount:", style: Centre.semiTitleText),
                                SizedBox(width: 3.w),

                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF232536),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  width: 27.w,
                                  child: DialogInfoTextField(isName: false, controller: amountController),
                                ),
                              ],
                            ),
                          ),
                        ],
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (!isEntry) ...[
                                CustomIconButton(
                                  onTap: () {
                                    //TODO: delete the entry
                                  },
                                  child: Icon(Icons.delete, size: 6.w, color: Centre.primaryColor),
                                ),
                                Spacer(),
                              ],
                              CustomIconButton(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(Icons.close, size: 6.w, color: Centre.primaryColor),
                              ),
                              SizedBox(width: 3.w),

                              CustomIconButton(
                                onTap: () {},
                                child: Icon(Icons.check, size: 6.w, color: Centre.primaryColor),
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
          );
        },
      ),
    );
  }
}
