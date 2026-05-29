import 'package:coaching_fit_trainee/core/constants/api_constants.dart';
import 'package:coaching_fit_trainee/core/errors/dio_error_handler.dart';
import 'package:coaching_fit_trainee/core/errors/failures.dart';
import 'package:coaching_fit_trainee/core/network/dio_client.dart';
import 'package:coaching_fit_trainee/features/auth/data/models/auth_response.dart';
import 'package:coaching_fit_trainee/features/auth/data/models/login_request.dart';
import 'package:coaching_fit_trainee/features/auth/data/models/register_trainee_request.dart';
import 'package:dio/dio.dart';

abstract class AuthRepository {
  Future<void> register(RegisterTraineeRequest request);
  Future<AuthResponse> login(LoginRequest request);
  Future<void> resendConfirmation(String email);
  Future<void> revoke(String refreshToken);
}

class AuthRepositoryImpl implements AuthRepository {
  final DioClient _dioClient;
  AuthRepositoryImpl(this._dioClient);

  @override
  Future<void> register(RegisterTraineeRequest request) async {
    try {
      await _dioClient.dio.post(ApiConstants.registerTrainee, data: request.toJson());
    } on DioException catch (e) {
      throw ServerFailure(dioFailureMessage(e));
    }
  }

  @override
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _dioClient.dio.post(ApiConstants.login, data: request.toJson());
      return AuthResponse.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw ServerFailure(dioFailureMessage(e));
    }
  }

  @override
  Future<void> resendConfirmation(String email) async {
    try {
      await _dioClient.dio.post(ApiConstants.resendConfirmation, queryParameters: {'email': email});
    } on DioException catch (e) {
      throw ServerFailure(dioFailureMessage(e));
    }
  }

  @override
  Future<void> revoke(String refreshToken) async {
    try {
      await _dioClient.dio.post(ApiConstants.revoke, data: {'refreshToken': refreshToken});
    } on DioException catch (e) {
      throw ServerFailure(dioFailureMessage(e));
    }
  }
}
