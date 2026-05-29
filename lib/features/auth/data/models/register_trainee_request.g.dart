// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_trainee_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterTraineeRequest _$RegisterTraineeRequestFromJson(
  Map<String, dynamic> json,
) => RegisterTraineeRequest(
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  email: json['email'] as String,
  password: json['password'] as String,
  confirmPassword: json['confirmPassword'] as String,
);

Map<String, dynamic> _$RegisterTraineeRequestToJson(
  RegisterTraineeRequest instance,
) => <String, dynamic>{
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'email': instance.email,
  'password': instance.password,
  'confirmPassword': instance.confirmPassword,
};
