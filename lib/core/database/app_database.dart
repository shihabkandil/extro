import 'package:drift/drift.dart';

import 'tables/tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [WalletTable, TransactionTable, SpendingChartTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator migrator) async => await migrator.createAll(),
    onUpgrade: (Migrator m, int from, int to) async {
      // Handle future migrations here
    },
  );
}
