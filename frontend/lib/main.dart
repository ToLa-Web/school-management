import 'package:flutter/material.dart';
import 'package:tamdansers/Login/forgot_password.dart';
import 'package:tamdansers/Login/loading.dart';
import 'package:tamdansers/Login/login_as_parent.dart';
import 'package:tamdansers/Login/login_as_student.dart';
import 'package:tamdansers/Login/login_as_teacher.dart';
import 'package:tamdansers/Login/register.dart';
import 'package:tamdansers/Login/role.dart';
import 'package:tamdansers/Screen/Dashboard/parent_dashboard.dart';
import 'package:tamdansers/Screen/Dashboard/student_dashboard.dart';
import 'package:tamdansers/Screen/Dashboard/teacher_dashboard.dart';
import 'package:tamdansers/Screen/Edit-Profile/parent_edit_profile.dart';
import 'package:tamdansers/Screen/Edit-Profile/student_edit_profile.dart';
import 'package:tamdansers/Screen/Edit-Profile/teacher_edit_profile.dart';
import 'package:tamdansers/Screen/Role_PARENT/attendance_son_role.dart';
import 'package:tamdansers/Screen/Role_PARENT/comment_and_signature_son_role.dart';
import 'package:tamdansers/Screen/Role_PARENT/events_news_son_role.dart';
import 'package:tamdansers/Screen/Role_PARENT/homework_son_role.dart';
import 'package:tamdansers/Screen/Role_PARENT/result_monthly_son_role.dart';
import 'package:tamdansers/Screen/Role_STUDENT/attendance_student_role.dart';
import 'package:tamdansers/Screen/Role_STUDENT/course_student.role.dart';
import 'package:tamdansers/Screen/Role_STUDENT/homework_student_role.dart';
import 'package:tamdansers/Screen/Role_STUDENT/notification_student_role.dart';
import 'package:tamdansers/Screen/Role_STUDENT/permision_student_role.dart';
import 'package:tamdansers/Screen/Role_STUDENT/schedule_student_role.dart';
import 'package:tamdansers/Screen/Role_STUDENT/score_student_role.dart';
import 'package:tamdansers/Screen/Role_TEACHER/add_course_role.dart';
import 'package:tamdansers/Screen/Role_TEACHER/add_student_role.dart';
import 'package:tamdansers/Screen/Role_TEACHER/announce_to_parents_role.dart';
import 'package:tamdansers/Screen/Role_TEACHER/attendance_analysis_role.dart';
import 'package:tamdansers/Screen/Role_TEACHER/check_attendance_student_role.dart';
import 'package:tamdansers/Screen/Role_TEACHER/input_score_student_role.dart';
import 'package:tamdansers/Screen/Role_TEACHER/management_class_student_role.dart';
import 'package:tamdansers/Screen/Role_TEACHER/notifications_role.dart';
import 'package:tamdansers/Screen/Role_TEACHER/schedule_student_role.dart';
import 'package:tamdansers/constants/app_colors.dart';
import 'package:tamdansers/constants/app_text_style.dart';
import 'package:tamdansers/constants/main_wrapper.dart';
import 'package:tamdansers/widgets/line_graph_component.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainWrapper(),
      debugShowCheckedModeBanner: false,
      title: 'EduPortal',
      theme: ThemeData(
        primaryColor: AppColors.primaryText, 
        textTheme: TextTheme(
          displayLarge: AppTextStyle.title32,
          headlineMedium: AppTextStyle.screenTitle28,
          titleLarge: AppTextStyle.sectionTitle20,
          bodyLarge: AppTextStyle.fontsize18,
          bodyMedium: AppTextStyle.body,
        ),
      ),
      initialRoute: '/SplashScreen',
      routes: {
        //splash screen
        '/SplashScreen': (context) => const SplashScreen(),
        //login as roles
        '/RoleSelection': (context) => const RoleSelectionScreen(),
        '/ParentLoginScreen': (context) => const ParentLoginScreen(),
        '/login-teacher': (context) => const TeacherLoginScreen(),
        '/login-student': (context) => const StudentLoginScreen(),
        //Register Screen
        '/RegisterScreen': (context) => const RegisterScreen(),
        //Forgot Password
        '/ForgotPassword': (context) => const ForgotPasswordScreen(),
        //Dashboards
        '/StudentDashboard': (context) => const StudentDashboard(),
        '/TeacherDashboard': (context) => const TeacherDashboard(),
        '/ParentDashboard': (context) => const ParentDashboard(),
        //Edit Profile Screens can be added here
        '/StudentEditProfileScreen': (context) =>
            const StudentEditProfileScreen(),
        '/ParentEditProfileScreen': (context) =>
            const ParentEditProfileScreen(),
        '/TeacherEditProfileScreen': (context) =>
            const TeacherEditProfileScreen(),
        // Role student
        '/StudentAttendanceScreen': (context) => const AttendanceDashboard(),
        '/StudentScheduleScreen': (context) => const StudentScheduleScreen(),
        '/StudentPermissionScreen': (context) =>
            const StudentPermissionScreen(),
        '/StudentHomeworkScreen': (context) => const StudentHomeworkScreen(),
        '/StudentScoreScreen': (context) => const StudentScoreScreen(),
        '/ClassCourseStudentScreen': (context) =>
            const ClassCourseStudentScreen(),
        '/NotificationStudentScreen': (context) => const NotificationScreen(),
        //Role Teacher
        // '/CreateClassScreen': (context) => const CreateClassScreen(),
        '/AddStudentScreen': (context) => const AddStudentScreen(),
        '/TeacherScheduleScreen': (context) => const TeacherScheduleScreen(),
        '/AttendanceScreen': (context) => const AttendanceScreen(),
        // '/TeacherCourseScreen': (context) => const TeacherCourseScreen(),
        '/TeacherManagementClassScreen': (context) =>
            const TeacherManagementClassScreen(),
        '/ScoreInputScreen': (context) => const ScoreInputScreen(),
        '/AddCourseScreen': (context) => const AddCourse(),
        '/announce_to_parents': (context) => const AnnounceToParentsScreen(),
        '/teacher_notifications': (context) =>
            const TeacherNotificationScreen(),
        '/attendance_analysis': (context) => const AttendanceAnalysisScreen(),
        //detail screen
        //graph screen
        '/graph_screen': (context) =>
            const LineGraphComponent(dataPoints: [], labels: []),

        //Role Parent
        '/ParentHomeworkScreen': (context) => const ParentHomeworkScreen(),
        '/ParentSignatureScreen': (context) => const ParentSignatureScreen(),
        '/ParentAttendanceMonitorScreen': (context) =>
            const ParentAttendanceMonitor(),
        '/SchoolNewsEventsScreen': (context) => const SchoolNewsEventsScreen(),
        '/StudentReportScreen': (context) => const StudentReportScreen(),
      },
    );
  }
}
