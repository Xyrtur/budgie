import 'package:budgie/utils/repository.dart';

class MonthTransactions {
  final int year;
  final int month;
  final List<CategoryTransactions> categories;
  final int totalExpenses;
  final int totalIncome;
  const MonthTransactions({
    required this.year,
    required this.month,
    required this.categories,
    required this.totalExpenses,
    required this.totalIncome,
  });
}

class CategoryTransactions {
  final Category category;
  final int total;
  final int limit;
  final bool isExpense;
  final List<Transaction> transactions;
  const CategoryTransactions({
    required this.category,
    required this.transactions,
    required this.total,
    required this.limit,
    required this.isExpense,
  });
}
