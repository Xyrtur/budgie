import 'package:budgie/utils/repository.dart';

class BudgetPeriodInfo {
  final List<FixedCostLimit> fixedCostLimits;
  final List<CategoryLimit> categoryLimitCosts;
  final BudgetPeriod info;
  BudgetPeriodInfo({required this.info, required this.fixedCostLimits, required this.categoryLimitCosts});
}

class FixedCostLimit {
  final String name;
  final int limit;
  FixedCostLimit({required this.name, required this.limit});
}

class CategoryLimit {
  final String name;
  final int limit;
  CategoryLimit({required this.name, required this.limit});
}
