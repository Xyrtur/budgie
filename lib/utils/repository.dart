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

  // given years selected, provide List<YearTotals>

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
