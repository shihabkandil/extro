import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../../core/di/locator.dart';
import '../../../../../core/failures/failure.dart';
import '../../entities/spending_chart.dart';
import '../../repositories/i_spending_chart_repository.dart';

part 'spending_chart_state.dart';
part 'spending_chart_cubit.freezed.dart';

class SpendingChartCubit extends Cubit<SpendingChartState> {
  SpendingChartCubit({ISpendingChartRepository? repository})
    : _repository = repository ?? locator<ISpendingChartRepository>(),
      super(const SpendingChartState.initial());

  final ISpendingChartRepository _repository;

  Future<void> fetchWeeklySpendingChart() async {
    emit(const SpendingChartState.loading());
    final result = await _repository.getWeeklySpendingChart();
    if (isClosed) return;
    result.fold(
      (failure) => emit(SpendingChartState.failure(failure)),
      (chart) => emit(SpendingChartState.success(chart)),
    );
  }
}
