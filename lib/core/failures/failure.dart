import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

@freezed
sealed class Failure with _$Failure {
  const factory Failure.network({String? message}) = _Network;
  const factory Failure.server({String? message}) = _Server;
  const factory Failure.dataProcessing({String? message}) = _DataProcessing;
  const factory Failure.authentication({String? message}) = _Authentication;
  const factory Failure.notFound({String? message}) = _NotFound;
  const factory Failure.cache({String? message}) = _Cache;
  const factory Failure.unknown({String? message}) = _Unknown;
}
