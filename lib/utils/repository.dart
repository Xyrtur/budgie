import 'package:budgie/models/graph_totals.dart';
import 'package:budgie/models/transaction_models.dart';
import 'package:budgie/utils/datetime_ext.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

part 'repository.g.dart';
part 'tables.dart';

@DriftDatabase(
  tables: [
    Transactions,
    Categories,
    FixedCosts,
    BudgetPeriods,
    CategoryBudgetLimits,
    FixedCostBudgetLimits,
    Plans,
    PlanEntries,
    PlanEntryColors,
    AccountBalances,
  ],
)
class BudgieDatabase extends _$BudgieDatabase {
  BudgieDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'budgie_db',
      native: const DriftNativeOptions(databaseDirectory: getApplicationSupportDirectory),
    );
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
                  // 4 cases
                  // Period rests within year
                  period.startDate.isSmallerThanValue(nextYearStart) & period.endDate.isBiggerThanValue(yearStart) |
                  // Period encircles year
                  period.startDate.isSmallerThanValue(yearStart) & period.endDate.isBiggerThanValue(nextYearStart) |
                  // Period overlaps start of year
                  period.startDate.isSmallerThanValue(yearStart) & period.endDate.isBiggerThanValue(yearStart) |
                  // Period overlaps end of year
                  period.startDate.isSmallerThanValue(nextYearStart) & period.endDate.isBiggerThanValue(nextYearStart),
            ))
            .get();

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

        final categoryLimit =
            (await (select(categoryBudgetLimits)
                      ..where((row) => row.categoryId.equals(categoryId) & row.planningPeriodId.equals(periodID)))
                    .getSingle())
                .amount;

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

  // Edit transaction

  // Delete transaction

  // Provide List<Plan> for expense planning page

  // Add Expense plan

  // Edit Expense plan

  // Delete Expense plan

  // Add PlanEntry

  // Edit PlanEntry

  // Delete PlanEntry

  // Add / Edit Fixed Cost

  // Delete Fixed Cost

  //
}
