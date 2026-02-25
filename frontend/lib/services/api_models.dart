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

// ================================================
// SCHOOL-SERVICE DTOs - Match backend exactly
// ================================================

/// Student response from GET /api/school/students
class StudentDto {
  final String id;
  final String firstName;
  final String lastName;
  final String? gender;
  final String? dateOfBirth;
  final String? phone;
  final String? address;
  final String? email;
  final bool isActive;
  final String createdAt;

  StudentDto({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.gender,
    this.dateOfBirth,
    this.phone,
    this.address,
    this.email,
    required this.isActive,
    required this.createdAt,
  });

  String get fullName => '$firstName $lastName';

  factory StudentDto.fromJson(Map<String, dynamic> json) {
    return StudentDto(
      id: json['id']?.toString() ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      gender: json['gender'] as String?,
      dateOfBirth: json['dateOfBirth']?.toString(),
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      email: json['email'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    if (gender != null) 'gender': gender,
    if (dateOfBirth != null) 'dateOfBirth': dateOfBirth,
    if (phone != null) 'phone': phone,
    if (address != null) 'address': address,
    if (email != null) 'email': email,
  };
}

/// Teacher response from GET /api/school/teachers
class TeacherDto {
  final String id;
  final String firstName;
  final String lastName;
  final String? gender;
  final String? dateOfBirth;
  final String? phone;
  final String? email;
  final String? specialization;
  final bool isActive;
  final String createdAt;

  TeacherDto({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.gender,
    this.dateOfBirth,
    this.phone,
    this.email,
    this.specialization,
    required this.isActive,
    required this.createdAt,
  });

  String get fullName => '$firstName $lastName';

  factory TeacherDto.fromJson(Map<String, dynamic> json) {
    return TeacherDto(
      id: json['id']?.toString() ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      gender: json['gender'] as String?,
      dateOfBirth: json['dateOfBirth']?.toString(),
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      specialization: json['specialization'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    if (gender != null) 'gender': gender,
    if (dateOfBirth != null) 'dateOfBirth': dateOfBirth,
    if (phone != null) 'phone': phone,
    if (email != null) 'email': email,
    if (specialization != null) 'specialization': specialization,
  };
}

/// Classroom response from GET /api/school/classrooms
class ClassroomDto {
  final String id;
  final String name;
  final String? grade;
  final String? academicYear;
  final String? teacherId;
  final String? teacherName;
  final bool isActive;
  final String createdAt;
  final int studentCount;

  ClassroomDto({
    required this.id,
    required this.name,
    this.grade,
    this.academicYear,
    this.teacherId,
    this.teacherName,
    required this.isActive,
    required this.createdAt,
    required this.studentCount,
  });

  factory ClassroomDto.fromJson(Map<String, dynamic> json) {
    return ClassroomDto(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      grade: json['grade'] as String?,
      academicYear: json['academicYear'] as String?,
      teacherId: json['teacherId']?.toString(),
      teacherName: json['teacherName'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt']?.toString() ?? '',
      studentCount: json['studentCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        if (grade != null) 'grade': grade,
        if (academicYear != null) 'academicYear': academicYear,
        if (teacherId != null) 'teacherId': teacherId,
      };
}

/// Classroom detail (includes student list) from GET /api/school/classrooms/{id}
class ClassroomDetailDto {
  final String id;
  final String name;
  final String? grade;
  final String? academicYear;
  final String? teacherId;
  final String? teacherName;
  final bool isActive;
  final String createdAt;
  final List<ClassroomStudentDto> students;

  ClassroomDetailDto({
    required this.id,
    required this.name,
    this.grade,
    this.academicYear,
    this.teacherId,
    this.teacherName,
    required this.isActive,
    required this.createdAt,
    required this.students,
  });

  factory ClassroomDetailDto.fromJson(Map<String, dynamic> json) {
    return ClassroomDetailDto(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      grade: json['grade'] as String?,
      academicYear: json['academicYear'] as String?,
      teacherId: json['teacherId']?.toString(),
      teacherName: json['teacherName'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt']?.toString() ?? '',
      students: (json['students'] as List<dynamic>?)
              ?.map((s) =>
                  ClassroomStudentDto.fromJson(s as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

/// Student nested inside ClassroomDetailDto
class ClassroomStudentDto {
  final String studentId;
  final String firstName;
  final String lastName;
  final String enrolledAt;

  ClassroomStudentDto({
    required this.studentId,
    required this.firstName,
    required this.lastName,
    required this.enrolledAt,
  });

  String get fullName => '$firstName $lastName';

  factory ClassroomStudentDto.fromJson(Map<String, dynamic> json) {
    return ClassroomStudentDto(
      studentId: json['studentId']?.toString() ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      enrolledAt: json['enrolledAt']?.toString() ?? '',
    );
  }
}

/// Generic paged result wrapper
class PagedResult<T> {
  final List<T> items;
  final int totalCount;
  final int page;
  final int pageSize;
  final int totalPages;
  final bool hasPreviousPage;
  final bool hasNextPage;

  PagedResult({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory PagedResult.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PagedResult(
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => fromJsonT(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalCount: json['totalCount'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 10,
      totalPages: json['totalPages'] as int? ?? 0,
      hasPreviousPage: json['hasPreviousPage'] as bool? ?? false,
      hasNextPage: json['hasNextPage'] as bool? ?? false,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Subject
// ─────────────────────────────────────────────────────────────────────────────

class SubjectDto {
  final String id;
  final String subjectName;
  final bool isActive;
  final String createdAt;
  final List<String> teacherNames;

  SubjectDto({
    required this.id,
    required this.subjectName,
    required this.isActive,
    required this.createdAt,
    required this.teacherNames,
  });

  factory SubjectDto.fromJson(Map<String, dynamic> json) {
    return SubjectDto(
      id: json['id'] as String? ?? '',
      subjectName: json['subjectName'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] as String? ?? '',
      teacherNames: (json['teacherNames'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {'subjectName': subjectName};
}

// ─────────────────────────────────────────────────────────────────────────────
// Grade / Score
// ─────────────────────────────────────────────────────────────────────────────

class GradeDto {
  final String id;
  final String studentId;
  final String studentName;
  final String subjectId;
  final String subjectName;
  final double score;
  final String semester;
  final String createdAt;

  GradeDto({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.subjectId,
    required this.subjectName,
    required this.score,
    required this.semester,
    required this.createdAt,
  });

  factory GradeDto.fromJson(Map<String, dynamic> json) {
    return GradeDto(
      id: json['id'] as String? ?? '',
      studentId: json['studentId'] as String? ?? '',
      studentName: json['studentName'] as String? ?? '',
      subjectId: json['subjectId'] as String? ?? '',
      subjectName: json['subjectName'] as String? ?? '',
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      semester: json['semester'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'studentId': studentId,
    'subjectId': subjectId,
    'score': score,
    'semester': semester,
  };
}

// ─────────────────────────────────────────────────────────────────────────────
// Attendance
// ─────────────────────────────────────────────────────────────────────────────

class AttendanceDto {
  final String id;
  final String studentId;
  final String studentName;
  final String? classroomId;
  final String? classroomName;
  /// ISO date string e.g. "2026-02-24"
  final String date;
  /// "Present" | "Absent" | "Late"
  final String status;
  final String createdAt;

  AttendanceDto({
    required this.id,
    required this.studentId,
    required this.studentName,
    this.classroomId,
    this.classroomName,
    required this.date,
    required this.status,
    required this.createdAt,
  });

  factory AttendanceDto.fromJson(Map<String, dynamic> json) {
    return AttendanceDto(
      id: json['id'] as String? ?? '',
      studentId: json['studentId'] as String? ?? '',
      studentName: json['studentName'] as String? ?? '',
      classroomId: json['classroomId'] as String?,
      classroomName: json['classroomName'] as String?,
      date: json['date'] as String? ?? '',
      status: json['status'] as String? ?? 'Present',
      createdAt: json['createdAt'] as String? ?? '',
    );
  }
}

class AttendanceMarkRequest {
  final String studentId;
  /// 1=Present, 2=Absent, 3=Late
  final int status;

  AttendanceMarkRequest({required this.studentId, required this.status});

  Map<String, dynamic> toJson() => {'studentId': studentId, 'status': status};
}

class BulkMarkAttendanceRequest {
  final String classroomId;
  final String date; // "YYYY-MM-DD"
  final List<AttendanceMarkRequest> records;

  BulkMarkAttendanceRequest({
    required this.classroomId,
    required this.date,
    required this.records,
  });

  Map<String, dynamic> toJson() => {
    'classroomId': classroomId,
    'date': date,
    'records': records.map((r) => r.toJson()).toList(),
  };
}

// ─────────────────────────────────────────────────────────────────────────────
// Schedule
// ─────────────────────────────────────────────────────────────────────────────

class ScheduleDto {
  final String id;
  final String classroomId;
  final String classroomName;
  final String subjectId;
  final String subjectName;
  final String? teacherId;
  final String? teacherName;
  final String day;
  final String time;

  ScheduleDto({
    required this.id,
    required this.classroomId,
    required this.classroomName,
    required this.subjectId,
    required this.subjectName,
    this.teacherId,
    this.teacherName,
    required this.day,
    required this.time,
  });

  factory ScheduleDto.fromJson(Map<String, dynamic> json) {
    return ScheduleDto(
      id: json['id'] as String? ?? '',
      classroomId: json['classroomId'] as String? ?? '',
      classroomName: json['classroomName'] as String? ?? '',
      subjectId: json['subjectId'] as String? ?? '',
      subjectName: json['subjectName'] as String? ?? '',
      teacherId: json['teacherId'] as String?,
      teacherName: json['teacherName'] as String?,
      day: json['day'] as String? ?? '',
      time: json['time'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'classroomId': classroomId,
    'subjectId': subjectId,
    if (teacherId != null) 'teacherId': teacherId,
    'day': day,
    'time': time,
  };
}

