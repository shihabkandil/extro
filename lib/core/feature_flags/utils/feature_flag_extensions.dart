import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/cubits/feature_flag_cubit/feature_flag_cubit.dart';
import '../domain/feature_flag.dart';

extension FeatureFlagContext on BuildContext {
  bool isFeatureEnabled(FeatureFlag flag) {
    return read<FeatureFlagCubit>().isEnabled(flag);
  }
}
