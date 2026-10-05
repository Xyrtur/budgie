part of 'repository.dart';

class Transactions extends Table {
  late final id = integer().autoIncrement()();
  late final title = text().withLength(min: 2, max: 32)();
  // Stores cents to avoid rounding problems
  late final value = integer()();
  late final categoryId = integer().references(Categories, #id, onDelete: KeyAction.restrict)();
  late final date = dateTime()();
}

class Categories extends Table {
  late final id = integer().autoIncrement()();
  late final name = text().unique()();
  late final color = integer()();
  late final isExpense = boolean()();
  late final isArchived = boolean().withDefault(const Constant(false))();
}

class FixedCosts extends Table {
  late final id = integer().autoIncrement()();
  late final name = text().unique()();
}

class BudgetPeriods extends Table {
  late final id = integer().autoIncrement()();
  late final startDate = dateTime()();
  late final Column<DateTime> endDate = dateTime().check(endDate.isBiggerThan(startDate))();
}

class CategoryBudgetLimits extends Table {
  late final id = integer().autoIncrement()();
  late final categoryId = integer().references(Categories, #id)();
  late final planningPeriodId = integer().references(BudgetPeriods, #id)();
  // Stored in cents to avoid floating-point rounding problems
  late final amount = integer()();
}

class FixedCostBudgetLimits extends Table {
  late final id = integer().autoIncrement()();
  late final categoryId = integer().references(FixedCosts, #id)();
  late final planningPeriodId = integer().references(BudgetPeriods, #id)();
  // Stored in cents to avoid floating-point rounding problems
  late final amount = integer()();
}

class Plans extends Table {
  late final id = integer().autoIncrement()();
  late final name = text().unique()();
  late final startDate = dateTime()();
  late final Column<DateTime> endDate = dateTime().check(endDate.isBiggerThan(startDate))();
}

class PlanEntries extends Table {
  late final id = integer().autoIncrement()();
  late final tripId = integer().references(Plans, #id, onDelete: KeyAction.cascade)();
  late final position = integer()();
  late final startDate = dateTime()();
  late final endDate = dateTime()();
  late final amount = integer()();

  // No two entries can have the same position in a trip
  @override
  List<Set<Column>> get uniqueKeys => [
    {tripId, position},
  ];
}

class PlanEntryColors extends Table {
  late final id = integer().autoIncrement()();
  late final entryId = integer().references(PlanEntries, #id, onDelete: KeyAction.cascade)();
  late final color = integer()();
}

class AccountBalances extends Table {
  late final id = integer().autoIncrement()();
  late final name = text()();
  // Amount in cents
  late final total = integer()();
  late final isExpenseAccount = boolean()();
}
