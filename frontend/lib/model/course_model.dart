// lib/models/course_model.dart

class Course {
  final String title;
  final String subject;
  final String grade;
  final double price;
  final DateTime? startDate;
  final String description;

  Course({
    required this.title,
    required this.subject,
    required this.grade,
    required this.price,
    this.startDate,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subject': subject,
      'grade': grade,
      'price': price,
      'startDate': startDate?.toIso8601String(),
      'description': description,
    };
  }
}

// Global list (in-memory storage for demo)
List<Course> globalCourses = [];
