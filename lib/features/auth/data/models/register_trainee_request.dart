import 'package:json_annotation/json_annotation.dart';
part 'register_trainee_request.g.dart';

@JsonSerializable()
class RegisterTraineeRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String confirmPassword;
  RegisterTraineeRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
  Map<String, dynamic> toJson() => _$RegisterTraineeRequestToJson(this);
}
