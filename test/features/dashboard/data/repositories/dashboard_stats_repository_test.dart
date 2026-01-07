import 'package:dartz/dartz.dart';
import 'package:extro/core/failures/failure.dart';
import 'package:extro/features/dashboard/data/data_sources/i_dashboard_local_data_source.dart';
import 'package:extro/features/dashboard/data/repositories/dashboard_stats_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockIDashboardLocalDataSource extends Mock
    implements IDashboardLocalDataSource {}

void main() {
  group('DashboardStatsRepository', () {
    late MockIDashboardLocalDataSource mockDataSource;
    late DashboardStatsRepository repository;

    setUp(() {
      mockDataSource = MockIDashboardLocalDataSource();
      repository = DashboardStatsRepository(localDataSource: mockDataSource);
    });

    group('getDashboardStats', () {
      test('returns stats with income and expenses', () async {
        when(
          () => mockDataSource.getTotalIncome(),
        ).thenAnswer((_) async => 5550.0);
        when(
          () => mockDataSource.getTotalExpenses(),
        ).thenAnswer((_) async => 326.49);

        final result = await repository.getDashboardStats();

        expect(result.isRight(), isTrue);
        result.fold((failure) => fail('Should return Right'), (stats) {
          expect(stats.totalIncome, equals(5550.0));
          expect(stats.totalExpenses, equals(326.49));
        });
      });

      test('returns zero stats when no transactions exist', () async {
        when(
          () => mockDataSource.getTotalIncome(),
        ).thenAnswer((_) async => 0.0);
        when(
          () => mockDataSource.getTotalExpenses(),
        ).thenAnswer((_) async => 0.0);

        final result = await repository.getDashboardStats();

        expect(result.isRight(), isTrue);
        result.fold((failure) => fail('Should return Right'), (stats) {
          expect(stats.totalIncome, equals(0.0));
          expect(stats.totalExpenses, equals(0.0));
        });
      });

      test('returns cache failure when data source throws exception', () async {
        when(
          () => mockDataSource.getTotalIncome(),
        ).thenThrow(Exception('Database error'));

        final result = await repository.getDashboardStats();

        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure, equals(const Failure.cache())),
          (stats) => fail('Should return Left'),
        );
      });

      test('handles expenses calculation error', () async {
        when(
          () => mockDataSource.getTotalIncome(),
        ).thenAnswer((_) async => 1000.0);
        when(
          () => mockDataSource.getTotalExpenses(),
        ).thenThrow(Exception('Calculation error'));

        final result = await repository.getDashboardStats();

        expect(result.isLeft(), isTrue);
      });
    });
  });
}
