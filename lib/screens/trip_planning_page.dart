import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/utils/centre.dart';
import 'package:budgie/widgets/dialogs/edit_trip_entry_dialog.dart';
import 'package:budgie/widgets/icon_button.dart';
import 'package:budgie/widgets/settings_page/choose_color_button.dart';
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
                          builder: (context, recordsMap) {
                            return ReorderableListView.builder(
                              itemCount: recordList.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              buildDefaultDragHandles: false,
                              proxyDecorator: (child, index, animation) {
                                return Material(
                                  color: Colors.transparent,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Centre.cardColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ), // background while dragging
                                    child: child,
                                  ),
                                );
                              },

                              onReorderItem: (oldIndex, newIndex) {
                                final movedItem = recordList.removeAt(oldIndex);
                                recordList.insert(newIndex, movedItem);
                                context.read<TempTripRecordsCubit>().reOrder(tripName, recordList);
                              },
                              itemBuilder: (BuildContext context, int index) {
                                return recordList[index].type == RecordType.total
                                    ? DragTarget<RecordType>(
                                        key: ValueKey(index),

                                        onAcceptWithDetails: (details) {
                                          context.read<TempTripRecordsCubit>().insertAt(
                                            tripName,
                                            index + 1,
                                            details.data,
                                          );
                                        },
                                        builder: (context, candidateData, rejectedData) {
                                          return ReorderableDelayedDragStartListener(
                                            index: index,
                                            child: Container(
                                              margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
                                              padding: EdgeInsets.symmetric(vertical: 1.h),
                                              child: Row(
                                                children: [
                                                  Text("Total", style: Centre.semiTitle2Text),
                                                  SizedBox(width: 3.w),
                                                  BlocProvider<ChooseColorCubit>(
                                                    create: (context) => ChooseColorCubit(recordList[index].colors),
                                                    child: ChooseColorBtn(
                                                      categoryName: null,
                                                      inTripsPage: true,
                                                      // TODO: only give colors of the records currently present
                                                      colorsToChooseFrom: ([
                                                        ...Centre.colors,
                                                      ]..shuffle()).sublist(0, 12),
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
                                                  Text(
                                                    " ${recordList[index].value.toStringAsFixed(2)}",
                                                    style: Centre.semiTitle2Text,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : recordList[index].type == RecordType.entry
                                    ? DragTarget<RecordType>(
                                        key: ValueKey(index),

                                        onAcceptWithDetails: (details) {
                                          context.read<TempTripRecordsCubit>().insertAt(
                                            tripName,
                                            index + 1,
                                            details.data,
                                          );
                                        },
                                        builder: (context, candidateData, rejectedData) {
                                          return GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext dialogContext) {
                                                  return GestureDetector(
                                                    onTap: () {},
                                                    child: Scaffold(
                                                      backgroundColor: Colors.transparent,
                                                      body: MultiBlocProvider(
                                                        providers: [
                                                          BlocProvider<ChooseColorCubit>(
                                                            create: (context) =>
                                                                ChooseColorCubit(recordList[index].colors),
                                                          ),
                                                          BlocProvider<DatesSelectedCubit>(
                                                            create: (context) => DatesSelectedCubit(),
                                                          ),
                                                        ],
                                                        child: EditTripEntryDialog(
                                                          name: recordList[index].name,
                                                          colors: recordList[index].colors,
                                                          amount: recordList[index].value,
                                                          dates: [
                                                            recordList[index].startDate,
                                                            recordList[index].endDate,
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: ReorderableDelayedDragStartListener(
                                              index: index,
                                              child: Container(
                                                margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
                                                padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
                                                decoration: BoxDecoration(
                                                  border: BoxBorder.all(
                                                    color: recordList[index].colors.isNotEmpty
                                                        ? Color(recordList[index].colors[0])
                                                        : const Color.fromARGB(255, 54, 54, 54),
                                                  ),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Text(recordList[index].name, style: Centre.semiTitle2Text),
                                                    recordList[index].startDate != null
                                                        ? Container(
                                                            margin: EdgeInsets.only(left: 2.w),
                                                            padding: EdgeInsetsGeometry.symmetric(
                                                              horizontal: 2.w,
                                                              vertical: 0.5.h,
                                                            ),
                                                            decoration: BoxDecoration(
                                                              border: BoxBorder.all(
                                                                color: Color(recordList[index].colors[0]),
                                                              ),
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
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : DragTarget<RecordType>(
                                        key: ValueKey(index),

                                        onAcceptWithDetails: (details) {
                                          context.read<TempTripRecordsCubit>().insertAt(
                                            tripName,
                                            index + 1,
                                            details.data,
                                          );
                                        },
                                        builder: (context, candidateData, rejectedData) {
                                          return ReorderableDelayedDragStartListener(
                                            index: index,
                                            child: Container(
                                              margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
                                              padding: EdgeInsets.symmetric(vertical: 1.h),
                                              child: Row(
                                                children: [
                                                  Text(recordList[index].name, style: Centre.semiTitle2Text),
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
                                              ),
                                            ),
                                          );
                                        },
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
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Centre.cardColor,
                        boxShadow: [
                          BoxShadow(color: Centre.shadowbgColor, offset: Offset(0, 2), blurRadius: 6, spreadRadius: 0),
                        ],
                      ),
                      margin: EdgeInsets.only(left: 4.w, bottom: 1.5.h),
                      padding: EdgeInsets.only(top: 1.h, right: 3.w, left: 1.w, bottom: 1.h),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: IgnorePointer(
                              child: CustomPaint(
                                painter: BucketBorderPainter(
                                  color: Centre.accentColor,
                                  strokeWidth: 0.3.w,
                                  left: 2.w,
                                  bottom: 0.5.h,
                                ),
                              ),
                            ),
                          ),
                          Draggable<RecordType>(
                            data: RecordType.total,
                            feedback: Material(
                              color: Colors.transparent,
                              child: Container(
                                width: 90.w,
                                margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
                                padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
                                decoration: BoxDecoration(
                                  color: Centre.cardColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
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
                              ),
                            ),
                            child: Container(
                              margin: EdgeInsets.only(left: 3.w, bottom: 1.5.h, right: 1.w),
                              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.2.h),
                              child: Text("Totals - - -", style: Centre.listText),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Centre.cardColor,
                        boxShadow: [
                          BoxShadow(color: Centre.shadowbgColor, offset: Offset(0, 2), blurRadius: 6, spreadRadius: 0),
                        ],
                      ),
                      margin: EdgeInsets.only(left: 4.w, bottom: 1.5.h),
                      padding: EdgeInsets.only(top: 1.h, right: 3.w, left: 1.w, bottom: 1.h),

                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: IgnorePointer(
                              child: CustomPaint(
                                painter: BucketBorderPainter(
                                  color: Centre.accentColor,
                                  strokeWidth: 0.3.w,
                                  left: 2.w,
                                  bottom: 0.5.h,
                                ),
                              ),
                            ),
                          ),

                          Draggable<RecordType>(
                            data: RecordType.entry,
                            feedback: Material(
                              color: Colors.transparent,
                              child: Container(
                                width: 90.w,
                                margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
                                padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
                                decoration: BoxDecoration(
                                  color: Centre.cardColor,
                                  border: BoxBorder.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Text("Placeholder Title", style: Centre.semiTitle2Text),
                                    Spacer(),
                                    Text("\$123.45", style: Centre.semiTitle2Text),
                                  ],
                                ),
                              ),
                            ),
                            child: Container(
                              margin: EdgeInsets.only(left: 3.w, bottom: 1.5.h, right: 1.w),
                              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.2.h),
                              child: Text("Entries - - -", style: Centre.listText),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Centre.cardColor,
                        boxShadow: [
                          BoxShadow(color: Centre.shadowbgColor, offset: Offset(0, 2), blurRadius: 6, spreadRadius: 0),
                        ],
                      ),
                      margin: EdgeInsets.only(left: 4.w),
                      padding: EdgeInsets.only(top: 1.h, right: 3.w, left: 1.w, bottom: 1.h),

                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: IgnorePointer(
                              child: CustomPaint(
                                painter: BucketBorderPainter(
                                  color: Centre.accentColor,
                                  strokeWidth: 0.3.w,
                                  left: 2.w,
                                  bottom: 0.5.h,
                                ),
                              ),
                            ),
                          ),

                          Draggable<RecordType>(
                            data: RecordType.title,
                            feedback: Material(
                              color: Colors.transparent,
                              child: Container(
                                width: 90.w,
                                margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
                                padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
                                decoration: BoxDecoration(
                                  color: Centre.cardColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
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
                              ),
                            ),
                            child: Container(
                              margin: EdgeInsets.only(left: 3.w, bottom: 1.5.h, right: 1.w),
                              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.2.h),

                              child: Text("Sections - - -", style: Centre.listText),
                            ),
                          ),
                        ],
                      ),
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

class BucketBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double left;
  final double bottom;

  BucketBorderPainter({required this.color, required this.strokeWidth, required this.left, required this.bottom});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final right = size.width;
    final bottomY = size.height - bottom;

    final path = Path()
      ..moveTo(left, size.height * 0.4)
      ..lineTo(left, bottomY)
      ..lineTo(right, bottomY)
      ..lineTo(right, size.height * 0.4);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant BucketBorderPainter oldDelegate) {
    return color != oldDelegate.color ||
        strokeWidth != oldDelegate.strokeWidth ||
        left != oldDelegate.left ||
        bottom != oldDelegate.bottom;
  }
}
