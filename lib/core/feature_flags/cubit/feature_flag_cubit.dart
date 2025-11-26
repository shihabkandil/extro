import 'package:extro/core/di/locator.dart';
import 'package:extro/core/feature_flags/cubit/feature_flag_state.dart';
import 'package:extro/core/feature_flags/feature_flag.dart';
import 'package:extro/core/feature_flags/i_feature_flag_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeatureFlagCubit extends Cubit<FeatureFlagState> {
  final IFeatureFlagService _service;

  FeatureFlagCubit({
    IFeatureFlagService? service,
  })  : _service = service ?? locator<IFeatureFlagService>(),
        super(FeatureFlagState(flags: {})) {
    _loadFlags();
  }

  void _loadFlags() {
    final flags = _service.getAllFlags();
    emit(FeatureFlagState(flags: flags));
  }

  bool isEnabled(FeatureFlag flag) {
    return _service.isEnabled(flag);
  }

  void enable(FeatureFlag flag) {
    _service.enable(flag);
    _loadFlags();
  }

  void disable(FeatureFlag flag) {
    _service.disable(flag);
    _loadFlags();
  }

  void updateFlags(Map<String, bool> flags) {
    _service.updateFlags(flags);
    _loadFlags();
  }

  Map<String, bool> getAllFlags() {
    return state.flags;
  }
}
