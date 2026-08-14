import 'package:budgie/utils/centre.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomIconButton extends StatelessWidget {
  final void Function() onTap;
  final Widget child;
  const CustomIconButton({super.key, required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Centre.dialogBgColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Centre.buttonBorderColor, width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.35), blurRadius: 16, offset: const Offset(0, 5)),
          BoxShadow(color: Colors.white.withValues(alpha: 0.1), blurRadius: 1, offset: const Offset(0, -1)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: onTap,

          child: Ink(
            child: Padding(padding: EdgeInsets.all(2.w), child: child),
          ),
        ),
      ),
    );
  }
}
