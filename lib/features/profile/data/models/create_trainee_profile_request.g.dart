// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_trainee_profile_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateTraineeProfileRequest _$CreateTraineeProfileRequestFromJson(
  Map<String, dynamic> json,
) => CreateTraineeProfileRequest(
  gender: json['gender'] as String,
  dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
  weightKg: (json['weightKg'] as num).toDouble(),
  heightCm: (json['heightCm'] as num).toDouble(),
  fitnessLevel: (json['fitnessLevel'] as num).toInt(),
  goals: json['goals'] as String,
  medicalNotes: json['medicalNotes'] as String?,
);

Map<String, dynamic> _$CreateTraineeProfileRequestToJson(
  CreateTraineeProfileRequest instance,
) => <String, dynamic>{
  'gender': instance.gender,
  'dateOfBirth': instance.dateOfBirth.toIso8601String(),
  'weightKg': instance.weightKg,
  'heightCm': instance.heightCm,
  'fitnessLevel': instance.fitnessLevel,
  'goals': instance.goals,
  'medicalNotes': instance.medicalNotes,
};
