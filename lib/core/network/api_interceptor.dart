import 'dart:async';
import 'package:coaching_fit_trainee/core/constants/api_constants.dart';
import 'package:coaching_fit_trainee/core/storage/secure_storage.dart';
import 'package:coaching_fit_trainee/features/auth/data/models/auth_response.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class ApiInterceptor extends Interceptor {
  final SecureStorage _secureStorage;
  final GoRouter _router;
  final _uuid = const Uuid();

  late final Dio _rawDio = Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));
  Completer<String>? _refreshInFlight;

  // Only register + refresh are idempotent on the trainee backend.
  static const _idempotentPaths = {
    ApiConstants.registerTrainee,
    ApiConstants.refresh,
  };

  ApiInterceptor(this._secureStorage, this._router);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.extra['skipAuth'] != true) {
      final token = await _secureStorage.readToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    if (options.method.toUpperCase() == 'POST' &&
        _idempotentPaths.any((p) => options.path.endsWith(p))) {
      options.headers['Idempotency-Key'] = _uuid.v4();
    }
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401 ||
        err.requestOptions.extra['skipRefresh'] == true) {
      return super.onError(err, handler);
    }
    final storedRefreshToken = await _secureStorage.readRefreshToken();
    if (storedRefreshToken == null || storedRefreshToken.isEmpty) {
      await _clearAndRedirect();
      return super.onError(err, handler);
    }
    try {
      final newAccessToken = await _doRefresh(storedRefreshToken);
      if (err.requestOptions.data is FormData) {
        return super.onError(err, handler); // FormData single-use; let user retry
      }
      final retried = await _retry(err.requestOptions, newAccessToken);
      return handler.resolve(retried);
    } catch (_) {
      await _clearAndRedirect();
      return super.onError(err, handler);
    }
  }

  Future<String> _doRefresh(String storedRefreshToken) async {
    if (_refreshInFlight != null) return _refreshInFlight!.future;
    _refreshInFlight = Completer<String>();
    try {
      final response = await _rawDio.post(
        ApiConstants.refresh,
        data: {'refreshToken': storedRefreshToken},
        options: Options(headers: {'Idempotency-Key': _uuid.v4()}),
      );
      final authResponse = AuthResponse.fromJson(response.data['data']);
      await _secureStorage.writeToken(authResponse.token ?? '');
      if (authResponse.refreshToken != null && authResponse.refreshToken!.isNotEmpty) {
        await _secureStorage.writeRefreshToken(authResponse.refreshToken!);
      }
      _refreshInFlight!.complete(authResponse.token ?? '');
      return authResponse.token ?? '';
    } catch (e) {
      _refreshInFlight!.completeError(e);
      rethrow;
    } finally {
      _refreshInFlight = null;
    }
  }

  Future<Response> _retry(RequestOptions original, String newToken) {
    final isIdempotentPost = original.method.toUpperCase() == 'POST' &&
        _idempotentPaths.any((p) => original.path.endsWith(p));
    return _rawDio.request(
      original.path,
      data: original.data,
      queryParameters: original.queryParameters,
      options: Options(
        method: original.method,
        contentType: original.contentType,
        headers: {
          ...original.headers,
          'Authorization': 'Bearer $newToken',
          if (isIdempotentPost) 'Idempotency-Key': _uuid.v4(),
        },
      ),
    );
  }

  Future<void> _clearAndRedirect() async {
    await _secureStorage.clearAll();
    _router.go('/login');
  }
}
