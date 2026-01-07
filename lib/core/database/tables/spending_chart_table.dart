import 'package:drift/drift.dart';

class SpendingChartTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get spendingData => text()();
  TextColumn get totalAmount => text()();
  TextColumn get percentageChange => text()();
}
