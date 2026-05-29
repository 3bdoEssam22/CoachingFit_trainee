import 'dart:io';
import 'package:coaching_fit_trainee/core/constants/api_constants.dart';
import 'package:coaching_fit_trainee/core/errors/dio_error_handler.dart';
import 'package:coaching_fit_trainee/core/errors/failures.dart';
import 'package:coaching_fit_trainee/core/network/dio_client.dart';
import 'package:coaching_fit_trainee/features/profile/data/models/trainee_profile_response.dart';
import 'package:coaching_fit_trainee/features/profile/domain/entities/trainee_profile.dart';
import 'package:dio/dio.dart';

abstract class ProfileRepository {
  Future<void> createProfile({
    required String gender,
    required DateTime dateOfBirth,
    required double weightKg,
    required double heightCm,
    required int fitnessLevel,
    required String goals,
    String? medicalNotes,
    File? photo,
  });
  Future<TraineeProfile> getMyProfile();
  Future<void> updateProfile({
    required double weightKg,
    required double heightCm,
    required int fitnessLevel,
    required String goals,
    String? medicalNotes,
    File? photo,
  });
}

class ProfileRepositoryImpl implements ProfileRepository {
  final DioClient _dioClient;
  ProfileRepositoryImpl(this._dioClient);

  TraineeProfile _toEntity(TraineeProfileResponse r) => TraineeProfile(
        id: r.id,
        userId: r.userId,
        gender: r.gender,
        dateOfBirth: r.dateOfBirth,
        weightKg: r.weightKg,
        heightCm: r.heightCm,
        fitnessLevel: r.fitnessLevel,
        goals: r.goals,
        medicalNotes: r.medicalNotes,
        profilePhotoUrl: r.profilePhotoUrl,
        createdAt: r.createdAt,
      );

  @override
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
    try {
      final formData = FormData.fromMap({
        'gender': gender,
        'dateOfBirth': dateOfBirth.toUtc().toIso8601String(),
        'weightKg': weightKg,
        'heightCm': heightCm,
        'fitnessLevel': fitnessLevel,
        'goals': goals,
        if (medicalNotes != null && medicalNotes.isNotEmpty) 'medicalNotes': medicalNotes,
        if (photo != null) 'photo': await MultipartFile.fromFile(photo.path),
      });
      await _dioClient.dio.post(ApiConstants.traineeProfile, data: formData);
    } on DioException catch (e) {
      throw ServerFailure(dioFailureMessage(e));
    }
  }

  @override
  Future<TraineeProfile> getMyProfile() async {
    try {
      final response = await _dioClient.dio.get(ApiConstants.getMyProfile);
      return _toEntity(TraineeProfileResponse.fromJson(response.data['data']));
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw const NotFoundFailure('Profile not found');
      }
      throw ServerFailure(dioFailureMessage(e));
    }
  }

  @override
  Future<void> updateProfile({
    required double weightKg,
    required double heightCm,
    required int fitnessLevel,
    required String goals,
    String? medicalNotes,
    File? photo,
  }) async {
    try {
      final formData = FormData.fromMap({
        'weightKg': weightKg,
        'heightCm': heightCm,
        'fitnessLevel': fitnessLevel,
        'goals': goals,
        // On update, send medicalNotes whenever the caller provides a non-null value
        // (including '') so an emptied field clears the stored note instead of being
        // silently dropped. Photo stays omit-to-keep-existing.
        if (medicalNotes != null) 'medicalNotes': medicalNotes,
        if (photo != null) 'photo': await MultipartFile.fromFile(photo.path),
      });
      await _dioClient.dio.put(ApiConstants.traineeProfile, data: formData);
    } on DioException catch (e) {
      throw ServerFailure(dioFailureMessage(e));
    }
  }
}
