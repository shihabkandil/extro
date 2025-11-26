import 'package:extro/core/feature_flags/cubit/feature_flag_cubit.dart';
import 'package:extro/core/feature_flags/feature_flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension FeatureFlagContext on BuildContext {
  bool isFeatureEnabled(FeatureFlag flag) {
    return read<FeatureFlagCubit>().isEnabled(flag);
  }
}
