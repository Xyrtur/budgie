import 'package:budgie/blocs/cubits.dart';
import 'package:budgie/utils/centre.dart';
import 'package:budgie/widgets/icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class ToggleGraphviewButton extends StatelessWidget {
  const ToggleGraphviewButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      onTap: () {
        context.read<SpendingGraphViewToggleCubit>().toggle();
      },
      child: BlocBuilder<SpendingGraphViewToggleCubit, bool>(
        builder: (_, graphviewEnabled) {
          return graphviewEnabled
              ? Icon(Icons.auto_graph_sharp, color: Centre.primaryColor, size: 6.w)
              : Icon(Icons.list, color: Centre.primaryColor, size: 6.w);
        },
      ),
    );
  }
}
