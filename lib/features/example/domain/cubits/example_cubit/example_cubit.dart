import 'package:extro/core/di/locator.dart';
import 'package:extro/features/example/domain/cubits/example_cubit/example_state.dart';
import 'package:extro/features/example/domain/repositories/i_example_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExampleCubit extends Cubit<ExampleState> {
  ExampleCubit({
    IExampleRepository? repository,
  })  : _repository = repository ?? locator<IExampleRepository>(),
        super(const ExampleState.initial());

  final IExampleRepository _repository;

  Future<void> loadAll() async {
    emit(const ExampleState.loading());

    final failureOrSuccess = await _repository.getAll();

    if (isClosed) return;

    failureOrSuccess.fold(
      (failure) => emit(ExampleState.failure(failure)),
      (entities) => emit(ExampleState.success(entities)),
    );
  }

  Future<void> loadById(int id) async {
    emit(const ExampleState.loading());

    final failureOrSuccess = await _repository.getById(id);

    if (isClosed) return;

    failureOrSuccess.fold(
      (failure) => emit(ExampleState.failure(failure)),
      (entity) => emit(ExampleState.success([entity])),
    );
  }
}
