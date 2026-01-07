import 'package:dartz/dartz.dart';
import 'package:extro/core/failures/failure.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/dashboard_stats.dart';
import '../../domain/repositories/i_dashboard_stats_repository.dart';
import '../data_sources/i_dashboard_local_data_source.dart';

@Singleton(as: IDashboardStatsRepository)
class DashboardStatsRepository implements IDashboardStatsRepository {
  final IDashboardLocalDataSource localDataSource;

  DashboardStatsRepository({required this.localDataSource});

  @override
  Future<Either<Failure, DashboardStats>> getDashboardStats() async {
    try {
      final income = await localDataSource.getTotalIncome();
      final expenses = await localDataSource.getTotalExpenses();
      
      final stats = DashboardStats(
        totalIncome: income,
        totalExpenses: expenses,
      );
      
      return Right(stats);
    } catch (e) {
      return const Left(Failure.cache());
    }
  }
}
