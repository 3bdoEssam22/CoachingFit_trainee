// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trainee_profile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TraineeProfileResponse _$TraineeProfileResponseFromJson(
  Map<String, dynamic> json,
) => TraineeProfileResponse(
  id: json['id'] as String,
  userId: json['userId'] as String,
  gender: json['gender'] as String,
  dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
  weightKg: (json['weightKg'] as num).toDouble(),
  heightCm: (json['heightCm'] as num).toDouble(),
  fitnessLevel: (json['fitnessLevel'] as num).toInt(),
  goals: json['goals'] as String,
  medicalNotes: json['medicalNotes'] as String?,
  profilePhotoUrl: json['profilePhotoUrl'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$TraineeProfileResponseToJson(
  TraineeProfileResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'gender': instance.gender,
  'dateOfBirth': instance.dateOfBirth.toIso8601String(),
  'weightKg': instance.weightKg,
  'heightCm': instance.heightCm,
  'fitnessLevel': instance.fitnessLevel,
  'goals': instance.goals,
  'medicalNotes': instance.medicalNotes,
  'profilePhotoUrl': instance.profilePhotoUrl,
  'createdAt': instance.createdAt.toIso8601String(),
};
