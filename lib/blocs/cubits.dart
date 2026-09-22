import 'dart:math';

import 'package:budgie/utils/centre.dart';
import 'package:budgie/widgets/budget_planning/category_box.dart';
import 'package:budgie/widgets/budget_planning/fixed_formfield_row.dart';
import 'package:budgie/widgets/dialogs/add_edit_expense_dialog.dart';
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
class ChooseColorCubit extends Cubit<List<int>> {
  final List<int> colorList;
  ChooseColorCubit(this.colorList) : super(colorList);

  void selectColor({required int color, required bool inSettingsPage}) {
    // if transparent color selected, all colors cleared
    if (color == Colors.transparent.toARGB32()) {
      emit([]);
      return;
    }
    if (inSettingsPage) {
      emit([color]);
      return;
    }

    if (state.contains(color)) {
      // Toggle off
      List<int> newState = [...state];
      newState.remove(color);
      emit(newState);
      return;
    } else {
      // Toggle on and get rid of oldest color if >3 colors chosen
      final newState = [...state, color];
      if (newState.length > 3) newState.removeAt(0);
      emit(newState);
      return;
    }
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

class FABIconCubit extends Cubit<PageSelected> {
  FABIconCubit() : super(PageSelected.Overview);

  void changeIcon({required PageSelected page}) {
    emit(page);
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
    : super(["Groceries", "Entertainment", "House", "Gas", "Junk Food", "Ava", "Category 1", "Category 2", "Category 3", "Category 4"]);

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

class AddExpenseCategoryBtnsCubit extends Cubit<String> {
  final String categorySelected;
  AddExpenseCategoryBtnsCubit(this.categorySelected) : super(categorySelected);

  void update({required String category}) {
    emit(category);
  }
}

class DatesSelectedCubit extends Cubit<List<DateTime?>> {
  final List<DateTime?> dates;
  DatesSelectedCubit({this.dates = const [null, null]}) : super(dates);
  void updateSingle({required DateTime date}) {
    emit([date]);
  }

  void updateStart({required DateTime date}) {
    emit([date, state.last]);
  }

  void updateEnd({required DateTime date}) {
    emit([state.first, date]);
  }
}

class IsIncomeToggleCubit extends Cubit<bool> {
  final bool isIncome;
  IsIncomeToggleCubit({this.isIncome = false}) : super(isIncome);
  void toggle() {
    emit(!state);
  }
}

enum RecordType { entry, total, title }

typedef Record = ({String name, DateTime? startDate, DateTime? endDate, List<int> colors, double value, RecordType type});

class TempTripRecordsCubit extends Cubit<Map<String, List<Record>>> {
  TempTripRecordsCubit()
    : super({
        "Europe Trip": [
          (
            name: "Vienna Stay",
            startDate: DateTime(2024, 05, 19),
            endDate: DateTime(2024, 05, 24),
            colors: [Centre.colors[Random().nextInt(54)].toARGB32()],
            value: 1234.65,
            type: RecordType.entry,
          ),
          (
            name: "Vienna Transport",
            startDate: null,
            endDate: null,
            colors: [Centre.colors[Random().nextInt(54)].toARGB32()],
            value: 546.67,
            type: RecordType.entry,
          ),
          (
            name: "Total",
            startDate: null,
            endDate: null,
            colors: [Centre.colors[Random().nextInt(54)].toARGB32()],
            value: 1781.22,
            type: RecordType.total,
          ),
          (
            name: "Amsterdam Stay",
            startDate: DateTime(2024, 05, 26),
            endDate: DateTime(2024, 05, 30),
            colors: [Centre.colors[Random().nextInt(54)].toARGB32()],
            value: 1537.22,
            type: RecordType.entry,
          ),
        ],

        "Japan": [
          (
            name: "Osaka Stay",
            startDate: DateTime(2025, 11, 05),
            endDate: DateTime(2025, 11, 15),
            colors: [Centre.colors[Random().nextInt(54)].toARGB32()],
            value: 1234.65,
            type: RecordType.entry,
          ),
          (
            name: "Tokyo Transport",
            startDate: null,
            endDate: null,
            colors: [Centre.colors[Random().nextInt(54)].toARGB32()],
            value: 546.67,
            type: RecordType.entry,
          ),
          (
            name: "Tokyo Stay",
            startDate: null,
            endDate: null,
            colors: [Centre.colors[Random().nextInt(54)].toARGB32()],
            value: 546.67,
            type: RecordType.entry,
          ),
          (
            name: "Total",
            startDate: null,
            endDate: null,
            colors: [Centre.colors[Random().nextInt(54)].toARGB32()],
            value: 1781.22,
            type: RecordType.total,
          ),
          (
            name: "Kyoto Stay",
            startDate: DateTime(2026, 01, 1),
            endDate: DateTime(2026, 01, 12),
            colors: [Centre.colors[Random().nextInt(54)].toARGB32()],
            value: 1537.22,
            type: RecordType.entry,
          ),
        ],
      });

  void changeColor(String tripName, int index, List<int> newColors) {
    final newState = {...state};
    Record rec = (
      name: newState[tripName]![index].name,
      startDate: newState[tripName]![index].startDate,
      endDate: newState[tripName]![index].endDate,
      colors: newColors,
      value: newState[tripName]![index].value,
      type: newState[tripName]![index].type,
    );
    newState[tripName]!.removeAt(index);

    newState[tripName]!.insert(index, rec);
    emit(newState);
  }

  void reOrder(String tripName, List<Record> recordList) {
    final newState = {...state};
    newState[tripName] = recordList;
    emit(newState);
  }

  void insertAt(String tripName, int index, RecordType type) {
    final newState = {...state};
    int newValue = 0;
    if (type == RecordType.total) {
      // TODO: Finish this code during bloc implementation
    }
    Record rec = (name: type == RecordType.total ? "Total" : "Placeholder Title", startDate: null, endDate: null, colors: [], value: 0, type: type);
    newState[tripName]!.insert(index, rec);
    emit(newState);
  }
}

enum ExpandLevel { collapsed, partial, expanded }

class CategoryIsExpandedCubit extends Cubit<ExpandLevel> {
  CategoryIsExpandedCubit() : super(ExpandLevel.collapsed);

  void toggle() {
    switch (state) {
      case ExpandLevel.collapsed:
        emit(ExpandLevel.partial);
        break;
      case ExpandLevel.partial:
        emit(ExpandLevel.expanded);
        break;
      case ExpandLevel.expanded:
        emit(ExpandLevel.collapsed);
        break;
    }
  }
}

class CategoryIsDescendingCubit extends Cubit<bool> {
  CategoryIsDescendingCubit() : super(true);

  void toggle() {
    emit(!state);
  }
}

class ToggleCubit extends Cubit<bool> {
  ToggleCubit() : super(false);

  void toggle() {
    emit(!state);
  }
}

class ExpenseAccountCubit extends Cubit<String> {
  final String accountName;
  ExpenseAccountCubit({required this.accountName}) : super(accountName);

  void selectAccount(String name) {
    if (state == name) {
      emit("");
    } else {
      emit(name);
    }
  }
}

// TODO: Change this to bloc after
typedef EditingState = ({String name, bool isEditingName});

class EditingSavingsTextsCubit extends Cubit<EditingState> {
  EditingSavingsTextsCubit() : super((name: "", isEditingName: false));

  void selectText(String name, bool isEditingName) {
    emit((name: name, isEditingName: isEditingName));
  }
}
