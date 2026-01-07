import 'package:extro/common/utils/transaction_type_icon.dart';
import 'package:extro/core/database/app_database.dart';
import 'package:extro/core/failures/failure.dart';
import 'package:extro/features/dashboard/data/data_sources/i_dashboard_local_data_source.dart';
import 'package:extro/features/dashboard/data/repositories/transaction_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockIDashboardLocalDataSource extends Mock
    implements IDashboardLocalDataSource {}

void main() {
  group('TransactionRepository', () {
    late MockIDashboardLocalDataSource mockDataSource;
    late TransactionRepository repository;

    setUp(() {
      mockDataSource = MockIDashboardLocalDataSource();
      repository = TransactionRepository(localDataSource: mockDataSource);
    });

    group('getRecentTransactions', () {
      test('returns list of transactions from data source', () async {
        final transactionTableData = [
          TransactionTableData(
            id: 1,
            title: 'Salary',
            transactionDateTime: DateTime(2025, 12, 20, 9),
            amount: 3500.0,
            isIncome: true,
            icon: TransactionTypeIcon.dollarSign.value,
            walletId: 1,
          ),
          TransactionTableData(
            id: 2,
            title: 'Grocery Shopping',
            transactionDateTime: DateTime(2025, 12, 24, 10, 30),
            amount: -85.50,
            isIncome: false,
            icon: TransactionTypeIcon.cart.value,
            walletId: 1,
          ),
        ];

        when(
          () => mockDataSource.getRecentTransactions(),
        ).thenAnswer((_) async => transactionTableData);

        final result = await repository.getRecentTransactions();

        expect(result.isRight(), isTrue);
        result.fold((failure) => fail('Should return Right'), (transactions) {
          expect(transactions.length, equals(2));
          expect(transactions[0].title, equals('Salary'));
          expect(transactions[0].isIncome, isTrue);
          expect(transactions[1].title, equals('Grocery Shopping'));
          expect(transactions[1].isIncome, isFalse);
        });
      });

      test('returns empty list when no transactions exist', () async {
        when(
          () => mockDataSource.getRecentTransactions(),
        ).thenAnswer((_) async => []);

        final result = await repository.getRecentTransactions();

        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Should return Right'),
          (transactions) => expect(transactions, isEmpty),
        );
      });

      test('returns cache failure when data source throws exception', () async {
        when(
          () => mockDataSource.getRecentTransactions(),
        ).thenThrow(Exception('Database error'));

        final result = await repository.getRecentTransactions();

        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure, equals(const Failure.cache())),
          (transactions) => fail('Should return Left'),
        );
      });

      test('preserves transaction date and time', () async {
        final dateTime = DateTime(2025, 12, 25, 14, 30);
        final transactionTableData = [
          TransactionTableData(
            id: 1,
            title: 'Test',
            transactionDateTime: dateTime,
            amount: 100.0,
            isIncome: true,
            icon: TransactionTypeIcon.dollarSign.value,
            walletId: 1,
          ),
        ];

        when(
          () => mockDataSource.getRecentTransactions(),
        ).thenAnswer((_) async => transactionTableData);

        final result = await repository.getRecentTransactions();

        result.fold((failure) => fail('Should return Right'), (transactions) {
          expect(transactions[0].dateTime, equals(dateTime));
        });
      });
    });
  });
}
