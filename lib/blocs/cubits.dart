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

/// This cubit tracks what category name is being edited.
///
/// [name] is the original name of what is being edited. Unique names only.
class SettingsEditingTextCubit extends Cubit<String> {
  SettingsEditingTextCubit() : super("");

  void editing({required String name}) {
    emit(name);
  }
}

/// This cubit tracks what color is selected in the color dialog on the settings page.
///
/// The initial state is the old color of the category.
class SettingsAddColorCubit extends Cubit<int?> {
  final int? color;
  SettingsAddColorCubit(this.color) : super(color);

  void selectColor({required int? color}) {
    emit(color);
  }
}

// TODO: Remove when implement settings bloc
class TempEditingDateRangesCubit extends Cubit<Map<int, List<DateTime>>> {
  TempEditingDateRangesCubit()
    : super({
        0: [DateTime(2023, 1, 1), DateTime(2023, 12, 31)],
        1: [DateTime(2024, 1, 1), DateTime(2025, 12, 31)],
        2: [DateTime(2026, 1, 1), DateTime.now()],
      });

  void update(int dateRangeID, int editingEndDate, DateTime newDate) {
    state[dateRangeID]![editingEndDate] = newDate;
    emit(state);
  }
}

/// This cubit tracks what the new date ranges are before they are added
///
/// [state] is [startDate, endDate]
class AddingDateRangeCubit extends Cubit<List<DateTime?>> {
  AddingDateRangeCubit() : super([null, null]);
  // state

  void updateDates(int editingEndDate, DateTime newDate) {
    state[editingEndDate] = newDate;
    emit(state);
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
