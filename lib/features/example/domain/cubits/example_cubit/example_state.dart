import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:extro/core/failures/failure.dart';
import 'package:extro/features/example/domain/entities/example_entity.dart';

part 'example_state.freezed.dart';

@freezed
sealed class ExampleState with _$ExampleState {
  const factory ExampleState.initial() = _Initial;
  const factory ExampleState.loading() = _Loading;
  const factory ExampleState.success(List<ExampleEntity> entities) = _Success;
  const factory ExampleState.failure(Failure failure) = _Failure;
}
