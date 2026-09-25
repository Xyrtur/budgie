import 'dart:ui';

import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/screens/landing_pageview.dart';
import 'package:budgie/utils/centre.dart';
import 'package:budgie/widgets/dialogs/edit_trip_entry_dialog.dart';
import 'package:budgie/widgets/icon_button.dart';
import 'package:budgie/widgets/settings_page/choose_color_button.dart';
import 'package:budgie/widgets/trip_planning_page/draggable_trip_record.dart';
import 'package:budgie/widgets/trip_planning_page/trip_record_bucket.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class TripPlanningPage extends StatelessWidget {
  final String tripName;
  final List<Record> recordList;
  const TripPlanningPage({super.key, required this.tripName, required this.recordList});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: Centre.bgColor,
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 3.h),
                      child: CustomIconButton(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back, size: 6.w, color: Centre.primaryColor),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 5.h),
                        Center(child: Text(tripName, style: Centre.bigTitleText)),
                        Center(
                          child: Text("Jul, 2024 - Aug, 2024", style: Centre.titleText.copyWith(color: Colors.grey)),
                        ),
                        SizedBox(height: 4.h),
                        BlocBuilder<TempTripRecordsCubit, Map<String, List<Record>>>(
                          builder: (_, recordsMap) {
                            return ReorderableListView.builder(
                              itemCount: recordList.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              buildDefaultDragHandles: false,
                              proxyDecorator: (child, index, animation) {
                                return AnimatedBuilder(
                                  animation: animation,
                                  builder: (BuildContext context, Widget? child) {
                                    final double animValue = Curves.easeInOut.transform(animation.value);
                                    final double elevation = lerpDouble(1, 6, animValue)!;
                                    final double scale = lerpDouble(1, 1.02, animValue)!;
                                    return Transform.scale(
                                      scale: scale,
                                      // Create a Card based on the color and the content of the dragged one
                                      // and set its elevation to the animated value.
                                      child: Card(elevation: elevation, color: Centre.dialogBgColor, child: child),
                                    );
                                  },
                                  child: child,
                                );
                              },

                              onReorderItem: (oldIndex, newIndex) {
                                final movedItem = recordList.removeAt(oldIndex);
                                recordList.insert(newIndex, movedItem);
                                context.read<TempTripRecordsCubit>().reOrder(tripName, recordList);
                              },
                              itemBuilder: (BuildContext _, int index) {
                                return recordList[index].type == RecordType.total
                                    ? DraggableTripRecord(
                                        key: ValueKey(index),

                                        record: recordList[index],
                                        tripName: tripName,
                                        index: index,
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (_) {
                                              return BlocProvider.value(
                                                value: context.read<WarmModeToggleCubit>(),
                                                child: EditTripEntryDialog.title(name: recordList[index].name),
                                              );
                                            },
                                          );
                                        },
                                        contents: [
                                          SizedBox(width: 3.w),
                                          BlocProvider<ChooseColorCubit>(
                                            create: (context) => ChooseColorCubit(recordList[index].colors),
                                            child: ChooseColorBtn(
                                              categoryName: null,
                                              inTripsPage: true,
                                              // TODO: only give colors of the records currently present
                                              colorsToChooseFrom: ([...Centre.colors]..shuffle()).sublist(0, 12),
                                            ),
                                          ),
                                          SizedBox(width: 3.w),
                                          Expanded(
                                            child: Container(
                                              color: Colors.transparent,
                                              height: 4.h,
                                              child: Center(
                                                child: DottedLine(dashGapLength: 1.5.w, dashColor: Colors.grey),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            " ${recordList[index].value.toStringAsFixed(2)}",
                                            style: Centre.semiTitle2Text,
                                          ),
                                        ],
                                      )
                                    : recordList[index].type == RecordType.entry
                                    ? DraggableTripRecord(
                                        key: ValueKey(index),
                                        record: recordList[index],
                                        tripName: tripName,
                                        index: index,
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext _) {
                                              return MultiBlocProvider(
                                                providers: [
                                                  BlocProvider<ChooseColorCubit>(
                                                    create: (context) => ChooseColorCubit(recordList[index].colors),
                                                  ),
                                                  BlocProvider<DatesSelectedCubit>(
                                                    create: (context) => DatesSelectedCubit(
                                                      dates: [recordList[index].startDate, recordList[index].endDate],
                                                    ),
                                                  ),

                                                  BlocProvider.value(value: context.read<WarmModeToggleCubit>()),
                                                ],
                                                child: EditTripEntryDialog.entry(
                                                  name: recordList[index].name,
                                                  colors: recordList[index].colors,
                                                  amount: recordList[index].value,
                                                  dates: [recordList[index].startDate, recordList[index].endDate],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        contents: [
                                          recordList[index].startDate != null
                                              ? Container(
                                                  margin: EdgeInsets.only(left: 2.w),
                                                  padding: EdgeInsetsGeometry.symmetric(
                                                    horizontal: 2.w,
                                                    vertical: 0.5.h,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    border: BoxBorder.all(color: Color(recordList[index].colors[0])),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Text(
                                                    "${DateFormat('MMM d').format(recordList[index].startDate!)} - ${DateFormat('MMM d').format(recordList[index].endDate!)}",
                                                    style: Centre.listText,
                                                  ),
                                                )
                                              : SizedBox(),
                                          Spacer(),
                                          Text(
                                            recordList[index].value.toStringAsFixed(2),
                                            style: Centre.semiTitle2Text,
                                          ),
                                        ],
                                      )
                                    : DraggableTripRecord(
                                        key: ValueKey(index),
                                        record: recordList[index],
                                        tripName: tripName,
                                        index: index,
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (_) {
                                              return BlocProvider.value(
                                                value: context.read<WarmModeToggleCubit>(),
                                                child: EditTripEntryDialog.title(name: recordList[index].name),
                                              );
                                            },
                                          );
                                        },
                                        contents: [
                                          SizedBox(width: 3.w),
                                          Expanded(
                                            child: Container(
                                              color: Colors.transparent,
                                              height: 4.h,
                                              child: Center(
                                                child: DottedLine(dashGapLength: 1.5.w, dashColor: Colors.grey),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                              },
                            );
                          },
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Align(
              alignment: AlignmentGeometry.bottomRight,
              child: Container(
                margin: EdgeInsets.only(right: 5.w, bottom: 5.h),
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: BoxBorder.all(color: Centre.secondaryColor, width: 0.2.w),
                  color: Centre.cardColor,
                  boxShadow: [
                    BoxShadow(color: Centre.shadowbgColor, offset: Offset(0, 2), blurRadius: 6, spreadRadius: 0),
                  ],
                ),
                child: Text("Total      \$5,678.34", style: Centre.semiTitle2Text),
              ),
            ),

            Align(
              alignment: AlignmentGeometry.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TripRecordBucket(
                      type: RecordType.total,
                      feedback: Row(
                        children: [
                          Text("Total", style: Centre.semiTitle2Text),
                          SizedBox(width: 3.w),
                          Container(
                            margin: EdgeInsets.only(right: 2.w),
                            width: 6.w,
                            height: 6.w,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(color: Colors.white, width: 1.5),
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              color: Colors.transparent,
                              height: 4.h,
                              child: Center(
                                child: DottedLine(dashGapLength: 1.5.w, dashColor: Colors.grey),
                              ),
                            ),
                          ),
                        ],
                      ),
                      bucketName: "Total",
                    ),
                    TripRecordBucket(
                      type: RecordType.entry,
                      feedback: Row(
                        children: [
                          Text("Placeholder Title", style: Centre.semiTitle2Text),
                          Spacer(),
                          Text("\$123.45", style: Centre.semiTitle2Text),
                        ],
                      ),
                      bucketName: "Entries",
                    ),

                    TripRecordBucket(
                      type: RecordType.title,
                      feedback: Row(
                        children: [
                          Text("Placeholder Section", style: Centre.semiTitle2Text),
                          SizedBox(width: 3.w),

                          Expanded(
                            child: Container(
                              color: Colors.transparent,
                              height: 2.h,
                              child: Center(
                                child: DottedLine(dashGapLength: 1.5.w, dashColor: Colors.grey),
                              ),
                            ),
                          ),
                        ],
                      ),
                      bucketName: "Sections",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
