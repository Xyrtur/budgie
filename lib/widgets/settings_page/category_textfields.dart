import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/utils/centre.dart';
import 'package:budgie/widgets/settings_page/choose_color_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

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
        ChooseColorBtn(color: Colors.transparent.toARGB32(), categoryName: null),
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
