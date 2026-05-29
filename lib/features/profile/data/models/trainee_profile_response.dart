import 'package:json_annotation/json_annotation.dart';
part 'trainee_profile_response.g.dart';

@JsonSerializable()
class TraineeProfileResponse {
  final String id;
  final String userId;
  final String gender;
  final DateTime dateOfBirth;
  final double weightKg;
  final double heightCm;
  final int fitnessLevel;
  final String goals;
  final String? medicalNotes;
  final String? profilePhotoUrl;
  final DateTime createdAt;

  TraineeProfileResponse({
    required this.id,
    required this.userId,
    required this.gender,
    required this.dateOfBirth,
    required this.weightKg,
    required this.heightCm,
    required this.fitnessLevel,
    required this.goals,
    this.medicalNotes,
    this.profilePhotoUrl,
    required this.createdAt,
  });

  factory TraineeProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$TraineeProfileResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TraineeProfileResponseToJson(this);
}
