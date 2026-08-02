import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/**
 * List of cubits:
 * 
 * CurrentSelectedPageCubit
 * SpendingViewSwapCubit
 */

enum PageSelected { Overview, TripPlanning, BudgetPlanning, UserSettings }

class NavbarCubit extends Cubit<PageSelected> {
  final PageSelected page;
  NavbarCubit(this.page) : super(page);

  void changePage({required PageSelected page}) {
    emit(page);
  }
}

class FABIconCubit extends Cubit<IconData> {
  final IconData icon;
  FABIconCubit(this.icon) : super(icon);

  void changeIcon({required PageSelected page}) {
    switch (page) {
      case PageSelected.Overview:
        emit(Icons.add);
      case PageSelected.TripPlanning:
        emit(Icons.add);
      case PageSelected.BudgetPlanning:
        emit(Icons.check);
      case PageSelected.UserSettings:
        emit(Icons.import_export);
    }
  }
}

class LiveBudgetTotalTrackerCubit extends Cubit<double> {
  LiveBudgetTotalTrackerCubit() : super(0);

  void updateTotal({required double value}) {
    emit(value);
  }
}
