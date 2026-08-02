import 'dart:math';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/utils/centre.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:sizer/sizer.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final formKey = GlobalKey<FormState>();
  final TextEditingController editingController = TextEditingController(text: "");

  // Value notifiers to send events to their respective blocs when needed since shouldn't call context in async gaps
  final ValueNotifier<List<dynamic>?> editingYearMonthResults = // [dateRangeID, 0 / 1 {startDate OR endDate}, newDate ]
  ValueNotifier<List<dynamic>?>([
    null,
  ]);
  final ValueNotifier<List<DateTime?>> addingYearMonthResults = ValueNotifier<List<DateTime?>>([null, null]);

  final Map<String, int> categories = {
    "Entertainment": Centre.colors[Random().nextInt(54)].toARGB32(),
    "Grocery": Centre.colors[Random().nextInt(54)].toARGB32(),
    "Gas": Centre.colors[Random().nextInt(54)].toARGB32(),
    "Ava - Cat Supplies": Centre.colors[Random().nextInt(54)].toARGB32(),
  };

  // dateRangeID, [startDate, endDate]
  final Map<int, List<DateTime>> dateRanges = {
    0: [DateTime(2023, 1, 1), DateTime(2023, 12, 31)],
    1: [DateTime(2024, 1, 1), DateTime(2025, 12, 31)],
    2: [DateTime(2026, 1, 1), DateTime.now()],
  };

  List<Widget> categoryEditingList({
    required BuildContext context,
    required Map<String, int> categories,
    String? editingName,
  }) {
    List<Widget> categoryList = [];
    categories.forEach((name, color) {
      categoryList.addAll([
        Padding(
          padding: EdgeInsets.symmetric(vertical: 0.6.h),
          child: Row(
            children: [
              editingName == null || editingName != name
                  ? GestureDetector(
                      onTap: () {
                        context.read<SettingsEditingTextCubit>().editing(name: name);
                      },
                      child: Text(name, style: Centre.listText),
                    )
                  : CategoryTextField(
                      existingCategories: categories.keys.toList(),
                      formKey: formKey,
                      controller: editingController..text = name,
                    ),
              const Spacer(),
              BlocProvider<SettingsAddColorCubit>(
                create: (context) => SettingsAddColorCubit(null),
                child: ChooseColorBtn(color: color),
              ),
              SizedBox(width: 3.w),
              editingName == null || editingName != name
                  ? const SizedBox()
                  : GestureDetector(
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          // TODO: Update category from old "name" to new "editingcontroller.text"
                          editingController.clear();
                          context.read<SettingsEditingTextCubit>().editing(name: "");
                        }
                      },
                      child: const SizedBox(child: Center(child: Icon(Icons.check))),
                    ),
              name == "Other"
                  ? const SizedBox()
                  : IconButton.outlined(
                      onPressed: () {
                        if (editingName == null || editingName != name) {
                          // If not in editing mode, then delete button shows
                          //TODO:  Delete category
                        } else {
                          // If in editing mode, just clear
                          editingController.clear();
                          context.read<SettingsEditingTextCubit>().editing(name: "");
                        }
                      },
                      iconSize: 5.w,
                      color: Colors.white,
                      icon: Icon(editingName == null || editingName != name ? Icons.delete : Icons.close),
                    ),
            ],
          ),
        ),
      ]);
    });
    return [
      ...categoryList,
      SizedBox(height: 0.6.h),

      BlocProvider<SettingsAddColorCubit>(
        create: (_) => SettingsAddColorCubit(null),
        child: AddCategoryTextField(existingCategories: categories.keys.toList()),
      ),
    ];
  }

  Future<DateTime?> showCustomMonthPicker(BuildContext context) {
    return showMonthPicker(
      context: context,

      initialDate: DateTime.now(),
      monthStylePredicate: (DateTime val) {
        if (val.month == DateTime.now().month && val.year == DateTime.now().year) {
          return TextButton.styleFrom(backgroundColor: Centre.colors[28]);
        }
        return null;
      },
      yearStylePredicate: (int val) {
        if (val == DateTime.now().year) {
          return TextButton.styleFrom(backgroundColor: Centre.colors[28]);
        }
        return null;
      },
      monthPickerDialogSettings: MonthPickerDialogSettings(
        dialogSettings: PickerDialogSettings(
          verticalScrolling: false,
          dialogBackgroundColor: Centre.dialogBgColor,
          dialogRoundedCornersRadius: 12,
        ),
        headerSettings: PickerHeaderSettings(
          headerPadding: EdgeInsets.only(top: 4.w, left: 4.w, right: 4.w),
          headerBackgroundColor: Centre.dialogBgColor,
          headerCurrentPageTextStyle: Centre.semiTitleText,
          headerSelectedIntervalTextStyle: Centre.semiTitle2Text,
          headerIconsColor: Colors.white,
        ),
        dateButtonsSettings: PickerDateButtonsSettings(
          selectedMonthBackgroundColor: Centre.colors[33],
          selectedMonthTextColor: Centre.bgColor,
          unselectedMonthsTextColor: Centre.colors[33],
          currentMonthTextColor: Centre.bgColor,
          monthTextStyle: Centre.listText,
        ),
        actionBarSettings: PickerActionBarSettings(
          confirmWidget: Padding(
            padding: EdgeInsets.all(3.w),
            child: Text('OK', style: Centre.listText),
          ),
          cancelWidget: Padding(
            padding: EdgeInsets.all(3.w),
            child: Text('Cancel', style: Centre.listText),
          ),
        ),
      ),
    );
  }

  List<Widget> dateRangeList(BuildContext context) {
    List<Widget> rangeList = [];
    dateRanges.forEach((id, startEndDates) {
      rangeList.addAll([
        Padding(
          padding: EdgeInsets.symmetric(vertical: 0.6.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  showCustomMonthPicker(context).then((date) {
                    if (date != null) {
                      editingYearMonthResults.value = [id, 0, date];
                    }
                  });
                },
                child: BlocBuilder<TempEditingDateRangesCubit, Map<int, List<DateTime>>>(
                  builder: (_, dateRangeMap) {
                    return Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1.5),
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Text(DateFormat('yMMM').format(dateRangeMap[id]![0]), style: Centre.listText),
                    );
                  },
                ),
              ),
              Text(" - ", style: Centre.semiTitleText),
              GestureDetector(
                onTap: () {
                  showCustomMonthPicker(context).then((date) {
                    if (date != null) {
                      editingYearMonthResults.value = [id, 1, date];
                    }
                  });
                },
                child: BlocBuilder<TempEditingDateRangesCubit, Map<int, List<DateTime>>>(
                  builder: (_, dateRangeMap) {
                    return Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1.5),
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Text(DateFormat('yMMM').format(dateRangeMap[id]![1]), style: Centre.listText),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ]);
    });
    return [
      ...rangeList,
      Flex(direction: Axis.horizontal),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: SizedBox()),
          BlocBuilder<AddingDateRangeCubit, List<DateTime?>>(
            builder: (_, newDates) {
              return newDates[0] == null
                  ? IconButton.outlined(
                      onPressed: () {
                        showCustomMonthPicker(context).then((date) {
                          if (date != null) {
                            addingYearMonthResults.value = [date, null];
                          }
                        });
                      },
                      iconSize: 8.w,
                      color: Colors.white,
                      icon: Icon(Icons.calendar_month),
                    )
                  : GestureDetector(
                      onTap: () {
                        showCustomMonthPicker(context).then((date) {
                          if (date != null) {
                            addingYearMonthResults.value = [date, null];
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1.5),
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Text(DateFormat('yMMM').format(newDates[0]!), style: Centre.listText),
                      ),
                    );
            },
          ),

          Text(" - ", style: Centre.semiTitleText),
          BlocBuilder<AddingDateRangeCubit, List<DateTime?>>(
            builder: (_, newDates) {
              return newDates[1] == null
                  ? IconButton.outlined(
                      onPressed: () {
                        showCustomMonthPicker(context).then((date) {
                          if (date != null) {
                            addingYearMonthResults.value = [null, date];
                          }
                        });
                      },
                      iconSize: 8.w,
                      color: Colors.white,
                      icon: Icon(Icons.calendar_month),
                    )
                  : GestureDetector(
                      onTap: () {
                        showCustomMonthPicker(context).then((date) {
                          if (date != null) {
                            addingYearMonthResults.value = [null, date];
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1.5),
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Text(DateFormat('yMMM').format(newDates[1]!), style: Centre.listText),
                      ),
                    );
            },
          ),
          Expanded(
            child: IconButton.outlined(onPressed: () {}, iconSize: 5.w, color: Colors.white, icon: Icon(Icons.add)),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // TODO: replace editing value notifiers with settings bloc updates when updating existing date ranges
    // editingYearMonthResults.addListener(() {
    //   context.read<SettingsBloc().update(editingYearMonthResults.value);
    // });
    editingYearMonthResults.addListener(() {
      context.read<TempEditingDateRangesCubit>().update(
        editingYearMonthResults.value![0],
        editingYearMonthResults.value![1],
        editingYearMonthResults.value![2],
      );
    });
    addingYearMonthResults.addListener(() {
      context.read<AddingDateRangeCubit>().updateDates(addingYearMonthResults.value);
    });
    return SafeArea(
      child: Scaffold(
        backgroundColor: Centre.bgColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            child: Column(
              children: [
                Text("Manage Categories", style: Centre.semiTitleText),
                SizedBox(height: 2.h),
                Divider(color: Colors.white),
                SizedBox(height: 2.h),
                ...categoryEditingList(context: context, categories: categories),
                SizedBox(height: 4.h),
                Text("Budget Planning Date Ranges", style: Centre.semiTitleText),
                SizedBox(height: 2.h),
                ...dateRangeList(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChooseColorBtn extends StatelessWidget {
  final int? color;
  const ChooseColorBtn({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsAddColorCubit, int?>(
      builder: (_, chosenColor) {
        return GestureDetector(
          onTap: () {
            showAlignedDialog(
              followerAnchor: Alignment.topLeft,
              targetAnchor: Alignment.bottomLeft,
              barrierColor: Colors.transparent,
              offset: Offset(1.w, 0),
              context: context,
              builder: (BuildContext dialogContext) => GestureDetector(
                onTap: () {
                  if (context.read<SettingsAddColorCubit>().state != null) {
                    // TODO: update category color
                  }
                  Navigator.pop(dialogContext);
                },
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: BlocProvider<SettingsAddColorCubit>.value(
                    value: context.read<SettingsAddColorCubit>(),
                    child: const ChooseColorDialog(),
                  ),
                ),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.only(right: 2.w),
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(
              color: Color(chosenColor ?? color!),
              border: Border.all(color: Colors.white, width: 1.5),
              borderRadius: const BorderRadius.all(Radius.circular(40)),
            ),
          ),
        );
      },
    );
  }
}

class CategoryTextField extends StatefulWidget {
  final List<String> existingCategories;
  final TextEditingController controller;
  final GlobalKey formKey;
  // final FocusNode focusNode;
  const CategoryTextField({
    super.key,
    required this.controller,
    required this.formKey,
    // required this.focusNode,
    required this.existingCategories,
  });

  @override
  State<CategoryTextField> createState() => _CategoryTextFieldState();
}

class _CategoryTextFieldState extends State<CategoryTextField> {
  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60.w,
      child: Form(
        key: widget.formKey,
        child: TextFormField(
          autofocus: true,
          // focusNode: widget.focusNode,
          controller: widget.controller,
          autovalidateMode: AutovalidateMode.disabled,
          validator: (text) {
            if (text == null || text.isEmpty) {
              return 'Can\'t be empty';
            } else if (text.length > 100) {
              return 'Too long';
            } else if (widget.existingCategories.contains(text)) {
              return 'Category already exists';
            }
            return null;
          },
          style: Centre.listText,
          decoration: InputDecoration(
            errorStyle: const TextStyle(height: 0.5),
            hintText: "Category name",
            hintStyle: Centre.listText.copyWith(color: Colors.blueGrey),
            isDense: true,
          ),
        ),
      ),
    );
  }
}

class AddCategoryTextField extends StatefulWidget {
  final List<String> existingCategories;
  const AddCategoryTextField({super.key, required this.existingCategories});

  @override
  State<AddCategoryTextField> createState() => _AddCategoryTextFieldState();
}

class _AddCategoryTextFieldState extends State<AddCategoryTextField> {
  final TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 60.w,
          child: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              autovalidateMode: AutovalidateMode.disabled,
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return 'Can\'t be empty';
                } else if (text.length > 100) {
                  return 'Too long';
                } else if (widget.existingCategories.contains(text)) {
                  return 'Category already exists';
                } else if (context.read<SettingsAddColorCubit>().state == null) {
                  return 'No color chosen';
                }
                return null;
              },
              style: Centre.listText,
              decoration: InputDecoration(
                errorStyle: const TextStyle(height: 0.5),
                hintText: "Category name",
                hintStyle: Centre.listText.copyWith(color: Colors.blueGrey),
                isDense: true,
              ),
            ),
          ),
        ),
        SizedBox(width: 3.w),
        ChooseColorBtn(color: Colors.transparent.toARGB32()),
        SizedBox(width: 3.w),

        IconButton.outlined(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              // Add category with controller.text, context.read<SettingsAddColorCubit>().state!,
              controller.clear();
              context.read<SettingsAddColorCubit>().selectColor(color: null);
            }
          },
          iconSize: 5.w,
          color: Colors.white,
          icon: Icon(Icons.add),
        ),
      ],
    );
  }
}

class ChooseColorDialog extends StatelessWidget {
  const ChooseColorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    Widget colourBtn(int i) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          context.read<SettingsAddColorCubit>().selectColor(color: Centre.colors[i].toARGB32());
        },
        child: BlocBuilder<SettingsAddColorCubit, int?>(
          builder: (context, chosenColor) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 0.8.h, horizontal: 2.w),
              width: 6.5.w,
              height: 6.5.w,
              decoration: BoxDecoration(
                color: Centre.colors[i],
                border: Border.all(color: Colors.white, width: 1.5),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: chosenColor == Centre.colors[i].toARGB32()
                  ? Icon(Icons.check, size: 5.w, color: Centre.bgColor)
                  : null,
            );
          },
        ),
      );
    }

    return GestureDetector(
      onTap: () {},
      child: Material(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
        color: Centre.dialogBgColor,
        elevation: 0,
        child: SizedBox(
          height: 15.8.h,
          width: 69.w,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
            child: Column(
              children: [
                for (int i = 0; i < 3; i++)
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [for (int j = 0; j < 6; j++) colourBtn(i * 6 + j)],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
