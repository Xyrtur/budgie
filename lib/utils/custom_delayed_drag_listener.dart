import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomDelayedDragStartListener extends ReorderableDelayedDragStartListener {
  const CustomDelayedDragStartListener({super.key, required super.child, required super.index, super.enabled});

  @override
  MultiDragGestureRecognizer createRecognizer() {
    return DelayedMultiDragGestureRecognizer(
      delay: const Duration(milliseconds: 100), // default: 500 ms
      debugOwner: this,
    );
  }
}
