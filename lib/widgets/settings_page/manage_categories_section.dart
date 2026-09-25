import 'dart:math';
import 'dart:ui';

import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/utils/centre.dart';
import 'package:budgie/widgets/icon_button.dart';
import 'package:budgie/widgets/settings_page/category_textfields.dart';
import 'package:budgie/widgets/settings_page/choose_color_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class ManageCategoriesSection extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  ManageCategoriesSection({super.key, required this.formKey});

  @override
  State<ManageCategoriesSection> createState() => _ManageCategoriesSectionState();
}

class _ManageCategoriesSectionState extends State<ManageCategoriesSection> {
  final Map<String, int> categories = {
    "Entertainment": Centre.colors[Random().nextInt(54)].toARGB32(),
    "Grocery": Centre.colors[Random().nextInt(54)].toARGB32(),
    "Gas": Centre.colors[Random().nextInt(54)].toARGB32(),
    "Ava - Cat Supplies": Centre.colors[Random().nextInt(54)].toARGB32(),
    "Other": Colors.transparent.toARGB32(),
  };
  List<MapEntry<String, int>> categoriesList = [];

  @override
  void initState() {
    super.initState();
    categoriesList = categories.entries.toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsEditingTextCubit, String>(
      builder: (_, editingName) {
        return Form(
          key: widget.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Manage Categories", style: Centre.semiTitleText),
              SizedBox(height: 0.5.h),
              Divider(),
              SizedBox(height: 2.h),
              ReorderableListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: categoriesList.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                onReorderStart: (_) {
                  // Unfocus the textfield when dragging starts
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                buildDefaultDragHandles: false,
                proxyDecorator: (child, index, animation) {
                  return AnimatedBuilder(
                    animation: animation,
                    builder: (BuildContext context, Widget? child) {
                      final double animValue = Curves.easeInOut.transform(animation.value);
                      final double elevation = lerpDouble(1, 6, animValue)!;
                      final double scale = lerpDouble(1, 1.02, animValue)!;
                      return Transform.scale(
                        scale: scale,
                        // Create a Card based on the color and the content of the dragged one
                        // and set its elevation to the animated value.
                        child: Card(elevation: elevation, color: Centre.dialogBgColor, child: child),
                      );
                    },
                    child: child,
                  );
                },
                itemBuilder: (context, index) {
                  final category = categoriesList[index];
                  return ReorderableDragStartListener(
                    index: index,
                    key: ValueKey(category),
                    child: BlocProvider<ChooseColorCubit>(
                      create: (context) => ChooseColorCubit([category.value]),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.6.h, horizontal: 4.w),
                        child: Row(
                          children: [
                            Icon(Icons.drag_handle, size: 4.w, color: Centre.offWhite),
                            SizedBox(width: 4.w),

                            if (editingName != category.key)
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    if (widget.formKey.currentState!.validate()) {
                                      context.read<SettingsEditingTextCubit>().editing(name: category.key);
                                    }
                                  },
                                  child: Text(category.key, style: Centre.listText),
                                ),
                              )
                            else ...[
                              CategoryTextField(
                                existingCategories: categories.keys.toList()..remove(category.key),
                                previousText: category.key,
                              ),
                              Spacer(),
                            ],
                            ChooseColorBtn(categoryName: category.key),

                            SizedBox(width: 3.w),
                            category.key == "Other"
                                ? SizedBox(width: 9.5.w)
                                : editingName == category.key
                                ? CustomIconButton(
                                    onTap: () {
                                      if (widget.formKey.currentState!.validate()) {
                                        context.read<SettingsEditingTextCubit>().editing(name: "");
                                      }
                                    },
                                    child: Icon(Icons.check, size: 5.w, color: Centre.primaryColor),
                                  )
                                : CustomIconButton(
                                    onTap: () {},
                                    child: Icon(Icons.delete, size: 5.w, color: Centre.primaryColor),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                onReorderItem: (oldIndex, newIndex) {
                  // TODO:do when implement db + bloc
                  final movedItem = categoriesList.removeAt(oldIndex);
                  categoriesList.insert(newIndex, movedItem);
                },
              ),

              SizedBox(height: 0.6.h),

              BlocProvider<ChooseColorCubit>(
                create: (_) => ChooseColorCubit([]),
                child: AddCategoryTextField(existingCategories: categories.keys.toList()),
              ),
            ],
          ),
        );
      },
    );
  }
}
