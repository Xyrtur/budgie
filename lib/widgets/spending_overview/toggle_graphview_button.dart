import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/utils/centre.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class ToggleGraphviewButton extends StatelessWidget {
  const ToggleGraphviewButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton.outlined(
      onPressed: () {
        context.read<SpendingGraphViewToggleCubit>().toggle();
      },
      iconSize: 6.w,
      color: Centre.accentColor,
      icon: BlocBuilder<SpendingGraphViewToggleCubit, bool>(
        builder: (_, graphviewEnabled) {
          return ClipOval(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              reverseDuration: const Duration(milliseconds: 200),

              transitionBuilder: (Widget child, Animation<double> animation) {
                final isIncoming = child.key == (graphviewEnabled ? ValueKey(1) : ValueKey(2));
                final offsetAnimation = Tween<Offset>(
                  begin: isIncoming
                      ? const Offset(0, 1) // New icon starts below
                      : const Offset(0, -1),
                  end: Offset.zero,
                ).animate(animation);
                return SlideTransition(position: offsetAnimation, child: child);
              },
              child: graphviewEnabled
                  ? Icon(Icons.auto_graph_sharp, key: ValueKey(1), color: Centre.colors[42])
                  : Icon(Icons.list, key: ValueKey(2), color: Centre.colors[42]),
            ),
          );
        },
      ),
    );
  }
}
