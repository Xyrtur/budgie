class YearTotals {
  final int year;
  final Map<int, CategoryTotals> categoryTotals;
  int totalExpenses;
  YearTotals({required this.year, required this.categoryTotals, required this.totalExpenses});
}

class CategoryTotals {
  final String name;
  final int color;
  final List<int> monthTotals;
  CategoryTotals({required this.name, required this.color, required this.monthTotals});
}
