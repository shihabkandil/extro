import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:extro/common/presentation/ui_utils/app_toast.dart';
import 'package:extro/core/extensions/context_extensions.dart';
import 'package:extro/core/failures/display_error.dart';
import 'package:extro/features/example/domain/cubits/example_cubit/example_cubit.dart';
import 'package:extro/features/example/domain/cubits/example_cubit/example_state.dart';

class ExampleScreen extends StatelessWidget {
  const ExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExampleCubit()..loadAll(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.localizer.appTitle),
        ),
        body: BlocConsumer<ExampleCubit, ExampleState>(
          listener: (context, state) {
            state.whenOrNull(
              failure: (failure) {
                AppToast.showError(
                  DisplayError.fromFailure(context.localizer, failure),
                );
              },
            );
          },
          builder: (context, state) {
            return state.when(
              initial: () => const Center(
                child: Text('Initial state'),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              success: (entities) {
                if (entities.isEmpty) {
                  return const Center(
                    child: Text('No data available'),
                  );
                }
                return ListView.builder(
                  itemCount: entities.length,
                  itemBuilder: (context, index) {
                    final entity = entities[index];
                    return ListTile(
                      title: Text(entity.name),
                      subtitle: Text(entity.description),
                    );
                  },
                );
              },
              failure: (_) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48),
                    const SizedBox(height: 16),
                    Text(context.localizer.unknownError),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
