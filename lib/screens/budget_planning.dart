/*  Set limits for each budget category, as well as any fixed costs


*/
import 'package:budgie/utils/centre.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class BudgetPlanningPage extends StatelessWidget {
  const BudgetPlanningPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Color> colors = [
      Color(0xff839791),
      Color(0xff101533),
      Color(0xffffd4ca),
      Color(0xffefd5c3),
      Color(0xff370E27),
      Color(0xffaf5271),
      Color(0xffe77b69),
      Color(0xffffaddf),
      Color(0xff46171b),
      Color(0xff794546),
      Color(0xffce8fc3),
      Color(0xff9e72a6),
      Color(0xff2D82B7),
      Color(0xff58A4B0),
      Color(0xff558B6E),
      Color(0xffA53860),
      Color(0xffC5AFA4),
      Color(0xffC8D6AF),
      Color(0xffFFA69E),
      Color.fromARGB(255, 243, 124, 149),
      Color.fromARGB(255, 255, 140, 198),
      Color.fromARGB(255, 244, 165, 105),
      Color.fromARGB(255, 211, 170, 186),
      Color.fromARGB(255, 206, 128, 232),
      Color.fromARGB(255, 253, 183, 145),
      Color.fromARGB(255, 172, 216, 170),
      Color.fromARGB(255, 168, 247, 246),
      Color.fromARGB(255, 255, 217, 125),

      // Second row
      Color.fromARGB(255, 86, 205, 132),
      Color.fromARGB(255, 139, 168, 248),
      Color.fromARGB(255, 126, 213, 224),
      Color.fromARGB(255, 177, 190, 220),
      Color.fromARGB(255, 244, 223, 88),
      Color.fromARGB(255, 226, 174, 221),
      Color.fromARGB(255, 193, 251, 164),
      Color.fromARGB(255, 251, 188, 207),
      Color.fromARGB(255, 255, 155, 133),
      Color(0xffF8C0C8),
      Color(0xffFF5376),
      Color(0xff6BAA75),
      Color(0xffA3CEF1),
      Color(0xff8F95D3),
      Color(0xffDBB1BC),
      Color(0xffD3C4E3),
      Color(0xffB3CBB9),
      Color(0xff85FFC7),
      Color(0xffFDCFF3),
      Color(0xffFAA275),
      Color(0xffF6AE2D),
    ];
    return SafeArea(
      child: Scaffold(
        backgroundColor: Centre.bgColor,
        body: Padding(
          padding: EdgeInsetsGeometry.all(8.w),
          child: Wrap(
            spacing: 5.w,
            runSpacing: 5.w,
            children: [
              for (Color i in colors)
                Container(width: 4.h, height: 4.h, color: i),
            ],
          ),
        ),
      ),
    );
  }
}
