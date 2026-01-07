import 'package:drift/drift.dart';

class WalletTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get label => text()();
  RealColumn get balance => real()();
  TextColumn get currency => text()();
  TextColumn get icon => text()();
  TextColumn get accentColor => text()();
}
