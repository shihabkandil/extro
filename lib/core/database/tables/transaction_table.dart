import 'package:drift/drift.dart';

@DataClassName('TransactionTableData')
class TransactionTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  DateTimeColumn get transactionDateTime => dateTime()();
  RealColumn get amount => real()();
  BoolColumn get isIncome => boolean()();
  TextColumn get icon => text()();
  IntColumn get walletId => integer()();
}
