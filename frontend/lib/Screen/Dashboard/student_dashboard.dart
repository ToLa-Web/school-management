import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:tamdansers/Controller/activity_list_widget.dart';
import 'package:tamdansers/Controller/course_card_widget.dart';
import 'package:tamdansers/Screen/Edit-Profile/student_edit_profile.dart';
import 'package:tamdansers/Screen/Role_STUDENT/attendance_student_role.dart';
import 'package:tamdansers/Screen/Role_STUDENT/homework_student_role.dart';
import 'package:tamdansers/Screen/Role_STUDENT/permision_student_role.dart';
import 'package:tamdansers/Screen/Role_STUDENT/schedule_student_role.dart';
import 'package:tamdansers/Screen/Role_STUDENT/score_student_role.dart';
// Ensure these paths match your actual project structure
import 'package:tamdansers/contants/app_text_style.dart';

import 'package:tamdansers/services/api_service.dart';

void main() => runApp(const MaterialApp(home: StudentDashboard()));

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _pageIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final List<Widget> _screens = [
    const StudentHomeContent(),
    Center(child: Text("Library", style: AppTextStyle.sectionTitle20)),
    Center(child: Text("Messages", style: AppTextStyle.sectionTitle20)),
    const StudentEditProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      body: IndexedStack(index: _pageIndex, children: _screens),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _pageIndex,
        height: 60.0,
        items: const <Widget>[
          Icon(Icons.grid_view_rounded, size: 30, color: Colors.white),
          Icon(Icons.menu_book, size: 30, color: Colors.white),
          Icon(Icons.chat_bubble, size: 30, color: Colors.white),
          Icon(Icons.settings, size: 30, color: Colors.white),
        ],
        color: const Color(0xFF007A7A),
        buttonBackgroundColor: const Color(0xFF007A7A),
        backgroundColor: const Color(0xFFF5F7F9),
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
      ),
    );
  }
}

// --- MAIN CONTENT WIDGET ---
class StudentHomeContent extends StatefulWidget {
  const StudentHomeContent({super.key});

  @override
  State<StudentHomeContent> createState() => _StudentHomeContentState();
}

class _StudentHomeContentState extends State<StudentHomeContent> {
  String _userName = '';
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final apiService = ApiService();
    final name = await apiService.getUserName();
    final email = await apiService.getUserEmail();
    if (mounted) {
      setState(() {
        _userName = name ?? 'Student';
        _userEmail = email ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildHeader(context),
            const SizedBox(height: 30),
            _buildSectionTitle("Learning Options"),
            const SizedBox(height: 15),
            _buildGridMenu(context),
            const SizedBox(height: 30),
            _buildSectionTitle("Courses", actionText: "View All"),
            const SizedBox(height: 15),
            const CourseProgressCard(
              title: "Advanced Mathematics II",
              subtitle: "28 lessons • 112 exercises",
              progress: 0.75,
              percentage: "75%",
              imagePath:
                  'https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?w=740',
            ),
            const SizedBox(height: 30),
            _buildSectionTitle("Recent Activity"),
            const SizedBox(height: 15),
            const ActivityList(),
            const SizedBox(height: 30),
            _buildSectionTitle("Upcoming Tasks", actionText: "View All"),
            const SizedBox(height: 15),
            _buildNextTasksList(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const StudentEditProfileScreen(),
            ),
          ),
          child: const CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(
              'https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?w=740',
            ),
          ),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_userName, style: AppTextStyle.fontsize18),
            Text(
              _userEmail,
              style: AppTextStyle.body.copyWith(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const Spacer(),
        _buildNotificationBadge(),
      ],
    );
  }

  Widget _buildNotificationBadge() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Icon(
        Icons.notifications_none,
        color: Colors.black,
        size: 26,
      ),
    );
  }

  Widget _buildSectionTitle(String title, {String? actionText}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyle.sectionTitle20),
        if (actionText != null)
          Text(
            actionText,
            style: AppTextStyle.body.copyWith(
              color: const Color(0xFF007A7A),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
      ],
    );
  }

  Widget _buildGridMenu(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      children: [
        _menuIcon(
          context,
          Icons.calendar_today,
          "Attendance",
          Colors.orange,
          const AttendanceDashboard(),
        ),
        _menuIcon(
          context,
          Icons.show_chart,
          "Monthly",
          Colors.teal,
          const StudentScoreScreen(),
        ),
        _menuIcon(
          context,
          Icons.people,
          "Permission",
          Colors.blue,
          const StudentPermissionScreen(),
        ),
        _menuIcon(
          context,
          Icons.edit_note,
          "Homework",
          Colors.green,
          const StudentHomeworkScreen(),
        ),
        _menuIcon(
          context,
          Icons.schedule,
          "Schedule",
          Colors.redAccent,
          const StudentScheduleScreen(),
        ),
        const CategoryCard(
          icon: Icons.qr_code_scanner,
          label: "QR Code",
          color: Colors.blue,
        ),
      ],
    );
  }

  Widget _menuIcon(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    Widget screen,
  ) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      ),
      child: CategoryCard(icon: icon, label: label, color: color),
    );
  }

  Widget _buildNextTasksList() {
    return SizedBox(
      height: 160,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          NextTaskCard(
            subject: "History",
            title: "The French Revolution:\nNarrative Essay",
            dueDate: "Due Tomorrow",
            color: Colors.orange,
          ),
          SizedBox(width: 15),
          NextTaskCard(
            subject: "Chemistry",
            title: "Acid-Base\nReport",
            dueDate: "Due Tomorrow",
            color: Color(0xFF007A7A),
          ),
        ],
      ),
    );
  }
}

// --- REUSABLE WIDGET: NEXT TASK CARD ---
class NextTaskCard extends StatelessWidget {
  final String subject, title, dueDate;
  final Color color;

  const NextTaskCard({
    super.key,
    required this.subject,
    required this.title,
    required this.dueDate,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.circle, size: 10, color: color),
              const SizedBox(width: 8),
              Text(
                subject,
                style: AppTextStyle.body.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          Text(
            title,
            style: AppTextStyle.body.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Row(
            children: [
              Icon(Icons.access_time, size: 14, color: color),
              const SizedBox(width: 5),
              Text(
                dueDate,
                style: AppTextStyle.body.copyWith(color: color, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- CATEGORY CARD (Grid Items) ---
class CategoryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const CategoryCard({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: .1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyle.body.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
