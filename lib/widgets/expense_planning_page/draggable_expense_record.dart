import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/utils/centre.dart';
import 'package:budgie/utils/custom_delayed_drag_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class DraggableRecord extends StatelessWidget {
  final Record record;
  final String planName;
  final int index;
  final List<Widget> contents;

  final void Function() onTap;

  const DraggableRecord({
    super.key,
    required this.record,
    required this.planName,
    required this.index,
    required this.onTap,
    required this.contents,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<RecordType>(
      onAcceptWithDetails: (details) {
        context.read<TempTripRecordsCubit>().insertAt(planName: planName, index: index + 1, type: details.data);
      },
      builder: (context, candidateData, rejectedData) {
        return GestureDetector(
          onTap: onTap,
          child: CustomDelayedDragStartListener(
            index: index,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
              padding: EdgeInsets.symmetric(horizontal: record.type == RecordType.entry ? 3.w : 0),
              decoration: record.type == RecordType.entry
                  ? BoxDecoration(
                      border: record.colors.isNotEmpty ? BoxBorder.all(color: Color(record.colors[0])) : null,
                      borderRadius: BorderRadius.circular(8),
                    )
                  : null,

              child: Stack(
                children: [
                  record.type == RecordType.entry
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (int colorInt in record.colors.sublist(record.colors.length > 1 ? 1 : 0))
                              Container(
                                margin: EdgeInsets.only(top: record.startDate == null ? 0.8.h : 1.3.h, right: 2.w),
                                decoration: BoxDecoration(
                                  color: Color(colorInt),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                height: 0.4.h,
                                width: 8.w,
                              ),
                          ],
                        )
                      : SizedBox(),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: record.type == RecordType.entry ? 1.5.h : 1.h),
                    child: Row(
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(minWidth: record.type == RecordType.entry ? 20.w : 0),
                          child: Text(record.name, style: Centre.semiTitle2Text),
                        ),

                        ...contents,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
