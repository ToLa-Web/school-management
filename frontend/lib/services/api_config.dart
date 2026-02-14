class ApiConfig {
  // TODO: Change this to your actual backend URL
  // For local development with Android emulator: http://10.0.2.2:5001
  // For local development with iOS simulator: http://localhost:5001
  // For physical device: http://<your-ip-address>:5001
  // For Windows/Chrome: Use 127.0.0.1 instead of localhost for IPv4
  // Use 127.0.0.1 for Chrome, 10.0.2.2 for Android emulator,
  // or your LAN IP for physical device
  static const String baseUrl = 'http://172.16.1.98:5001';
  
  static const String registerEndpoint = '/api/auth/register';
  static const String loginEndpoint = '/api/auth/authenticate';
  static const String refreshTokenEndpoint = '/api/auth/refresh';
  static const String logoutEndpoint = '/api/auth/logout';
  static const String requestEmailVerificationEndpoint = '/api/auth/request-email-verification-code';
  static const String verifyEmailEndpoint = '/api/auth/verify-email';
  static const String requestPasswordResetEndpoint = '/api/auth/request-password-reset';
  static const String resetPasswordEndpoint = '/api/auth/reset-password';
  static const String googleAuthEndpoint = '/api/auth/oauth/google';
  static const String facebookAuthEndpoint = '/api/auth/oauth/facebook';
}
