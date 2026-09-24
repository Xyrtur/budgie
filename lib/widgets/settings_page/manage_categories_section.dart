import 'dart:math';

import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/utils/centre.dart';
import 'package:budgie/widgets/icon_button.dart';
import 'package:budgie/widgets/settings_page/category_textfields.dart';
import 'package:budgie/widgets/settings_page/choose_color_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class ManageCategoriesSection extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  ManageCategoriesSection({super.key, required this.formKey});

  final Map<String, int> categories = {
    "Entertainment": Centre.colors[Random().nextInt(54)].toARGB32(),
    "Grocery": Centre.colors[Random().nextInt(54)].toARGB32(),
    "Gas": Centre.colors[Random().nextInt(54)].toARGB32(),
    "Ava - Cat Supplies": Centre.colors[Random().nextInt(54)].toARGB32(),
    "Other": Colors.transparent.toARGB32(),
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsEditingTextCubit, String>(
      builder: (_, editingName) {
        return Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Manage Categories", style: Centre.semiTitleText),
              SizedBox(height: 0.5.h),
              Divider(),
              SizedBox(height: 2.h),
              for (MapEntry<String, int> category in categories.entries)
                BlocProvider<ChooseColorCubit>(
                  create: (context) => ChooseColorCubit([category.value]),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 0.6.h, horizontal: 4.w),
                    child: Row(
                      children: [
                        if (editingName != category.key)
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (formKey.currentState!.validate()) {
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
                                  if (formKey.currentState!.validate()) {
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
