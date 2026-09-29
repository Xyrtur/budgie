class YearTotals {
  final int year;
  final List<CategoryTotals> categoryTotals;

  YearTotals({required this.year, required this.categoryTotals});
}

class CategoryTotals {
  final String name;
  final int color;
  final List<int> monthTotals;
  CategoryTotals({required this.name, required this.color, required this.monthTotals});
}
