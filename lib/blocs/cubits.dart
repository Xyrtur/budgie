import 'package:budgie/widgets/budget_planning/category_box.dart';
import 'package:budgie/widgets/budget_planning/fixed_formfield_row.dart';
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

  void updateDates(List<DateTime?> newDates) {
    if (newDates[0] == null) {
      emit([state[0], newDates[1]]);
    } else {
      emit([newDates[0], state[1]]);
    }
  }
}

class TempIncludeFixedCubit extends Cubit<bool> {
  TempIncludeFixedCubit() : super(false);
  void toggle() {
    emit(!state);
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
  final double startingTotal;
  LiveBudgetTotalTrackerCubit(this.startingTotal) : super(startingTotal);

  void updateTotal({required double value}) {
    emit(value);
  }
}

class SpendingGraphViewToggleCubit extends Cubit<bool> {
  SpendingGraphViewToggleCubit() : super(false);

  void toggle() {
    emit(!state);
  }
}

class SpendingCategoriesToggledCubit extends Cubit<List<String>> {
  SpendingCategoriesToggledCubit()
    : super([
        "Groceries",
        "Entertainment",
        "House",
        "Gas",
        "Junk Food",
        "Ava",
        "Category 1",
        "Category 2",
        "Category 3",
        "Category 4",
      ]);

  void toggleCategory(String category) {
    if (state.contains(category)) {
      state.remove(category);
      emit([...state]);
    } else {
      emit([...state, category]);
    }
  }
}

class YearsSelectedCubit extends Cubit<Map<int, bool>> {
  YearsSelectedCubit() : super({DateTime.now().year: true});

  void updateSelectedYears(List<int> yearsSelected) {
    Map<int, bool> newMap = {};
    for (int year in yearsSelected) {
      newMap[year] = state[year] ?? false;
    }
    emit(newMap);
  }

  void toggleYear(int year) {
    state[year] = !state[year]!;
    emit({...state});
  }
}

class FixedCostFieldKeysCubit extends Cubit<List<GlobalKey<FixedFormFieldRowState>>> {
  final List<GlobalKey<FixedFormFieldRowState>> keyList;
  FixedCostFieldKeysCubit(this.keyList) : super(keyList);

  void add() {
    emit([...state, GlobalKey<FixedFormFieldRowState>()]);
  }

  void delete({required int index}) {
    final newList = [...state];
    newList.removeAt(index);
    emit(newList);
  }
}

class FixedLabelsAndCostsCubit extends Cubit<List<String>> {
  final List<String> initialLabelsAndCostsList;
  FixedLabelsAndCostsCubit(this.initialLabelsAndCostsList) : super(initialLabelsAndCostsList);

  void updateList(List<String> newList) {
    emit(newList);
  }

  void add() {
    final newList = [...state];

    newList.addAll(["", ""]);
    emit(newList);
  }

  void delete({required int index}) {
    // Because two are deleted at a time, remove label field at index
    // the cost field gets shifted up to same index
    // Reuse index given to also delete the cost field
    final newList = [...state];
    newList.removeAt(index);
    newList.removeAt(index);
    emit(newList);
  }
}

class CategoryBoxKeysCubit extends Cubit<List<GlobalKey<CategoryBoxState>>> {
  final List<GlobalKey<CategoryBoxState>> keys;
  CategoryBoxKeysCubit(this.keys) : super(keys);

  void add() {
    emit([...state, GlobalKey<CategoryBoxState>()]);
  }

  void remove() {
    final newList = [...state];
    newList.removeLast();
    emit(newList);
  }
}

class CategoryBoxTextsCubit extends Cubit<Map<String, String>> {
  // category name and budget limit for category
  final Map<String, String> categoryBoxTexts;
  CategoryBoxTextsCubit(this.categoryBoxTexts) : super(categoryBoxTexts);

  void update({required String categoryName, required String categoryLimit}) {
    final newMap = {...state};
    newMap[categoryName] = categoryLimit;
    emit(newMap);
  }
}
