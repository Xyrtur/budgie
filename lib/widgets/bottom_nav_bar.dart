import 'package:budgie/utils/centre.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

Widget navBarBtn(PageController controller, int pageNum, IconData iconData, String text) {
  return Material(
    shape: BeveledRectangleBorder(),
    type: MaterialType.transparency,
    child: InkWell(
      customBorder: BeveledRectangleBorder(),
      highlightColor: Centre.dialogBgColor,
      onTap: () {
        controller.animateToPage(pageNum, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      },
      child: Container(
        width: 20.w,
        padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 3.w),
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
          ],
        ),
      ),
    ),
  );
}
