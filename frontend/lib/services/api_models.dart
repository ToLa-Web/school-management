// ================================================
// REQUEST DTOs - Match backend exactly
// ================================================

/// POST /api/auth/register
class UserCreateDto {
  final String email;
  final String password;
  final String username;

  UserCreateDto({
    required this.email,
    required this.password,
    required this.username,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'username': username,
  };
}

/// POST /api/auth/authenticate
class LoginRequestDto {
  final String email;
  final String password;

  LoginRequestDto({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
  };
}

/// POST /api/auth/refresh
class RefreshTokenRequestDto {
  final String refreshToken;

  RefreshTokenRequestDto({required this.refreshToken});

  Map<String, dynamic> toJson() => {
    'refreshToken': refreshToken,
  };
}

/// POST /api/auth/logout
class LogoutRequestDto {
  final String refreshToken;

  LogoutRequestDto({required this.refreshToken});

  Map<String, dynamic> toJson() => {
    'refreshToken': refreshToken,
  };
}

/// POST /api/auth/request-email-verification-code
class RequestEmailVerificationCodeRequestDto {
  final String email;

  RequestEmailVerificationCodeRequestDto({required this.email});

  Map<String, dynamic> toJson() => {
    'email': email,
  };
}

/// POST /api/auth/verify-email
class VerifyEmailRequestDto {
  final String email;
  final String code;

  VerifyEmailRequestDto({
    required this.email,
    required this.code,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'code': code,
  };
}

/// POST /api/auth/request-password-reset
class RequestPasswordResetRequestDto {
  final String email;

  RequestPasswordResetRequestDto({required this.email});

  Map<String, dynamic> toJson() => {
    'email': email,
  };
}

/// POST /api/auth/reset-password
class ResetPasswordRequestDto {
  final String email;
  final String code;
  final String newPassword;

  ResetPasswordRequestDto({
    required this.email,
    required this.code,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'code': code,
    'newPassword': newPassword,
  };
}

/// POST /api/auth/oauth/google
class GoogleAuthRequestDto {
  final String idToken;

  GoogleAuthRequestDto({required this.idToken});

  Map<String, dynamic> toJson() => {
    'idToken': idToken,
  };
}

/// POST /api/auth/oauth/facebook
class FacebookAuthRequestDto {
  final String accessToken;

  FacebookAuthRequestDto({required this.accessToken});

  Map<String, dynamic> toJson() => {
    'accessToken': accessToken,
  };
}

// ================================================
// RESPONSE DTOs - Match backend exactly
// ================================================

/// Registration response: backend returns UserResponseDto (no tokens)
/// {id, email, username, role (int), userRole (string), isEmailVerified}
class UserResponseDto {
  final String id;
  final String email;
  final String username;
  final int role;
  final String userRole;
  final bool isEmailVerified;

  UserResponseDto({
    required this.id,
    required this.email,
    required this.username,
    required this.role,
    required this.userRole,
    required this.isEmailVerified,
  });

  factory UserResponseDto.fromJson(Map<String, dynamic> json) {
    return UserResponseDto(
      id: json['id']?.toString() ?? '',
      email: json['email'] as String? ?? '',
      username: json['username'] as String? ?? '',
      role: json['role'] is int ? json['role'] : 0,
      userRole: json['userRole'] as String? ?? '',
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
    );
  }
}

/// Login/Authenticate response: backend returns AuthResponseDto (with tokens)
/// {userId, username, email, role (int), userRole (string), isActive, isEmailVerified, token, refreshToken, lastLoginAt}
class AuthResponseDto {
  final String userId;
  final String username;
  final String email;
  final int role;
  final String userRole;
  final bool isActive;
  final bool isEmailVerified;
  final String token;         // Access token (backend field name is "token")
  final String refreshToken;
  final String? lastLoginAt;

  AuthResponseDto({
    required this.userId,
    required this.username,
    required this.email,
    required this.role,
    required this.userRole,
    required this.isActive,
    required this.isEmailVerified,
    required this.token,
    required this.refreshToken,
    this.lastLoginAt,
  });

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) {
    return AuthResponseDto(
      userId: json['userId']?.toString() ?? '',
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: json['role'] is int ? json['role'] : 0,
      userRole: json['userRole'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? false,
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      token: json['token'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
      lastLoginAt: json['lastLoginAt']?.toString(),
    );
  }
}
