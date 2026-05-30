import 'package:bloc_test/bloc_test.dart';
import 'package:coaching_fit_trainee/core/errors/failures.dart';
import 'package:coaching_fit_trainee/core/storage/secure_storage.dart';
import 'package:coaching_fit_trainee/features/auth/data/repositories/auth_repository.dart';
import 'package:coaching_fit_trainee/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:coaching_fit_trainee/features/auth/presentation/cubit/auth_state.dart';
import 'package:coaching_fit_trainee/features/profile/data/repositories/profile_repository.dart';
import 'package:coaching_fit_trainee/features/profile/domain/entities/trainee_profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepo extends Mock implements AuthRepository {}
class _MockProfileRepo extends Mock implements ProfileRepository {}
class _MockStorage extends Mock implements SecureStorage {}

void main() {
  late _MockAuthRepo auth;
  late _MockProfileRepo profile;
  late _MockStorage storage;

  setUp(() {
    auth = _MockAuthRepo();
    profile = _MockProfileRepo();
    storage = _MockStorage();
    when(() => storage.readToken()).thenAnswer((_) async => 'tok');
    when(() => storage.writeHasProfile(any())).thenAnswer((_) async {});
    when(() => storage.clearAll()).thenAnswer((_) async {});
  });

  blocTest<AuthCubit, AuthState>(
    'resolveSession routes to home when a profile exists',
    build: () {
      when(() => profile.getMyProfile()).thenAnswer((_) async => TraineeProfile(
            id: '1', userId: 'u', gender: 'Male', dateOfBirth: DateTime(2000),
            weightKg: 70, heightCm: 175, fitnessLevel: 1, goals: 'g', createdAt: DateTime.now(),
          ));
      return AuthCubit(auth, profile, storage);
    },
    act: (c) => c.resolveSession(),
    expect: () => [const AuthSuccess(AuthNextStep.home)],
  );

  blocTest<AuthCubit, AuthState>(
    'resolveSession routes to createProfile when no profile (404)',
    build: () {
      when(() => profile.getMyProfile())
          .thenThrow(const NotFoundFailure('Profile not found'));
      return AuthCubit(auth, profile, storage);
    },
    act: (c) => c.resolveSession(),
    expect: () => [const AuthSuccess(AuthNextStep.createProfile)],
  );

  blocTest<AuthCubit, AuthState>(
    'resolveSession does NOT log out on a transient error; routes home '
    'from cached hasProfile=true',
    build: () {
      when(() => profile.getMyProfile())
          .thenThrow(const ServerFailure('Cannot reach the server'));
      when(() => storage.readHasProfile()).thenAnswer((_) async => true);
      return AuthCubit(auth, profile, storage);
    },
    act: (c) => c.resolveSession(),
    expect: () => [const AuthSuccess(AuthNextStep.home)],
    verify: (_) {
      verifyNever(() => storage.clearAll()); // credentials preserved
    },
  );

  blocTest<AuthCubit, AuthState>(
    'resolveSession on a transient error routes to createProfile '
    'when cached hasProfile=false',
    build: () {
      when(() => profile.getMyProfile())
          .thenThrow(const ServerFailure('Cannot reach the server'));
      when(() => storage.readHasProfile()).thenAnswer((_) async => false);
      return AuthCubit(auth, profile, storage);
    },
    act: (c) => c.resolveSession(),
    expect: () => [const AuthSuccess(AuthNextStep.createProfile)],
    verify: (_) {
      verifyNever(() => storage.clearAll());
    },
  );
}
