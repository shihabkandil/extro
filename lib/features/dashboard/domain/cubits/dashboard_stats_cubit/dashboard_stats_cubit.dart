import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/di/locator.dart';
import '../../../../../core/failures/failure.dart';
import '../../entities/dashboard_stats.dart';
import '../../repositories/i_dashboard_stats_repository.dart';

part 'dashboard_stats_cubit.freezed.dart';
part 'dashboard_stats_state.dart';

class DashboardStatsCubit extends Cubit<DashboardStatsState> {
  DashboardStatsCubit({IDashboardStatsRepository? repository})
    : _repository = repository ?? locator<IDashboardStatsRepository>(),
      super(const DashboardStatsState.initial());

  final IDashboardStatsRepository _repository;

  Future<void> fetchDashboardStats() async {
    emit(const DashboardStatsState.loading());
    final result = await _repository.getDashboardStats();
    if (isClosed) return;
    result.fold(
      (failure) => emit(DashboardStatsState.failure(failure)),
      (stats) => emit(DashboardStatsState.success(stats)),
    );
  }
}
