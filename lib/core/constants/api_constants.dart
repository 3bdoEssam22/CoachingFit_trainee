class ApiConstants {
  static const String baseUrl = "http://192.168.1.26:5000"; // set to your gateway LAN IP

  // Auth
  static const String registerTrainee = "/api/Auth/register/trainee";
  static const String login = "/api/Auth/login";
  static const String refresh = "/api/Auth/refresh";
  static const String revoke = "/api/Auth/revoke";
  static const String confirmEmail = "/api/Auth/confirm-email";
  static const String resendConfirmation = "/api/Auth/resend-confirmation";

  // Trainee Profile
  static const String traineeProfile = "/api/TraineeProfile";
  static const String getMyProfile = "/api/TraineeProfile/me";
}
