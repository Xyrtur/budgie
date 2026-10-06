import 'package:budgie/utils/repository.dart';

class ExpensePlan {
  final int planId;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final List<ExpensePlanEntry> planEntries;

  ExpensePlan({
    required this.planId,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.planEntries,
  });
}

class ExpensePlanEntry {
  final PlanEntry entry;
  final List<int> colors;

  ExpensePlanEntry({required this.entry, required this.colors});
}
