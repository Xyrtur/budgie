import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/utils/centre.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

Widget navBarBtn(
  PageController controller,
  PageSelected page,
  IconData iconData,
  String text,
  PageSelected currentPage,
) {
  return Material(
    shape: BeveledRectangleBorder(),
    type: MaterialType.transparency,
    child: InkWell(
      customBorder: BeveledRectangleBorder(),
      highlightColor: Centre.dialogBgColor,
      onTap: () {
        controller.animateToPage(page.index, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      },
      child: Container(
        width: 20.w,
        padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 1.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(iconData, color: Colors.white, size: 5.w),
            Text(
              text,
              softWrap: false,
              overflow: TextOverflow.visible,
              style: TextStyle(color: Colors.white, fontSize: 2.6.w),
            ),
            currentPage == page
                ? Container(
                    margin: EdgeInsets.only(top: 0.3.h),
                    height: 0.3.h,
                    width: 15.w,
                    decoration: BoxDecoration(
                      color: Centre.colors[2],
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    ),
  );
}
