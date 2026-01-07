import 'package:dartz/dartz.dart';
import 'package:extro/core/failures/failure.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/spending_chart.dart';
import '../../domain/repositories/i_spending_chart_repository.dart';
import '../data_sources/i_dashboard_local_data_source.dart';
import '../mappers/table_data_mappers.dart';

@Singleton(as: ISpendingChartRepository)
class SpendingChartRepository implements ISpendingChartRepository {
  final IDashboardLocalDataSource localDataSource;

  SpendingChartRepository({required this.localDataSource});

  @override
  Future<Either<Failure, SpendingChart>> getWeeklySpendingChart() async {
    try {
      final tableData = await localDataSource.getWeeklySpendingChart();
      if (tableData == null) {
        return const Right(SpendingChart(
          spendingData: [],
          totalAmount: '0.00',
          percentageChange: '0.0',
        ));
      }
      return Right(tableData.toDomain());
    } catch (e) {
      return const Left(Failure.cache());
    }
  }
}
