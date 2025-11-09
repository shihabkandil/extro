import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:extro/core/utils/date_time_converter.dart';
import 'package:extro/features/example/domain/entities/example_entity.dart';

part 'example_response.freezed.dart';
part 'example_response.g.dart';

@freezed
sealed class ExampleResponse with _$ExampleResponse {
  const factory ExampleResponse({
    required int id,
    required String name,
    required String description,
    @Default('') String createdAt,
    @Default('') String updatedAt,
  }) = _ExampleResponse;

  factory ExampleResponse.fromJson(Map<String, dynamic> json) =>
      _$ExampleResponseFromJson(json);
}

extension ExampleResponseMapper on ExampleResponse {
  ExampleEntity toDomain() {
    return ExampleEntity(
      id: id,
      name: name,
      description: description,
      createdAt: DateTimeConverter.fromJson(createdAt),
      updatedAt: DateTimeConverter.fromJson(updatedAt),
    );
  }
}
