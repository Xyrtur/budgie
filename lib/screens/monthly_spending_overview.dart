/*
Actions

Add monthly expense


Information Needed

soFarSpent query
monthlyBudget query 
^^^ need limits of genres as well as total budget(includes fixed but dont need fixed number)
incomeTxns query
expenseTxns query
^^^  sort into lists based on the genre 
^^^ blocs state will give out the genres and their colors, as well as a dictionary, key: genre, value: list of expenses


UI
BlocBuilder at top for when an expense gets added for that month, update whole page

Column

Row(Text(currentMonth), Text(soFarSpentQuery + " of " + monthlyBudgetQuery))

DetailedBarGraph

Container(Text(Income), list incomes using incomeTxnsQuery)

Text(Expenses)

>> Container for each genre using genresPresent Query 

Container(color: genreColor, Text(genreName), list of expenses)

*/
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/utils/centre.dart';
import 'package:budgie/widgets/dialogs/add_edit_expense_dialog.dart';
import 'package:budgie/widgets/dialogs/view_category_expenses_dialog.dart';
import 'package:budgie/widgets/spending_overview/bar_graphs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:staggered_grid_view/flutter_staggered_grid_view.dart';

typedef CategoryInfo = ({
  String categoryName,
  double categoryTotal,
  double categoryCurrent,
  List<Expense> expenseList,
  Color color,
});

class MonthlySpendingOverview extends StatelessWidget {
  final String month;
  MonthlySpendingOverview({super.key, required this.month});

  final List<CategoryInfo> catInfoList = [
    (
      categoryName: "Groceries",
      categoryCurrent: 200.00,
      categoryTotal: 300.00,
      expenseList: [
        (name: "superstore", value: 60.45, date: DateTime.now(), category: "Groceries", isExpense: true),
        (name: "walmart", value: 120.45, date: DateTime.now(), category: "Groceries", isExpense: true),
        (name: "superstore", value: 60.45, date: DateTime.now(), category: "Groceries", isExpense: true),
        (name: "walmart", value: 120.45, date: DateTime.now(), category: "Groceries", isExpense: true),
        (name: "superstore", value: 60.45, date: DateTime.now(), category: "Groceries", isExpense: true),
        (name: "superstore", value: 60.45, date: DateTime.now(), category: "Groceries", isExpense: true),
        (name: "superstore", value: 60.45, date: DateTime.now(), category: "Groceries", isExpense: true),
        (name: "superstore", value: 60.45, date: DateTime.now(), category: "Groceries", isExpense: true),
        (name: "superstore", value: 60.45, date: DateTime.now(), category: "Groceries", isExpense: true),
        (name: "superstore", value: 60.45, date: DateTime.now(), category: "Groceries", isExpense: true),
        (name: "superstore", value: 60.45, date: DateTime.now(), category: "Groceries", isExpense: true),
      ],
      color: Centre.colors[Random().nextInt(54)],
    ),
    (
      categoryName: "Entertainment",
      categoryCurrent: 400.00,
      categoryTotal: 500.00,
      expenseList: [
        (name: "headphonssssses", value: 60.45, date: DateTime.now(), category: "Entertainment", isExpense: true),
        (name: "movies", value: 120.45, date: DateTime.now(), category: "Entertainment", isExpense: true),
        (name: "adhesives", value: 120.45, date: DateTime.now(), category: "Entertainment", isExpense: true),
        (name: "headphones", value: 60.45, date: DateTime.now(), category: "Entertainment", isExpense: true),
        (name: "movies", value: 120.45, date: DateTime.now(), category: "Entertainment", isExpense: true),
      ],
      color: Centre.colors[Random().nextInt(54)],
    ),
    (
      categoryName: "House",
      categoryCurrent: 76.00,
      categoryTotal: 120.00,
      expenseList: [
        (name: "detergent", value: 60.45, date: DateTime.now(), category: "House", isExpense: true),
        (name: "soap", value: 120.45, date: DateTime.now(), category: "House", isExpense: true),
        (name: "vacuum", value: 60.45, date: DateTime.now(), category: "House", isExpense: true),
        (name: "dryer sheets", value: 120.45, date: DateTime.now(), category: "House", isExpense: true),
        (name: "dishes", value: 60.45, date: DateTime.now(), category: "House", isExpense: true),
      ],
      color: Centre.colors[Random().nextInt(54)],
    ),
    (
      categoryName: "Gas",
      categoryCurrent: 40.00,
      categoryTotal: 150.00,
      expenseList: [
        (name: "fill up", value: 60.45, date: DateTime.now(), category: "Gas", isExpense: true),
        (name: "fill", value: 120.45, date: DateTime.now(), category: "Gas", isExpense: true),
        (name: "fill up", value: 60.45, date: DateTime.now(), category: "Gas", isExpense: true),
      ],
      color: Centre.colors[Random().nextInt(54)],
    ),
    (
      categoryName: "Junk Food",
      categoryCurrent: 30.00,
      categoryTotal: 80.00,
      expenseList: [
        (name: "chips", value: 60.45, date: DateTime.now(), category: "Junk Food", isExpense: true),
        (name: "ice cream", value: 120.45, date: DateTime.now(), category: "Junk Food", isExpense: true),
        (name: "boba", value: 120.45, date: DateTime.now(), category: "Junk Food", isExpense: true),
        (name: "sushi + boba", value: 120.45, date: DateTime.now(), category: "Junk Food", isExpense: true),
        (name: "chips", value: 120.45, date: DateTime.now(), category: "Junk Food", isExpense: true),
      ],
      color: Centre.colors[Random().nextInt(54)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: Centre.bgColor,
        body: Padding(
          padding: EdgeInsetsGeometry.symmetric(vertical: 4.h, horizontal: 4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 2.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(month, style: Centre.titleText),

                        Text("\$1700 of \$2200", style: Centre.semiTitleText),
                      ],
                    ),
                    SizedBox(height: 2.5.h),

                    BarGraphBoxes(),
                    SizedBox(height: 1.h),

                    SizedBox(
                      width: 90.w,
                      child: Wrap(spacing: 3.w, runSpacing: 0.4.h, children: barGraphLegend()),
                    ),
                    SizedBox(height: 3.h),

                    Divider(thickness: 0.1.h, color: Colors.white),
                  ],
                ),
              ),

              Expanded(
                child: ListView(
                  children: [
                    SizedBox(height: 2.5.h),

                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 2.w),
                      child: Text("Income", style: Centre.semiTitle2Text),
                    ),
                    SizedBox(height: 1.h),

                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 2.w),
                      child: SizedBox(
                        width: 90.w,
                        child: Wrap(spacing: 3.w, runSpacing: 0.4.h, children: incomeBoxes()),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 2.w),
                      child: Text("Expenses", style: Centre.semiTitleText),
                    ),
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 2.w),
                      child: Text(
                        "Hold to edit expenses",
                        style: Centre.listText.copyWith(fontSize: 14.sp, fontStyle: FontStyle.italic),
                      ),
                    ),
                    SizedBox(height: 2.h),

                    StaggeredGridView.countBuilder(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      itemCount: 5,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 3.w,
                      mainAxisSpacing: 2.h,
                      staggeredTileBuilder: (index) => StaggeredTile.fit(1),
                      itemBuilder: (context, index) {
                        return MultiBlocProvider(
                          providers: [
                            BlocProvider<CategoryIsExpandedCubit>(create: (context) => CategoryIsExpandedCubit()),
                            BlocProvider<CategoryIsDescendingCubit>(create: (context) => CategoryIsDescendingCubit()),
                          ],
                          child: CategoryExpenseBox(categoryInfo: catInfoList[index]),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<Widget> incomeBoxes() {
  List<Widget> incomeBoxes = [];
  incomeBoxes.add(
    Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: Colors.white, width: 0.5.w),
      ),
      child: Text("GST Rebate  \$87.25", style: Centre.listText),
    ),
  );

  return incomeBoxes;
}

class CategoryExpenseBox extends StatelessWidget {
  final CategoryInfo categoryInfo;

  const CategoryExpenseBox({super.key, required this.categoryInfo});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        splashColor: Centre.bgSplashColor,
        highlightColor: Centre.bgSplashColor,
        onTap: () {
          context.read<CategoryIsExpandedCubit>().toggle();
        },
        onLongPress: () {
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return BlocProvider<CategoryIsDescendingCubit>(
                create: (context) => CategoryIsDescendingCubit(),
                child: ViewCategoryExpensesDialog(expenseList: categoryInfo.expenseList),
              );
            },
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastLinearToSlowEaseIn,
          width: 44.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: categoryInfo.color, width: 0.5.w),
          ),
          child: Stack(
            children: [
              Align(
                alignment: AlignmentGeometry.centerRight,
                child: BlocBuilder<CategoryIsExpandedCubit, ExpandLevel>(
                  builder: (_, expandLevel) {
                    return Padding(
                      padding: EdgeInsets.only(right: 0.6.h, top: 0.6.h),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        transitionBuilder: (child, anim) => RotationTransition(
                          turns: child.key == ValueKey('icon1')
                              ? Tween<double>(begin: 1, end: 0.75).animate(anim)
                              : Tween<double>(begin: 0.75, end: 1).animate(anim),
                          child: ScaleTransition(scale: anim, child: child),
                        ),
                        child: expandLevel == ExpandLevel.collapsed
                            ? Icon(Icons.open_in_full, size: 4.w, key: const ValueKey('icon2'))
                            : expandLevel == ExpandLevel.partial
                            ? Icon(Icons.fullscreen, size: 4.w, key: const ValueKey('icon3'))
                            : Icon(Icons.close_fullscreen, size: 4.w, key: const ValueKey('icon1')),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: BlocBuilder<CategoryIsExpandedCubit, ExpandLevel>(
                  builder: (_, expandLevel) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Center(
                              child: Text(
                                "\$${categoryInfo.categoryCurrent.toStringAsFixed(2)}",
                                style: Centre.listText.copyWith(
                                  fontSize: 14.5.sp,
                                  color: const Color.fromARGB(255, 233, 117, 109),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 9.h,
                              width: 9.h,
                              child: TweenAnimationBuilder<double>(
                                tween: Tween<double>(
                                  begin: 0.0,
                                  end: categoryInfo.categoryCurrent / categoryInfo.categoryTotal,
                                ),
                                duration: const Duration(milliseconds: 3500),
                                curve: Curves.fastLinearToSlowEaseIn,
                                builder: (context, value, _) => Transform.rotate(
                                  angle: pi,
                                  child: CircularProgressIndicator(
                                    value: value,
                                    strokeWidth: 4.w,
                                    strokeCap: StrokeCap.round,
                                    color: categoryInfo.color,
                                    backgroundColor: Centre.navBarColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.5.h),
                        Text(categoryInfo.categoryName, style: Centre.semiTitleText),
                        Text(
                          "\$${(categoryInfo.categoryTotal - categoryInfo.categoryCurrent).toStringAsFixed(2)} remaining",
                          style: Centre.listText.copyWith(fontSize: 14.5.sp, color: Colors.lightGreen),
                        ),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.fastLinearToSlowEaseIn,
                          child: expandLevel == ExpandLevel.collapsed
                              ? SizedBox()
                              : Padding(
                                  padding: EdgeInsets.symmetric(vertical: 1.h),
                                  child: Row(
                                    children: [
                                      Spacer(),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Centre.dialogBgColor,
                                          borderRadius: BorderRadius.circular(30),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(alpha: 0.35),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            splashColor: Centre.bgSplashColor,
                                            borderRadius: BorderRadius.circular(30),
                                            onTap: () {
                                              context.read<CategoryIsDescendingCubit>().toggle();
                                            },

                                            child: Ink(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 2.w),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,

                                                  children: [
                                                    BlocBuilder<CategoryIsDescendingCubit, bool>(
                                                      builder: (_, isDescending) {
                                                        return Stack(
                                                          children: [
                                                            AnimatedRotation(
                                                              turns: isDescending ? 0 : 0.5,
                                                              duration: const Duration(milliseconds: 300),
                                                              child: Icon(
                                                                Icons.south,
                                                                size: 3.5.w,
                                                                color: Centre.offWhite,
                                                              ),
                                                            ),
                                                            Positioned(
                                                              left: 3.w,
                                                              child: Icon(
                                                                Icons.sort,
                                                                size: 4.w,
                                                                color: Centre.offWhite,
                                                              ),
                                                            ),
                                                            SizedBox(width: 8.w),
                                                          ],
                                                        );
                                                      },
                                                    ),

                                                    Text("\$\$", style: Centre.listText),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),

                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.fastLinearToSlowEaseIn,
                          child: expandLevel == ExpandLevel.collapsed
                              ? SizedBox()
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    for (Expense expense in categoryInfo.expenseList.sublist(
                                      0,
                                      expandLevel == ExpandLevel.expanded ? null : 3,
                                    ))
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: AutoSizeText(
                                              expense.name,
                                              style: Centre.listText,
                                              maxLines: 1,
                                              minFontSize: 14.5.sp.roundToDouble(),
                                              maxFontSize: 15.5.sp.roundToDouble(),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),

                                          SizedBox(width: 2.w),
                                          Text("\$${expense.value.toStringAsFixed(2)}", style: Centre.listText),
                                        ],
                                      ),
                                    expandLevel == ExpandLevel.partial ? Icon(Icons.more_horiz, size: 4.w) : SizedBox(),
                                  ],
                                ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
