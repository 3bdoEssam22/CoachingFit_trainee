import 'package:coaching_fit_trainee/core/router/app_router.dart';
import 'package:coaching_fit_trainee/core/theme/app_theme.dart';
import 'package:coaching_fit_trainee/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:coaching_fit_trainee/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:coaching_fit_trainee/service_locator.dart' as di;
import 'package:coaching_fit_trainee/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AuthCubit>()),
        BlocProvider(create: (context) => sl<ProfileCubit>()),
      ],
      child: MaterialApp.router(
        title: 'CoachingFit Trainee',
        theme: AppTheme.darkTheme,
        routerConfig: sl<AppRouter>().router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
