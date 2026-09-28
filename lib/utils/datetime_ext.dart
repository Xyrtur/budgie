extension DatePrecisionCompare on DateTime {
  bool isSameDate({required DateTime other}) {
    return year == other.year && month == other.month;
  }
}
