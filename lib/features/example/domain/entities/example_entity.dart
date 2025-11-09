import 'package:freezed_annotation/freezed_annotation.dart';

part 'example_entity.freezed.dart';

@freezed
sealed class ExampleEntity with _$ExampleEntity {
  const factory ExampleEntity({
    required int id,
    required String name,
    required String description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ExampleEntity;
}
