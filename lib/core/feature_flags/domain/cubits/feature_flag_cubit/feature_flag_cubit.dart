import 'package:extro/core/di/locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/services/i_feature_flag_service.dart';
import '../../feature_flag.dart';

part 'feature_flag_cubit.freezed.dart';
part 'feature_flag_state.dart';

class FeatureFlagCubit extends Cubit<FeatureFlagState> {
  final IFeatureFlagService _service;

  FeatureFlagCubit({IFeatureFlagService? service})
    : _service = service ?? locator<IFeatureFlagService>(),
      super(const FeatureFlagState(flags: {})) {
    _loadFlags();
  }

  void _loadFlags() {
    final flags = _service.getAllFlags();
    emit(FeatureFlagState(flags: flags));
  }

  bool isEnabled(FeatureFlag flag) {
    return state.flags[flag.name] ?? true;
  }

  Map<String, bool> getAllFlags() {
    return state.flags;
  }
}
