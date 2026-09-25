import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/utils/centre.dart';
import 'package:budgie/widgets/dialogs/edit_trip_entry_dialog.dart';
import 'package:budgie/widgets/settings_page/choose_color_button.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class DraggableTripRecord extends StatelessWidget {
  final Record record;
  final String tripName;
  final int index;
  final List<Widget> contents;

  final void Function() onTap;

  const DraggableTripRecord({
    super.key,
    required this.record,
    required this.tripName,
    required this.index,
    required this.onTap,
    required this.contents,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<RecordType>(
      onAcceptWithDetails: (details) {
        context.read<TempTripRecordsCubit>().insertAt(tripName, index + 1, details.data);
      },
      builder: (context, candidateData, rejectedData) {
        return GestureDetector(
          onTap: onTap,
          child: ReorderableDragStartListener(
            index: index,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
              padding: EdgeInsets.symmetric(horizontal: record.type == RecordType.entry ? 3.w : 0),
              decoration: record.type == RecordType.entry
                  ? BoxDecoration(
                      border: BoxBorder.all(color: Color(record.colors[0])),
                      borderRadius: BorderRadius.circular(8),
                    )
                  : null,

              child: Stack(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int colorInt in record.colors.sublist(1))
                        Container(
                          margin: EdgeInsets.only(top: record.startDate == null ? 0.8.h : 1.3.h, right: 2.w),
                          decoration: BoxDecoration(color: Color(colorInt), borderRadius: BorderRadius.circular(4)),
                          height: 0.4.h,
                          width: 8.w,
                        ),
                    ],
                  ),
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
