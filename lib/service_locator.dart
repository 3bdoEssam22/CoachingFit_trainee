import 'package:coaching_fit_trainee/core/network/api_interceptor.dart';
import 'package:coaching_fit_trainee/core/network/dio_client.dart';
import 'package:coaching_fit_trainee/core/router/app_router.dart';
import 'package:coaching_fit_trainee/core/storage/secure_storage.dart';
import 'package:coaching_fit_trainee/features/auth/data/repositories/auth_repository.dart';
import 'package:coaching_fit_trainee/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:coaching_fit_trainee/features/profile/data/repositories/profile_repository.dart';
import 'package:coaching_fit_trainee/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => SecureStorage(sl()));

  sl.registerLazySingleton(() => AppRouter(sl()));
  sl.registerLazySingleton<GoRouter>(() => sl<AppRouter>().router);

  sl.registerLazySingleton(() => ApiInterceptor(sl<SecureStorage>(), sl<GoRouter>()));
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => DioClient(sl<Dio>(), sl<ApiInterceptor>()));

  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(sl()));

  sl.registerFactory(() => AuthCubit(sl<AuthRepository>(), sl<ProfileRepository>(), sl<SecureStorage>()));
  sl.registerFactory(() => ProfileCubit(sl<ProfileRepository>(), sl<SecureStorage>()));
}
