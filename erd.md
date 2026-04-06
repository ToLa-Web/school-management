# School Management System — ERD

> This ERD covers **both microservices**: `auth-service` and `school-service`.
> Cross-service references (e.g. [AuthUserId](file:///c:/school%20management/backend/services/school-service/SchoolService/SchoolService.Domain/Entities/Teacher.cs#37-38)) are **logical links** only — no DB-level FK across services.

---

## 🔐 Auth Service

```mermaid
erDiagram
    USER {
        uuid    Id              PK
        string  Email
        string  NormalizedEmail
        string  Username
        string  PasswordHash
        enum    Role            "Admin | Teacher | Student"
        bool    IsEmailVerified
        bool    IsActive
        string  EmailVerificationCodeHash
        datetime EmailVerificationCodeExpiresAt
        datetime EmailVerificationCodeSentAt
        int     EmailVerificationFailedAttempts
        datetime EmailVerificationLockoutUntil
        string  PasswordResetCodeHash
        datetime PasswordResetCodeExpiresAt
        datetime PasswordResetCodeSentAt
        int     PasswordResetFailedAttempts
        datetime PasswordResetLockoutUntil
        datetime LastLoginAt
        datetime CreatedAt
        datetime UpdatedAt
    }

    REFRESH_TOKEN {
        uuid    Id          PK
        uuid    UserId      FK
        string  Token
        datetime ExpiresAt
        datetime RevokedAt
        datetime CreatedAt
        datetime UpdatedAt
    }

    EXTERNAL_LOGIN {
        uuid    Id              PK
        uuid    UserId          FK
        enum    Provider        "Google | Facebook"
        string  ProviderUserId
        datetime CreatedAt
        datetime UpdatedAt
    }

    USER ||--o{ REFRESH_TOKEN : "has many"
    USER ||--o{ EXTERNAL_LOGIN : "has many"
```

---

## 🏫 School Service

```mermaid
erDiagram
    STUDENT {
        uuid    Id          PK
        string  FirstName
        string  LastName
        string  Gender
        date    DateOfBirth
        string  Phone
        string  Address
        string  Email
        bool    IsActive
        datetime CreatedAt
        uuid    AuthUserId  "logical link to auth.User"
    }

    TEACHER {
        uuid    Id              PK
        string  FirstName
        string  LastName
        string  Gender
        date    DateOfBirth
        string  Phone
        string  Email
        string  Specialization
        bool    IsActive
        datetime CreatedAt
        uuid    AuthUserId  "logical link to auth.User"
    }

    ROOM {
        uuid    Id          PK
        string  Name
        string  Location
        bool    IsActive
        datetime CreatedAt
    }

    CLASSROOM {
        uuid    Id              PK
        string  Name
        string  Grade
        string  AcademicYear
        string  Semester
        uuid    TeacherId       FK
        uuid    RoomId          FK
        bool    IsActive
        datetime CreatedAt
    }

    SUBJECT {
        uuid    Id          PK
        string  SubjectName
        bool    IsActive
        datetime CreatedAt
    }

    SCHEDULE {
        uuid    Id          PK
        uuid    ClassroomId FK
        uuid    SubjectId   FK
        uuid    TeacherId   FK
        string  Day
        string  Time
        enum    Type        "Regular | MakeUp | Consultation"
        datetime CreatedAt
    }

    ATTENDANCE {
        uuid    Id          PK
        uuid    StudentId   FK
        uuid    ClassroomId FK
        date    Date
        enum    Status      "Present | Absent | Late"
        datetime CreatedAt
    }

    ENROLLMENT {
        uuid    Id          PK
        uuid    StudentId   FK
        uuid    SubjectId   FK
        datetime EnrolledAt
    }

    STUDENT_CLASSROOM {
        uuid    StudentId   FK
        uuid    ClassroomId FK
        datetime EnrolledAt
    }

    STUDENT_GRADE {
        uuid    Id          PK
        uuid    StudentId   FK
        uuid    SubjectId   FK
        decimal Score
        string  Semester
        datetime CreatedAt
    }

    TEACHER_SUBJECT {
        uuid    TeacherId   FK
        uuid    SubjectId   FK
    }

    MATERIAL {
        uuid    Id          PK
        uuid    ClassroomId FK
        string  Title
        string  Description
        string  Url
        enum    Type        "Slide | Assignment | Link | Reference"
        bool    IsActive
        datetime CreatedAt
    }

    SUBMISSION {
        uuid    Id              PK
        uuid    MaterialId      FK
        uuid    StudentId       FK
        string  SubmissionUrl
        datetime SubmittedAt
        decimal Grade
        string  Feedback
    }

    %% Core relationships
    TEACHER ||--o{ CLASSROOM : "teaches"
    ROOM    ||--o{ CLASSROOM : "hosts"
    TEACHER ||--o{ SCHEDULE  : "assigned to"
    CLASSROOM ||--o{ SCHEDULE : "has"
    SUBJECT   ||--o{ SCHEDULE : "covered in"

    %% Many-to-many join tables
    STUDENT  }o--o{ CLASSROOM      : "via STUDENT_CLASSROOM"
    STUDENT_CLASSROOM }|--|{ STUDENT   : ""
    STUDENT_CLASSROOM }|--|{ CLASSROOM : ""

    TEACHER  }o--o{ SUBJECT        : "via TEACHER_SUBJECT"
    TEACHER_SUBJECT }|--|{ TEACHER  : ""
    TEACHER_SUBJECT }|--|{ SUBJECT  : ""

    STUDENT  }o--o{ SUBJECT        : "via ENROLLMENT"
    ENROLLMENT }|--|{ STUDENT : ""
    ENROLLMENT }|--|{ SUBJECT : ""

    %% Activity tracking
    STUDENT  ||--o{ ATTENDANCE    : "has"
    CLASSROOM ||--o{ ATTENDANCE  : "recorded for"
    STUDENT  ||--o{ STUDENT_GRADE : "has"
    SUBJECT  ||--o{ STUDENT_GRADE : "graded in"

    %% Materials & Submissions
    CLASSROOM ||--o{ MATERIAL   : "contains"
    MATERIAL  ||--o{ SUBMISSION : "receives"
    STUDENT   ||--o{ SUBMISSION : "makes"
```

---

## 🔗 Cross-Service Relationship

| School Entity | Field       | Links To        |
|---------------|-------------|-----------------|
| [Student](file:///c:/school%20management/backend/services/school-service/SchoolService/SchoolService.Domain/Entities/Student.cs#3-63)     | [AuthUserId](file:///c:/school%20management/backend/services/school-service/SchoolService/SchoolService.Domain/Entities/Teacher.cs#37-38) | `auth.User.Id` |
| [Teacher](file:///c:/school%20management/backend/services/school-service/SchoolService/SchoolService.Domain/Entities/Teacher.cs#31-36)     | [AuthUserId](file:///c:/school%20management/backend/services/school-service/SchoolService/SchoolService.Domain/Entities/Teacher.cs#37-38) | `auth.User.Id` |

> These are **logical references only** — no FK constraint across service databases.

---

## 📋 Enum Summary

| Enum              | Values                             | Used In       |
|-------------------|------------------------------------|---------------|
| `UserRole`        | Admin, Teacher, Student            | User          |
| `ExternalAuthProvider` | Google, Facebook             | ExternalLogin |
| `MaterialType`    | Slide, Assignment, Link, Reference | Material      |
| `SessionType`     | Regular, MakeUp, Consultation      | Schedule      |
| `AttendanceStatus`| Present, Absent, Late              | Attendance    |
