import 'package:dartz/dartz.dart';
import 'package:extro/core/database/app_database.dart';
import 'package:extro/core/failures/failure.dart';
import 'package:extro/features/dashboard/data/data_sources/i_dashboard_local_data_source.dart';
import 'package:extro/features/dashboard/data/repositories/wallet_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockIDashboardLocalDataSource extends Mock
    implements IDashboardLocalDataSource {}

void main() {
  group('WalletRepository', () {
    late MockIDashboardLocalDataSource mockDataSource;
    late WalletRepository repository;

    setUp(() {
      mockDataSource = MockIDashboardLocalDataSource();
      repository = WalletRepository(localDataSource: mockDataSource);
    });

    group('getAllWallets', () {
      test('returns list of wallets from data source', () async {
        final walletTableData = [
          const WalletTableData(
            id: 1,
            label: 'Main Wallet',
            balance: 15000.0,
            currency: 'USD',
            icon: '💳',
            accentColor: '#4A90E2',
          ),
          const WalletTableData(
            id: 2,
            label: 'Savings',
            balance: 8500.0,
            currency: 'USD',
            icon: '💰',
            accentColor: '#50C878',
          ),
        ];

        when(
          () => mockDataSource.getAllWallets(),
        ).thenAnswer((_) async => walletTableData);

        final result = await repository.getAllWallets();

        expect(result.isRight(), isTrue);
        result.fold((failure) => fail('Should return Right'), (wallets) {
          expect(wallets.length, equals(2));
          expect(wallets[0].label, equals('Main Wallet'));
          expect(wallets[0].balance, equals(15000.0));
          expect(wallets[1].label, equals('Savings'));
        });
      });

      test('returns empty list when no wallets exist', () async {
        when(() => mockDataSource.getAllWallets()).thenAnswer((_) async => []);

        final result = await repository.getAllWallets();

        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Should return Right'),
          (wallets) => expect(wallets, isEmpty),
        );
      });

      test('returns cache failure when data source throws exception', () async {
        when(
          () => mockDataSource.getAllWallets(),
        ).thenThrow(Exception('Database error'));

        final result = await repository.getAllWallets();

        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure, equals(const Failure.cache())),
          (wallets) => fail('Should return Left'),
        );
      });
    });
  });
}
