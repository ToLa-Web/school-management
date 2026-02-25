class ApiConfig {
  // ─── CHANGE THIS to match your setup ──────────────────────────────────────
  // Android emulator  → http://10.0.2.2:5001
  // Chrome / Windows  → http://localhost:5001
  // Physical phone    → http://<YOUR_LAN_IP>:5001  (run `ipconfig` to find it)
  // ──────────────────────────────────────────────────────────────────────────
  static const String baseUrl = 'http://192.168.0.110:5001';

  static const String registerEndpoint = '/api/auth/register';
  static const String loginEndpoint = '/api/auth/authenticate';
  static const String refreshTokenEndpoint = '/api/auth/refresh';
  static const String logoutEndpoint = '/api/auth/logout';
  static const String requestEmailVerificationEndpoint =
      '/api/auth/request-email-verification-code';
  static const String verifyEmailEndpoint = '/api/auth/verify-email';
  static const String requestPasswordResetEndpoint =
      '/api/auth/request-password-reset';
  static const String resetPasswordEndpoint = '/api/auth/reset-password';
  static const String googleAuthEndpoint = '/api/auth/oauth/google';
  static const String facebookAuthEndpoint = '/api/auth/oauth/facebook';

  // School-service endpoints
  static const String studentsEndpoint = '/api/school/Students';
  static const String teachersEndpoint = '/api/school/Teachers';
  static const String classroomsEndpoint = '/api/school/Classrooms';
  static const String subjectsEndpoint = '/api/school/Subjects';
  static const String gradesEndpoint = '/api/school/Grades';
  static const String attendanceEndpoint = '/api/school/Attendance';
  static const String schedulesEndpoint = '/api/school/Schedules';
}
