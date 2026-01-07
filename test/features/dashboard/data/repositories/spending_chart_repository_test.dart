import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:extro/core/database/app_database.dart';
import 'package:extro/core/failures/failure.dart';
import 'package:extro/features/dashboard/data/data_sources/i_dashboard_local_data_source.dart';
import 'package:extro/features/dashboard/data/repositories/spending_chart_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockIDashboardLocalDataSource extends Mock
    implements IDashboardLocalDataSource {}

void main() {
  group('SpendingChartRepository', () {
    late MockIDashboardLocalDataSource mockDataSource;
    late SpendingChartRepository repository;

    setUp(() {
      mockDataSource = MockIDashboardLocalDataSource();
      repository = SpendingChartRepository(localDataSource: mockDataSource);
    });

    group('getWeeklySpendingChart', () {
      test('returns spending chart from data source', () async {
        final spendingData = [120.0, 85.0, 150.0, 95.0, 200.0, 175.0, 110.0];
        final chartTableData = SpendingChartTableData(
          id: 1,
          spendingData: jsonEncode(spendingData),
          totalAmount: '935.00',
          percentageChange: '+12.5',
        );

        when(
          () => mockDataSource.getWeeklySpendingChart(),
        ).thenAnswer((_) async => chartTableData);

        final result = await repository.getWeeklySpendingChart();

        expect(result.isRight(), isTrue);
        result.fold((failure) => fail('Should return Right'), (chart) {
          expect(chart.spendingData, equals(spendingData));
          expect(chart.totalAmount, equals('935.00'));
          expect(chart.percentageChange, equals('+12.5'));
        });
      });

      test('returns default chart when data source returns null', () async {
        when(
          () => mockDataSource.getWeeklySpendingChart(),
        ).thenAnswer((_) async => null);

        final result = await repository.getWeeklySpendingChart();

        expect(result.isRight(), isTrue);
        result.fold((failure) => fail('Should return Right'), (chart) {
          expect(chart.spendingData, isEmpty);
          expect(chart.totalAmount, equals('0.00'));
          expect(chart.percentageChange, equals('0.0'));
        });
      });

      test('returns cache failure when data source throws exception', () async {
        when(
          () => mockDataSource.getWeeklySpendingChart(),
        ).thenThrow(Exception('Database error'));

        final result = await repository.getWeeklySpendingChart();

        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure, equals(const Failure.cache())),
          (chart) => fail('Should return Left'),
        );
      });

      test('handles empty spending data', () async {
        final chartTableData = SpendingChartTableData(
          id: 1,
          spendingData: jsonEncode([]),
          totalAmount: '0.00',
          percentageChange: '0.0',
        );

        when(
          () => mockDataSource.getWeeklySpendingChart(),
        ).thenAnswer((_) async => chartTableData);

        final result = await repository.getWeeklySpendingChart();

        result.fold((failure) => fail('Should return Right'), (chart) {
          expect(chart.spendingData, isEmpty);
        });
      });
    });
  });
}
