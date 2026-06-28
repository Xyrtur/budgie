part of 'repository.dart';

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 6, max: 32)();
  RealColumn get value => real()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isExpense => boolean()();
}
