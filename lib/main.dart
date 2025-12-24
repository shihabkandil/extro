import 'package:extro/core/di/locator.dart';
import 'package:extro/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/feature_flags/domain/cubits/feature_flag_cubit/feature_flag_cubit.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/domain/cubits/auth_cubit/auth_cubit.dart';
import 'l10n/generated/app_localizations.dart';
import 'common/presentation/ui_utils/app_toast.dart';
import 'features/auth/presentation/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await locator.allReady();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => FeatureFlagCubit()),
      ],
      child: MaterialApp.router(
        title: 'Extro',
        routerConfig: locator<AppRouter>().config(),
        navigatorKey: AppToast.navigatorKey,
        theme: AppTheme.light,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
=======
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => FeatureFlagCubit()),
      ],
      child: MaterialApp(
        title: 'Extro',
        navigatorKey: AppToast.navigatorKey,
        theme: AppTheme.light,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        home: const LoginScreen(),
      ),
>>>>>>> develop
    );
  }
}
