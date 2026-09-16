import 'package:budgie/utils/centre.dart';
import 'package:flutter/material.dart';

class DialogInfoTextField extends StatefulWidget {
  // It's either name or amount
  final bool isName;
  final bool autofocus;
  final TextEditingController controller;
  const DialogInfoTextField({super.key, required this.isName, required this.controller, this.autofocus = false});
  @override
  State<DialogInfoTextField> createState() => DialogInfoTextFieldState();
}

class DialogInfoTextFieldState extends State<DialogInfoTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      autofocus: widget.autofocus,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (text) {
        if (text == null || text.isEmpty) {
          return 'Can\'t be empty';
        } else if (text.length > 100) {
          return 'Too long';
        }
        return null;
      },
      style: widget.isName ? Centre.titleText : Centre.semiTitleText,
      keyboardType: widget.isName ? null : TextInputType.number,

      decoration: InputDecoration(
        prefixIcon: widget.isName ? null : Text('\$ ', style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 14)),
        prefixIconConstraints: widget.isName ? null : BoxConstraints(minWidth: 0, minHeight: 0),
        errorStyle: TextStyle(height: 0.5),

        hintText: widget.isName ? "Expense name" : "123.45",
        hintStyle: widget.isName
            ? Centre.titleText.copyWith(color: const Color.fromARGB(255, 181, 181, 181))
            : Centre.semiTitleText.copyWith(color: Colors.grey),
        isDense: true,
      ),
    );
  }
}
