import 'package:dartz/dartz.dart';
import '../../domain/entities/spending_chart.dart';
import '../../domain/repositories/i_spending_chart_repository.dart';
import '../data_sources/i_dashboard_local_data_source.dart';
import 'package:extro/core/failures/failure.dart';

class SpendingChartRepository implements ISpendingChartRepository {
  final IDashboardLocalDataSource localDataSource;

  SpendingChartRepository({required this.localDataSource});

  @override
  Future<Either<Failure, SpendingChart>> getWeeklySpendingChart() async {
    try {
      final response = await localDataSource.getWeeklySpendingChart();
      final chart = SpendingChart(
        spendingData: response.spendingData,
        totalAmount: response.totalAmount,
        percentageChange: response.percentageChange,
      );
      return Right(chart);
    } catch (e) {
      return Left(Failure.dataProcessing());
    }
  }
}
