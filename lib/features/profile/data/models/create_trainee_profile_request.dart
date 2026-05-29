import 'package:json_annotation/json_annotation.dart';
part 'create_trainee_profile_request.g.dart';

@JsonSerializable()
class CreateTraineeProfileRequest {
  final String gender;
  final DateTime dateOfBirth;
  final double weightKg;
  final double heightCm;
  final int fitnessLevel;
  final String goals;
  final String? medicalNotes;

  CreateTraineeProfileRequest({
    required this.gender,
    required this.dateOfBirth,
    required this.weightKg,
    required this.heightCm,
    required this.fitnessLevel,
    required this.goals,
    this.medicalNotes,
  });

  Map<String, dynamic> toJson() => _$CreateTraineeProfileRequestToJson(this);
}
