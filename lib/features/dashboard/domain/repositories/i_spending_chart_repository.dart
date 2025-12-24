import 'package:dartz/dartz.dart';
import '../entities/spending_chart.dart';
import 'package:extro/core/failures/failure.dart';

abstract class ISpendingChartRepository {
  Future<Either<Failure, SpendingChart>> getWeeklySpendingChart();
}
