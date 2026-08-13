import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/utils/centre.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class ToggleCategoryArea extends StatefulWidget {
  final bool isPortrait;
  final List<String> categories;
  final List<Color> categoryColors;
  const ToggleCategoryArea({
    super.key,
    required this.isPortrait,
    required this.categories,
    required this.categoryColors,
  });

  @override
  State<ToggleCategoryArea> createState() => _ToggleCategoryAreaState();
}

class _ToggleCategoryAreaState extends State<ToggleCategoryArea> {
  final ScrollController categoryScrollController = ScrollController();

  @override
  void dispose() {
    categoryScrollController.dispose();
    super.dispose();
  }

  Color rippleColor(Color color, bool isSplash) {
    final hsl = HSLColor.fromColor(color);

    return hsl
        .withLightness((hsl.lightness + 0.15).clamp(0.0, 1.0))
        .withSaturation((hsl.saturation * 0.9).clamp(0.0, 1.0))
        .toColor()
        .withValues(alpha: isSplash ? 0.45 : 0.20);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpendingCategoriesToggledCubit, List<String>>(
      builder: (_, categoriesToggled) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 3.h),
          child: ScrollbarTheme(
            data: ScrollbarThemeData(
              thumbColor: WidgetStateProperty.all(Centre.dialogBgColor),
              trackBorderColor: WidgetStateProperty.all(Centre.scrollTrackColor),
              thickness: WidgetStateProperty.all(4.0),
              radius: const Radius.circular(8),
              trackColor: WidgetStateProperty.all(Centre.scrollTrackColor),
            ),
            child: MediaQuery.removePadding(
              context: context,
              removeBottom: true,
              child: Scrollbar(
                controller: categoryScrollController,
                trackVisibility: true,
                thumbVisibility: true,
                scrollbarOrientation: ScrollbarOrientation.left,
                child: SingleChildScrollView(
                  controller: categoryScrollController,

                  child: Column(
                    children: [
                      SizedBox(height: 2.h),
                      Wrap(
                        direction: widget.isPortrait ? Axis.horizontal : Axis.vertical,
                        alignment: widget.isPortrait ? WrapAlignment.center : WrapAlignment.start,
                        runSpacing: 1.5.h,
                        spacing: widget.isPortrait ? 5.w : 3.w,
                        children: [
                          for (int i = 0; i < widget.categories.length; i++)
                            Ink(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.9),
                                    offset: const Offset(3, 4),
                                    blurRadius: 15,
                                  ),
                                  categoriesToggled.contains(widget.categories[i])
                                      ? BoxShadow(
                                          color: widget.categoryColors[i].withValues(alpha: 0.1),
                                          offset: const Offset(3, 3),
                                          blurRadius: 15,
                                        )
                                      : BoxShadow(),
                                ],

                                color: categoriesToggled.contains(widget.categories[i])
                                    ? widget.categoryColors[i].withValues(alpha: 0.9)
                                    : widget.categoryColors[i].withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(30),
                                border: BoxBorder.all(color: widget.categoryColors[i], width: 0.4.w),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(30),
                                radius: 20,
                                splashColor: categoriesToggled.contains(widget.categories[i])
                                    ? Centre.bgSplashColor
                                    : rippleColor(widget.categoryColors[i], true),

                                highlightColor: categoriesToggled.contains(widget.categories[i])
                                    ? Centre.bgSplashColor
                                    : rippleColor(widget.categoryColors[i], false),

                                onTap: () {
                                  context.read<SpendingCategoriesToggledCubit>().toggleCategory(widget.categories[i]);
                                },

                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),

                                  child: Text(
                                    widget.categories[i],
                                    style: Centre.listText.copyWith(
                                      fontSize: widget.isPortrait ? 14.sp : 13.5.sp,
                                      fontWeight: FontWeight.bold,
                                      color: categoriesToggled.contains(widget.categories[i])
                                          ? Centre.bgColor
                                          : widget.categoryColors[i],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: widget.isPortrait ? 5.h : 2.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
