import 'package:dartz/dartz.dart';
import '../entities/dashboard_stats.dart';
import 'package:extro/core/failures/failure.dart';

abstract class IDashboardStatsRepository {
  Future<Either<Failure, DashboardStats>> getDashboardStats();
}
