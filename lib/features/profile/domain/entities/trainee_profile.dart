class TraineeProfile {
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

  const TraineeProfile({
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
}
