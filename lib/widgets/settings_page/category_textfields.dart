import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/utils/centre.dart';
import 'package:budgie/widgets/icon_button.dart';
import 'package:budgie/widgets/settings_page/choose_color_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class CategoryTextField extends StatefulWidget {
  final List<String> existingCategories;
  final String previousText;
  const CategoryTextField({super.key, required this.previousText, required this.existingCategories});

  @override
  State<CategoryTextField> createState() => _CategoryTextFieldState();
}

class _CategoryTextFieldState extends State<CategoryTextField> {
  final TextEditingController controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    controller.text = widget.previousText;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50.w,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        onTapOutside: (_) {
          focusNode.unfocus();
        },
        autovalidateMode: AutovalidateMode.disabled,
        validator: (text) {
          if (text == null || text.isEmpty) {
            return 'Can\'t be empty';
          } else if (text.length > 100) {
            return 'Too long';
          } else if (widget.existingCategories.contains(text)) {
            return 'Category already exists';
          } else if (context.read<ChooseColorCubit>().state.isEmpty) {
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        children: [
          SizedBox(
            width: 50.w,
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
                  } else if (context.read<ChooseColorCubit>().state.isEmpty) {
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
          Spacer(),

          ChooseColorBtn(categoryName: null),
          SizedBox(width: 3.w),
          CustomIconButton(
            onTap: () {
              if (formKey.currentState!.validate()) {
                // Add category with controller.text, context.read<SettingsAddColorCubit>().state!,
                controller.clear();
                context.read<ChooseColorCubit>().selectColor(color: Colors.transparent.toARGB32(), inSettingsPage: true);
              }
            },
            child: Icon(Icons.add, size: 5.w, color: Centre.primaryColor),
          ),
        ],
      ),
    );
  }
}
