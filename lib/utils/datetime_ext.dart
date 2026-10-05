import 'package:budgie/utils/repository.dart';

extension DatePrecisionCompare on DateTime {
  bool isSameDate({required DateTime other}) {
    return year == other.year && month == other.month;
  }

  bool isWithinPeriod({required BudgetPeriod period}) {
    return (isSameDate(other: period.startDate) || isAfter(period.startDate)) && isBefore(period.endDate);
  }
}
