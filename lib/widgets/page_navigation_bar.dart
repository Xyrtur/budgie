import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/utils/centre.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class PageNavigationBar extends StatelessWidget {
  final PageController pageController;
  const PageNavigationBar({super.key, required this.pageController});

  Widget pageNavButton(
      {required PageSelected page, required IconData icon, required bool isSelected, required BuildContext context}) {
    return GestureDetector(
        onTap: () {
          pageController.animateToPage(page.index,
              duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);

          context.read<NavbarCubit>().changePage(page: page);
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(width: 3, color: isSelected ? Centre.primaryColor : Colors.transparent),
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Padding(
            padding: EdgeInsets.all(2.w),
            child: Icon(
              icon,
              size: 6.w,
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SizedBox(
          height: 100.h,
          width: 100.w,
          child: Column(
            children: [
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 12.w,
                  ),
                  Container(
                    decoration: ShapeDecoration(
                      shadows: [
                        BoxShadow(
                          color: Centre.shadowbgColor,
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      color: Centre.bgColor,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    width: 55.w,
                    padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.w),
                    child: BlocBuilder<NavbarCubit, PageSelected>(builder: (_, pageSelected) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          pageNavButton(
                              context: context,
                              page: PageSelected.Overview,
                              isSelected: pageSelected == PageSelected.Overview,
                              icon: Icons.menu),
                          pageNavButton(
                              context: context,
                              page: PageSelected.TripPlanning,
                              isSelected: pageSelected == PageSelected.TripPlanning,
                              icon: Icons.menu),
                          pageNavButton(
                              context: context,
                              page: PageSelected.BudgetPlanning,
                              isSelected: pageSelected == PageSelected.BudgetPlanning,
                              icon: Icons.menu),
                          pageNavButton(
                              context: context,
                              page: PageSelected.UserSettings,
                              isSelected: pageSelected == PageSelected.UserSettings,
                              icon: Icons.menu),
                        ],
                      );
                    }),
                  )
                ],
              ),
              SizedBox(
                height: 3.h,
              )
            ],
          )),
      Positioned(
          top: -5.h,
          left: 0,
          right: 0,
          child: Container(
            decoration: ShapeDecoration(
              color: Centre.colors[7],
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Centre.bgColor, width: 2),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
            ),
            height: 10.h,
            width: 8.w,
            child: Icon(Icons.add),
          ))
    ]);
  }
}
