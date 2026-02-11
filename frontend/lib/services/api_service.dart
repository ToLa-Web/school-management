import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_config.dart';
import 'api_models.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();

  late Dio _dio;
  late FlutterSecureStorage _secureStorage;

  String? _accessToken;
  String? _refreshToken;

  factory ApiService() {
    return _instance;
  }

  ApiService._internal() {
    _secureStorage = const FlutterSecureStorage();
    _initializeDio();
  }

  void _initializeDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (_accessToken != null) {
            options.headers['Authorization'] = 'Bearer $_accessToken';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401 && _refreshToken != null) {
            try {
              final refreshed = await _refreshAccessToken();
              if (refreshed) {
                final options = error.requestOptions;
                options.headers['Authorization'] = 'Bearer $_accessToken';
                return handler.resolve(await _dio.request(
                  options.path,
                  options: Options(
                    method: options.method,
                    headers: options.headers,
                    responseType: options.responseType,
                    contentType: options.contentType,
                  ),
                  data: options.data,
                  queryParameters: options.queryParameters,
                ));
              }
            } catch (e) {
              await logout();
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  // ================================================
  // Token Management
  // ================================================

  Future<void> loadTokens() async {
    try {
      _accessToken = await _secureStorage.read(key: 'access_token');
      _refreshToken = await _secureStorage.read(key: 'refresh_token');
    } catch (e) {
      print('Error loading tokens: $e');
    }
  }

  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    await Future.wait([
      _secureStorage.write(key: 'access_token', value: accessToken),
      _secureStorage.write(key: 'refresh_token', value: refreshToken),
    ]);
  }

  bool isAuthenticated() => _accessToken != null && _accessToken!.isNotEmpty;

  // ================================================
  // Auth Endpoints
  // ================================================

  /// POST /api/auth/register
  /// Backend returns UserResponseDto (no tokens).
  /// Backend also auto-sends email verification code.
  Future<UserResponseDto?> register(UserCreateDto userDto) async {
    try {
      final response = await _dio.post(
        ApiConfig.registerEndpoint,
        data: userDto.toJson(),
      );

      if (response.statusCode == 200 && response.data != null) {
        return UserResponseDto.fromJson(response.data as Map<String, dynamic>);
      }
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data is Map) {
        final msg = e.response?.data['message'] ?? 'Registration failed';
        throw Exception(msg);
      }
      rethrow;
    }
    return null;
  }

  /// POST /api/auth/authenticate
  /// Backend returns AuthResponseDto with {token, refreshToken, ...}.
  Future<AuthResponseDto?> login(LoginRequestDto loginDto) async {
    try {
      final response = await _dio.post(
        ApiConfig.loginEndpoint,
        data: loginDto.toJson(),
      );

      if (response.statusCode == 200 && response.data != null) {
        final authResponse = AuthResponseDto.fromJson(
          response.data as Map<String, dynamic>,
        );
        // Backend uses "token" field for access token
        await _saveTokens(authResponse.token, authResponse.refreshToken);
        return authResponse;
      }
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data is Map) {
        final msg = e.response?.data['message'] ?? 'Login failed';
        throw Exception(msg);
      }
      rethrow;
    }
    return null;
  }

  /// POST /api/auth/refresh
  Future<bool> _refreshAccessToken() async {
    if (_refreshToken == null) return false;

    try {
      final response = await _dio.post(
        ApiConfig.refreshTokenEndpoint,
        data: RefreshTokenRequestDto(refreshToken: _refreshToken!).toJson(),
      );

      if (response.statusCode == 200 && response.data != null) {
        final authResponse = AuthResponseDto.fromJson(
          response.data as Map<String, dynamic>,
        );
        await _saveTokens(authResponse.token, authResponse.refreshToken);
        return true;
      }
    } catch (e) {
      print('Token refresh error: $e');
    }
    return false;
  }

  /// POST /api/auth/logout
  Future<void> logout() async {
    try {
      if (_refreshToken != null) {
        await _dio.post(
          ApiConfig.logoutEndpoint,
          data: LogoutRequestDto(refreshToken: _refreshToken!).toJson(),
        );
      }
    } catch (e) {
      print('Logout error: $e');
    } finally {
      _accessToken = null;
      _refreshToken = null;
      await Future.wait([
        _secureStorage.delete(key: 'access_token'),
        _secureStorage.delete(key: 'refresh_token'),
      ]);
    }
  }

  /// POST /api/auth/request-email-verification-code
  Future<bool> requestEmailVerificationCode(String email) async {
    try {
      final response = await _dio.post(
        ApiConfig.requestEmailVerificationEndpoint,
        data: RequestEmailVerificationCodeRequestDto(email: email).toJson(),
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      print('Request verification code error: ${e.message}');
    }
    return false;
  }

  /// POST /api/auth/verify-email
  Future<bool> verifyEmail(String email, String code) async {
    try {
      final response = await _dio.post(
        ApiConfig.verifyEmailEndpoint,
        data: VerifyEmailRequestDto(email: email, code: code).toJson(),
      );
      return response.statusCode == 200 && response.data == true;
    } on DioException catch (e) {
      print('Verify email error: ${e.message}');
    }
    return false;
  }

  /// POST /api/auth/request-password-reset
  Future<bool> requestPasswordReset(String email) async {
    try {
      final response = await _dio.post(
        ApiConfig.requestPasswordResetEndpoint,
        data: RequestPasswordResetRequestDto(email: email).toJson(),
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      print('Request password reset error: ${e.message}');
    }
    return false;
  }

  /// POST /api/auth/reset-password
  Future<bool> resetPassword(String email, String code, String newPassword) async {
    try {
      final response = await _dio.post(
        ApiConfig.resetPasswordEndpoint,
        data: ResetPasswordRequestDto(
          email: email,
          code: code,
          newPassword: newPassword,
        ).toJson(),
      );
      return response.statusCode == 200 && response.data == true;
    } on DioException catch (e) {
      print('Reset password error: ${e.message}');
    }
    return false;
  }

  /// POST /api/auth/oauth/google
  Future<AuthResponseDto?> authenticateWithGoogle(String idToken) async {
    try {
      final response = await _dio.post(
        ApiConfig.googleAuthEndpoint,
        data: GoogleAuthRequestDto(idToken: idToken).toJson(),
      );

      if (response.statusCode == 200 && response.data != null) {
        final authResponse = AuthResponseDto.fromJson(
          response.data as Map<String, dynamic>,
        );
        await _saveTokens(authResponse.token, authResponse.refreshToken);
        return authResponse;
      }
    } on DioException catch (e) {
      print('Google auth error: ${e.message}');
    }
    return null;
  }

  /// POST /api/auth/oauth/facebook
  Future<AuthResponseDto?> authenticateWithFacebook(String accessToken) async {
    try {
      final response = await _dio.post(
        ApiConfig.facebookAuthEndpoint,
        data: FacebookAuthRequestDto(accessToken: accessToken).toJson(),
      );

      if (response.statusCode == 200 && response.data != null) {
        final authResponse = AuthResponseDto.fromJson(
          response.data as Map<String, dynamic>,
        );
        await _saveTokens(authResponse.token, authResponse.refreshToken);
        return authResponse;
      }
    } on DioException catch (e) {
      print('Facebook auth error: ${e.message}');
    }
    return null;
  }
}
