import 'dart:io';

import 'package:budgie/models/expense_plan_models.dart';
import 'package:budgie/models/graph_totals.dart';
import 'package:budgie/models/transaction_models.dart';
import 'package:budgie/utils/datetime_ext.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

part 'repository.g.dart';
part 'tables.dart';

@DriftDatabase(
  tables: [
    Transactions,
    Categories,
    FixedCosts,
    BudgetPeriods,
    CategoryBudgetLimits,
    Plans,
    PlanEntries,
    PlanEntryColors,
    AccountBalances,
    AppSettings,
  ],
)
class BudgieDatabase extends _$BudgieDatabase {
  BudgieDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'budgie',
      native: DriftNativeOptions(
        databasePath: () async {
          final dir = await getApplicationSupportDirectory();
          return '${dir.path}/budgie.db';
        },
      ),
    );
  }

  Future<void> initializeSettings() async {
    await into(appSettings).insert(const AppSettingsCompanion(id: Value(1)), mode: InsertMode.insertOrIgnore);
  }

  // Get all transactions within current year > sort according to month and their category
  // sort it all into one big List<MonthTransactions> for the spending overview bloc

  Future<List<MonthTransactions>> fetchTransactionsForYear(int year) async {
    DateTime yearStart = DateTime(year, 1, 1);
    DateTime nextYearStart = DateTime(year + 1, 1, 1);

    final query = select(transactions).join([innerJoin(categories, categories.id.equalsExp(transactions.categoryId))])
      ..where(transactions.date.isBiggerOrEqualValue(yearStart) & transactions.date.isSmallerThanValue(nextYearStart));

    final rows = await query.get();
    // Group transactions by year, month, and category.
    final grouped = <int, Map<int, List<Transaction>>>{};
    final categoryById = <int, Category>{};

    for (final row in rows) {
      final transaction = row.readTable(transactions);
      final category = row.readTable(categories);
      final monthKey = transaction.date.month;
      grouped.putIfAbsent(monthKey, () => {}).putIfAbsent(transaction.categoryId, () => []).add(transaction);
      categoryById[category.id] = category;
    }

    // Load all budget periods that overlap the requested year.
    final budgetPeriods =
        await (select(this.budgetPeriods)..where(
              (period) =>
                  period.startDate.isSmallerThanValue(nextYearStart) & period.endDate.isBiggerThanValue(yearStart),
            ))
            .get();

    // Load all category limits that coincide with loaded budget periods
    final limitRows = await (select(
      categoryBudgetLimits,
    )..where((row) => row.planningPeriodId.isIn(budgetPeriods.map((period) => period.id).toList()))).get();
    final categoryLimits = <(int, int), int>{
      for (final limit in limitRows) (limit.planningPeriodId, limit.categoryId): limit.amount,
    };

    final result = <MonthTransactions>[];
    for (var month = 1; month <= 12; month++) {
      final periodID = getBudgetPeriodIDForMonth(monthYear: DateTime(year, month), periodList: budgetPeriods);

      final transactionsByCategory = grouped[month];
      final categoryGroups = <CategoryTransactions>[];

      int totalExpenses = 0;
      int totalIncome = 0;
      for (MapEntry<int, List<Transaction>> entry in transactionsByCategory?.entries ?? []) {
        final categoryId = entry.key;
        final categoryTransactions = entry.value;
        final category = categoryById[categoryId]!;
        int total = 0;
        bool isExpense = categoryById[categoryId]!.isExpense;
        for (final transaction in categoryTransactions) {
          total += transaction.value;
          if (isExpense) {
            totalExpenses += transaction.value;
          } else {
            totalIncome += transaction.value;
          }
        }

        final categoryLimit = categoryLimits[(periodID, categoryId)] ?? 0;

        categoryGroups.add(
          CategoryTransactions(
            category: category,
            transactions: categoryTransactions,
            total: total,
            limit: categoryLimit,
            isExpense: isExpense,
          ),
        );
      }
      result.add(
        MonthTransactions(
          year: year,
          month: month,
          categories: List.unmodifiable(categoryGroups),
          totalExpenses: totalExpenses,
          totalIncome: totalIncome,
        ),
      );
    }
    return result;
  }

  int getBudgetPeriodIDForMonth({required DateTime monthYear, required List<BudgetPeriod> periodList}) {
    int? shortestPeriodIndex;
    for (int i = 0; i < periodList.length; i++) {
      if (monthYear.isWithinPeriod(period: periodList[i])) {
        if (shortestPeriodIndex == null) {
          shortestPeriodIndex = i;
        } else if (periodList[shortestPeriodIndex].endDate
                .difference(periodList[shortestPeriodIndex].startDate)
                .inDays >
            periodList[i].endDate.difference(periodList[i].startDate).inDays) {
          shortestPeriodIndex = i;
        }
      }
    }
    return periodList[shortestPeriodIndex!].id;
  }

  // Given years selected, provide List<YearTotals>
  Future<Map<int, YearTotals>> fetchTransactionsForGraphview({required List<int> yearsSelected}) async {
    // if (yearsSelected.isEmpty) return [];
    final result = <int, YearTotals>{};
    final total = transactions.value.sum();

    final rows =
        await (selectOnly(transactions).join([innerJoin(categories, categories.id.equalsExp(transactions.categoryId))])
              ..addColumns([transactions.date, categories.id, categories.name, categories.color, total])
              ..where(transactions.date.year.isIn(yearsSelected) & categories.isExpense.equals(true))
              ..groupBy([transactions.date, categories.id])
              ..orderBy([OrderingTerm.asc(transactions.date)]))
            .get();

    for (final row in rows) {
      final year = row.read(transactions.date.year)!;
      final month = row.read(transactions.date.month)!;
      final categoryId = row.read(categories.id)!;
      final categoryTotal = row.read(total)!;

      final yearTotals = result.putIfAbsent(year, () => YearTotals(year: year, categoryTotals: {}, totalExpenses: 0));

      final categoryTotals = yearTotals.categoryTotals.putIfAbsent(
        categoryId,
        () => CategoryTotals(
          name: row.read(categories.name)!,
          color: row.read(categories.color)!,
          monthTotals: List.filled(12, 0),
        ),
      );

      categoryTotals.monthTotals[month - 1] = categoryTotal;
      yearTotals.totalExpenses += categoryTotal;
    }
    return result;
  }

  // Add transaction
  Future<int> addTransaction(TransactionsCompanion txn) {
    return into(transactions).insert(txn);
  }

  // Edit transaction
  Future<bool> editTransaction(TransactionsCompanion txn) {
    return update(transactions).replace(txn);
  }

  // Delete transaction
  Future<int> deleteTransaction(Transaction txn) {
    return delete(transactions).delete(txn);
  }

  // Provide List<Plan> for expense planning page
  Future<List<Plan>> fetchAllPlans() {
    return (select(plans)).get();
  }

  // Provide ExpensePlan with all entries onSelect
  Future<ExpensePlan> fetchExpensePlan(int id) async {
    final selectedPlan = await (select(plans)..where((row) => row.id.equals(id))).getSingle();
    final rows =
        await (select(
                planEntries,
              ).join([leftOuterJoin(planEntryColors, planEntryColors.entryId.equalsExp(planEntries.id))])
              ..where(planEntries.planId.equals(id))
              ..orderBy([OrderingTerm(expression: planEntries.position)]))
            .get();

    final selectedEntries = <int, ExpensePlanEntry>{};
    for (final row in rows) {
      // Creates a row per color, so if an entry appears multiple times due to having multiple colors, putIfAbsent
      final entry = row.readTable(planEntries);
      final color = row.readTableOrNull(planEntryColors);
      final result = selectedEntries.putIfAbsent(entry.id, () => ExpensePlanEntry(entry: entry, colors: <int>[]));
      if (color != null) {
        result.colors.add(color.color);
      }
    }

    return ExpensePlan(
      planId: selectedPlan.id,
      name: selectedPlan.name,
      startDate: selectedPlan.startDate,
      endDate: selectedPlan.endDate,
      planEntries: selectedEntries.values.toList(),
    );
  }

  // Add Expense plan
  Future<int> addPlan(PlansCompanion plan) {
    return into(plans).insert(plan);
  }

  // Edit Expense plan
  Future<bool> editPlan(PlansCompanion plan) {
    return update(plans).replace(plan);
  }

  // Delete Expense plan
  Future<int> deletePlan(Plan plan) {
    return delete(plans).delete(plan);
  }

  // Add PlanEntry
  Future<int> addPlanEntry(PlanEntriesCompanion planEntry) {
    return into(planEntries).insert(planEntry);
  }

  // Edit PlanEntry
  Future<bool> editPlanEntry(PlanEntriesCompanion planEntry) {
    return update(planEntries).replace(planEntry);
  }

  // Reorder plan entries
  Future<void> reorderPlanEntries(List<PlanEntry> updatedList) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(planEntries, updatedList);
    });
  }

  // Delete PlanEntry
  Future<int> deletePlanEntry(PlanEntry planEntry) {
    return delete(planEntries).delete(planEntry);
  }

  // Fetch all budget periods
  Future<List<BudgetPeriod>> fetchAllBudgetPeriods() {
    return (select(budgetPeriods)).get();
  }

  // Add budget period
  Future<int> addBudgetPeriod(BudgetPeriodsCompanion budgetPeriod) {
    return into(budgetPeriods).insert(budgetPeriod);
  }

  // Edit budget period
  Future<bool> editBudgetPeriod(BudgetPeriodsCompanion budgetPeriod) {
    return update(budgetPeriods).replace(budgetPeriod);
  }

  // Delete budget period
  Future<int> deleteBudgetPeriod(BudgetPeriod budgetPeriod) {
    return delete(budgetPeriods).delete(budgetPeriod);
  }

  // Get list of fixed costs for selected period
  Future<List<FixedCost>> fetchFixedCostsForPeriod(int periodId) async {
    return await (select(fixedCosts)..where((row) => row.planningPeriodId.equals(periodId))).get();
  }

  // Add / Edit Fixed Cost
  Future<void> updateFixedCosts(List<FixedCost> updatedList) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(fixedCosts, updatedList);
    });
  }

  // Delete Fixed Cost
  Future<int> deleteFixedCost(FixedCost fixedCost) {
    return delete(fixedCosts).delete(fixedCost);
  }

  // Update category limits for selected period
  Future<void> updateCategoryLimits(List<CategoryBudgetLimit> updatedList) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(categoryBudgetLimits, updatedList);
    });
  }

  // Fetch list of categories
  Future<List<Category>> fetchCategories() {
    return (select(categories)).get();
  }

  // Add category
  Future<int> addCategory(CategoriesCompanion category) {
    return into(categories).insert(category);
  }

  // Edit category
  Future<bool> editCategory(CategoriesCompanion category) {
    return update(categories).replace(category);
  }

  // Reorder categories
  Future<void> reorderCategories(List<Category> updatedList) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(categories, updatedList);
    });
  }

  // Delete category
  Future<int> deleteCategory(CategoriesCompanion category) {
    return delete(categories).delete(category);
  }

  // Fetch list of account balances
  Future<List<AccountBalance>> fetchAccountBalances() {
    return (select(accountBalances)).get();
  }

  // Add account
  Future<int> addAccount(AccountBalancesCompanion account) {
    return into(accountBalances).insert(account);
  }

  // Edit account
  Future<bool> editAccount(AccountBalancesCompanion account) {
    return update(accountBalances).replace(account);
  }

  // Delete account
  Future<int> deleteAccount(AccountBalancesCompanion account) {
    return delete(accountBalances).delete(account);
  }

  // Reorder accounts
  Future<void> reorderAccounts(List<AccountBalance> updatedList) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(accountBalances, updatedList);
    });
  }

  // Toggle show savings
  Future<void> toggleShowSavings(bool toggle) {
    return (update(
      appSettings,
    )..where((t) => t.id.equals(1))).write(AppSettingsCompanion(showSavingsToggled: Value(toggle)));
  }

  // Toggle warm mode
  Future<void> toggleWarmMode(bool toggle) {
    return (update(
      appSettings,
    )..where((t) => t.id.equals(1))).write(AppSettingsCompanion(warmModeToggled: Value(toggle)));
  }

  // Toggle include fixed costs
  Future<void> includeFixedCosts(bool toggle) {
    return (update(
      appSettings,
    )..where((t) => t.id.equals(1))).write(AppSettingsCompanion(includeFixedCosts: Value(toggle)));
  }

  // Import data
  Future<BudgieDatabase> importData() async {
    List<PlatformFile> result = await FilePicker.pickFiles(
      dialogTitle: "Choose backup file to restore",
      type: FileType.custom,
      allowedExtensions: ['db'],
    );
    BudgieDatabase db = this;

    if (result.isNotEmpty) {
      final dir = await getApplicationSupportDirectory();
      final dbPath = '${dir.path}/budgie.db';
      final liveFile = File(dbPath);
      final tempFile = File('${liveFile.path}.importing');
      final replacementFile = File(result.single.path!);
      try {
        // Copy the selected replacement into a temp file. If copy fails, keeps existing database
        await replacementFile.copy(tempFile.path);

        // Close the db
        await close();

        // Delete the current database
        if (await liveFile.exists()) {
          await liveFile.delete();
        }
        // Move the selected file over to where the current db was
        await tempFile.rename(liveFile.path);

        db = BudgieDatabase();
      } catch (_) {
        if (await tempFile.exists()) {
          await tempFile.delete();
        }
        // Reopen the existing database if replacement failed.
        db = BudgieDatabase();
        rethrow;
      }
    }
    return db;
  }

  // Export data
  Future<void> exportData() async {
    final temp = await getTemporaryDirectory();
    final tempFile = File('${temp.path}/budgie_backup.db');
    try {
      // VACUUM INTO creates a consistent SQLite backup at this path.
      await customStatement('VACUUM INTO ?', [tempFile.path]);

      await SharePlus.instance.share(ShareParams(subject: 'Budgie backup file', files: [XFile(tempFile.path)]));
    } finally {
      if (await tempFile.exists()) {
        await tempFile.delete();
      }
    }
  }
}
