import 'dart:ui';

import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/utils/centre.dart';
import 'package:budgie/widgets/icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

// TODO: convert back to stateless once implement blocs
class SavingsBalancesSection extends StatefulWidget {
  SavingsBalancesSection({super.key, required this.formKey});
  final GlobalKey<FormState> formKey;

  @override
  State<SavingsBalancesSection> createState() => _SavingsBalancesSectionState();
}

class _SavingsBalancesSectionState extends State<SavingsBalancesSection> {
  List<MapEntry<String, double>> savingsList = [];
  final Map<String, double> savings = {"Emerg": 12345, "Savings": 15647.56};

  @override
  void initState() {
    super.initState();
    savingsList = savings.entries.toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditingSavingsTextsCubit, EditingState>(
      builder: (_, editingState) {
        return Form(
          key: widget.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Manage Savings Balances", style: Centre.semiTitleText),
              SizedBox(height: 0.5.h),
              Divider(),
              Text(
                "Select account to take future expenses from",
                style: Centre.listText.copyWith(fontSize: 15.sp, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 1.h),

              ReorderableListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: savingsList.length,
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
                    builder: (_, Widget? child) {
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
                itemBuilder: (_, index) {
                  final account = savingsList[index];
                  return ReorderableDragStartListener(
                    index: index,
                    key: ValueKey(account),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 7.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.drag_handle, size: 4.w, color: Centre.offWhite),
                          SizedBox(width: 7.w),

                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                context.read<ExpenseAccountCubit>().selectAccount(account.key);
                              },

                              child: Ink(
                                height: 5.w,
                                width: 5.w,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Centre.offWhite),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: BlocBuilder<ExpenseAccountCubit, String>(
                                  bloc: context.read<ExpenseAccountCubit>(),
                                  builder: (_, selectedAccount) {
                                    return selectedAccount == account.key
                                        ? Icon(Icons.check, color: Centre.offWhite, size: 4.w)
                                        : SizedBox();
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 5.w),
                          editingState.name == account.key && editingState.isEditingName == true
                              ? EditingSavingsTextField(
                                  previousText: account.key,
                                  existingAccountNames: savings.keys.toList()..remove(account.key),
                                )
                              : Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      if (widget.formKey.currentState!.validate()) {
                                        context.read<EditingSavingsTextsCubit>().selectText(account.key, true);
                                      }
                                    },
                                    child: Text(account.key, style: Centre.listText),
                                  ),
                                ),
                          SizedBox(width: 2.w),
                          editingState.name == account.key && editingState.isEditingName == false
                              ? EditingSavingsTextField(previousText: account.value.toStringAsFixed(2))
                              : Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      if (widget.formKey.currentState!.validate()) {
                                        context.read<EditingSavingsTextsCubit>().selectText(account.key, false);
                                      }
                                    },
                                    child: Text(
                                      "\$ ${account.value.toStringAsFixed(2)}",
                                      style: Centre.listText,
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ),
                          SizedBox(width: 5.w),
                          editingState.name == account.key
                              ? CustomIconButton(
                                  onTap: () {
                                    if (widget.formKey.currentState!.validate()) {
                                      context.read<EditingSavingsTextsCubit>().selectText("", false);
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
                  );
                },
                onReorderItem: (oldIndex, newIndex) {
                  // TODO:do when implement db + bloc
                  final movedItem = savingsList.removeAt(oldIndex);
                  savingsList.insert(newIndex, movedItem);
                },
              ),

              CustomIconButton(
                onTap: () {
                  savingsList.add(MapEntry("", 0.00));
                  context.read<EditingSavingsTextsCubit>().selectText("", true);
                },
                child: Icon(Icons.add, size: 5.w, color: Centre.primaryColor),
              ),
              BlocBuilder<ToggleCubit, bool>(
                builder: (_, enabled) {
                  return GestureDetector(
                    onTap: () {
                      context.read<ToggleCubit>().toggle();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Transform.scale(
                            scale: 0.8,
                            child: Switch(
                              thumbIcon: Centre.thumbIcon,
                              thumbColor: Centre.thumbColor,
                              trackColor: Centre.trackColor,
                              trackOutlineColor: Centre.trackOutlineColor,

                              value: enabled,
                              onChanged: (bool value) {
                                context.read<ToggleCubit>().toggle();
                              },
                            ),
                          ),
                          SizedBox(width: 1.w),
                          Text("Show total savings", style: Centre.semiTitle2Text),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class EditingSavingsTextField extends StatefulWidget {
  final String previousText;
  final List<String>? existingAccountNames;

  const EditingSavingsTextField({super.key, required this.previousText, this.existingAccountNames});

  @override
  State<EditingSavingsTextField> createState() => _EditingSavingsTextFieldState();
}

class _EditingSavingsTextFieldState extends State<EditingSavingsTextField> {
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
    return Expanded(
      child: TextFormField(
        focusNode: focusNode,
        controller: controller,
        autovalidateMode: AutovalidateMode.onUnfocus,
        style: Centre.listText,
        validator: (text) {
          if (text == null || text.isEmpty) {
            return 'Can\'t be empty';
          } else if (text.length > 100) {
            return 'Too long';
          } else if ((widget.existingAccountNames ?? []).contains(text)) {
            return 'Account name already exists';
          }
          return null;
        },
        keyboardType: widget.existingAccountNames != null ? null : TextInputType.number,
        decoration: InputDecoration(
          hintText: widget.existingAccountNames != null ? 'Eg. Savings' : "123.45",
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.35)),
          prefixIcon: widget.existingAccountNames != null
              ? null
              : Text('\$ ', style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 14)),
          prefixIconConstraints: widget.existingAccountNames != null ? null : BoxConstraints(minWidth: 0, minHeight: 0),
          errorStyle: TextStyle(height: 1, fontSize: 13.5.sp),
          isDense: true,
          errorMaxLines: 2,
        ),
      ),
    );
  }
}
