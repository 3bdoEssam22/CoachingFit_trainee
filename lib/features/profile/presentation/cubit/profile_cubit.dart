import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:coaching_fit_trainee/core/errors/failures.dart';
import 'package:coaching_fit_trainee/core/storage/secure_storage.dart';
import 'package:coaching_fit_trainee/features/profile/data/repositories/profile_repository.dart';
import 'package:coaching_fit_trainee/features/profile/presentation/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _profileRepository;
  final SecureStorage _secureStorage;

  ProfileCubit(this._profileRepository, this._secureStorage) : super(ProfileInitial());

  Future<void> createProfile({
    required String gender,
    required DateTime dateOfBirth,
    required double weightKg,
    required double heightCm,
    required int fitnessLevel,
    required String goals,
    String? medicalNotes,
    File? photo,
  }) async {
    emit(ProfileLoading());
    try {
      await _profileRepository.createProfile(
        gender: gender,
        dateOfBirth: dateOfBirth,
        weightKg: weightKg,
        heightCm: heightCm,
        fitnessLevel: fitnessLevel,
        goals: goals,
        medicalNotes: medicalNotes,
        photo: photo,
      );
      await _secureStorage.writeHasProfile(true);
      emit(ProfileCreated());
    } catch (e) {
      emit(ProfileFailure((e as Failure).message));
    }
  }

  Future<void> getMyProfile() async {
    emit(ProfileLoading());
    try {
      final profile = await _profileRepository.getMyProfile();
      final fullName = await _secureStorage.readFullName() ?? 'Trainee';
      emit(ProfileSuccess(profile, fullName: fullName));
    } catch (e) {
      emit(ProfileFailure((e as Failure).message));
    }
  }

  Future<void> updateProfile({
    required double weightKg,
    required double heightCm,
    required int fitnessLevel,
    required String goals,
    String? medicalNotes,
    File? photo,
  }) async {
    emit(ProfileLoading());
    try {
      await _profileRepository.updateProfile(
        weightKg: weightKg,
        heightCm: heightCm,
        fitnessLevel: fitnessLevel,
        goals: goals,
        medicalNotes: medicalNotes,
        photo: photo,
      );
      emit(ProfileUpdated());
    } catch (e) {
      emit(ProfileFailure((e as Failure).message));
    }
  }
}
