import 'package:budgie/utils/repository.dart';

class ExpensePlan {
  final String name;
  final DateTime startDate;
  final DateTime? endDate;
  final List<PlanEntry> planEntry;

  ExpensePlan({required this.name, required this.startDate, this.endDate, required this.planEntry});
}
