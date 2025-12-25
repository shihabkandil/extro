import 'dart:ui';

import 'package:extro/core/di/locator.dart';
import 'package:extro/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/feature_flags/domain/cubits/feature_flag_cubit/feature_flag_cubit.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/domain/cubits/theme_cubit/theme_cubit.dart';
import 'features/auth/domain/cubits/auth_cubit/auth_cubit.dart';
import 'l10n/generated/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await locator.allReady();

  await locator<ThemeCubit>().init(
    PlatformDispatcher.instance.platformBrightness,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => FeatureFlagCubit()),
        BlocProvider(create: (context) => locator<ThemeCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          final themeMode = themeState.maybeWhen(
            loaded: (mode) => mode,
            orElse: () => ThemeMode.system,
          );
          return MaterialApp.router(
            title: 'Extro',
            routerConfig: locator<AppRouter>().config(),
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en')],
          );
        },
      ),
    );
  }
}
