import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/screens/landing_pageview.dart';
import 'package:budgie/utils/centre.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class TripRecordBucket extends StatelessWidget {
  final Widget feedback;
  final RecordType type;
  final String bucketName;
  const TripRecordBucket({super.key, required this.feedback, required this.bucketName, required this.type});

  @override
  Widget build(BuildContext context) {
    return Draggable<RecordType>(
      data: type,
      feedback: Transform.translate(
        offset: Offset(-15.w, 0),
        child: BlocBuilder<WarmModeToggleCubit, bool>(
          bloc: context.read<WarmModeToggleCubit>(),
          builder: (_, warmModeToggled) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ConditionalWarmFilter(
                enabled: warmModeToggled,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: 90.w,
                    padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
                    decoration: BoxDecoration(
                      color: Centre.cardColor,
                      border: bucketName == "Entries" ? BoxBorder.all(color: Centre.graphLinesColor) : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: feedback,
                  ),
                ),
              ),
            );
          },
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Centre.cardColor,
          boxShadow: [BoxShadow(color: Centre.shadowbgColor, offset: Offset(0, 2), blurRadius: 6, spreadRadius: 0)],
        ),
        margin: EdgeInsets.only(left: 4.w, bottom: 1.5.h),
        padding: EdgeInsets.only(top: 1.h, right: 3.w, left: 1.w, bottom: 1.h),

        child: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: BucketBorderPainter(color: Centre.accentColor, strokeWidth: 0.3.w, left: 2.w, bottom: 0.5.h),
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.only(left: 3.w, bottom: 1.5.h, right: 1.w),
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.2.h),
              child: Text("$bucketName - - -", style: Centre.listText),
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
