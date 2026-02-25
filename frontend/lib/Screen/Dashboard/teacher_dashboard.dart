import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tamdansers/Screen/Edit-Profile/teacher_edit_profile.dart';
import 'package:tamdansers/Screen/Role_TEACHER/add_student_role.dart';
import 'package:tamdansers/Screen/Role_TEACHER/announce_to_parents_role.dart';
import 'package:tamdansers/Screen/Role_TEACHER/check_attendance_student_role.dart';
import 'package:tamdansers/Screen/Role_TEACHER/course_learn_role.dart';
import 'package:tamdansers/Screen/Role_TEACHER/homework_role.dart';
import 'package:tamdansers/Screen/Role_TEACHER/input_score_student_role.dart';
import 'package:tamdansers/Screen/Role_TEACHER/link_parent_role.dart';
import 'package:tamdansers/Screen/Role_TEACHER/management_class_student_role.dart';
import 'package:tamdansers/Screen/Role_TEACHER/notifications_role.dart';
import 'package:tamdansers/Screen/Role_TEACHER/schedule_detail_role.dart';
import 'package:tamdansers/Screen/Role_TEACHER/schedule_student_role.dart';
import 'package:tamdansers/services/api_service.dart';
import 'package:tamdansers/services/api_models.dart';

// ----------------------------------------------------------------------
// 1. MAIN APP & NAVIGATION
// ----------------------------------------------------------------------
void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      textTheme: GoogleFonts.interTextTheme(),
      scaffoldBackgroundColor: const Color(0xFFF3F6F8),
    ),
    home: const TeacherDashboard(),
  ),
);

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  int _pageIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final List<Widget> _screens = [
    const TeacherHomeContent(),
    const TeacherCoursesTab(),
    const TeacherMessagesTab(),
    const TeacherSettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F8),
      body: IndexedStack(index: _pageIndex, children: _screens),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _pageIndex,
        height: 65.0,
        items: const <Widget>[
          Icon(Icons.dashboard_rounded, size: 28, color: Colors.white),
          Icon(Icons.auto_stories_rounded, size: 28, color: Colors.white),
          Icon(Icons.forum_rounded, size: 28, color: Colors.white),
          Icon(Icons.tune_rounded, size: 28, color: Colors.white),
        ],
        color: const Color(0xFF0D3B66),
        buttonBackgroundColor: const Color(0xFFF95738),
        backgroundColor: const Color(0xFFF3F6F8),
        animationCurve: Curves.easeInOutCubic,
        animationDuration: const Duration(milliseconds: 400),
        onTap: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
      ),
    );
  }
}

// ----------------------------------------------------------------------
// 2. HOME SCREEN CONTENT (INDEX 0)
// ----------------------------------------------------------------------
class TeacherHomeContent extends StatefulWidget {
  const TeacherHomeContent({super.key});

  @override
  State<TeacherHomeContent> createState() => _TeacherHomeContentState();
}

class _TeacherHomeContentState extends State<TeacherHomeContent> {
  String _userName = '';
  bool _isToolsExpanded = false;
  bool _isLoading = true;

  // API data
  List<StudentDto> _students = [];
  List<TeacherDto> _teachers = [];
  List<ClassroomDto> _classrooms = [];

  // Define your tools with their corresponding destination screens
  final List<ManagementTool> managementTools = [
    ManagementTool(
      name: 'Classes',
      icon: Icons.door_front_door,
      color: Colors.blue,
      screen: const TeacherManagementClassScreen(),
    ),
    ManagementTool(
      name: 'Attendance',
      icon: Icons.person,
      color: Colors.green,
      screen: const AttendanceScreen(),
    ),
    ManagementTool(
      name: 'Courses',
      icon: Icons.book,
      color: Colors.purple,
      screen: const TeacherCourseScreen(),
    ),
    ManagementTool(
      name: 'Students',
      icon: Icons.group_add,
      color: Colors.orange,
      screen: const AddStudentScreen(),
    ),
    ManagementTool(
      name: 'Grades',
      icon: Icons.assessment,
      color: Colors.red,
      screen: const ScoreInputScreen(),
    ),
    ManagementTool(
      name: 'Schedule',
      icon: Icons.calendar_month,
      color: Colors.teal,
      screen: const TeacherScheduleScreen(),
    ),
    ManagementTool(
      name: 'Parents',
      icon: Icons.family_restroom_rounded,
      color: const Color(0xFF8E44AD),
      screen: const ParentManagementScreen(),
    ),
    ManagementTool(
      name: 'Message',
      icon: Icons.campaign_rounded,
      color: const Color(0xFFE67E22),
      screen: const AnnounceToParentsScreen(),
    ),
    ManagementTool(
      name: 'Homework',
      icon: Icons.assignment_turned_in_rounded,
      color: const Color(0xFF2ECC71),
      screen: const TeacherHomeworkScreen(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadSchoolData();
  }

  Future<void> _loadUserData() async {
    final apiService = ApiService();
    final name = await apiService.getUserName();
    if (mounted) {
      setState(() {
        _userName = name ?? 'Alexander Smith';
      });
    }
  }

  Future<void> _loadSchoolData() async {
    try {
      final apiService = ApiService();
      final results = await Future.wait([
        apiService.getStudents(),
        apiService.getTeachers(),
        apiService.getClassrooms(),
      ]);
      if (mounted) {
        setState(() {
          _students = results[0] as List<StudentDto>;
          _teachers = results[1] as List<TeacherDto>;
          _classrooms = results[2] as List<ClassroomDto>;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildTeacherHeader(context),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildGlassOverviewCard(),
            ),
            const SizedBox(height: 35),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildSectionTitle(
                "Management Tools",
                actionText: _isToolsExpanded ? "Show Less" : "View All",
                onActionTap: () {
                  setState(() {
                    _isToolsExpanded = !_isToolsExpanded;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            _buildToolsGrid(),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildModernAnnouncementTile(),
            ),
            const SizedBox(height: 35),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildSectionTitle("Quick Actions"),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildQuickActions(),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildSectionTitle(
                "Today's Classes",
                actionText: "Full Schedule",
                onActionTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TeacherScheduleScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildModernTimelineSchedule(),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // Clean Management Tools Grid with click functionality
  Widget _buildToolsGrid() {
    // Show only first 6 items when collapsed, all 9 when expanded
    final displayedTools = _isToolsExpanded
        ? managementTools
        : managementTools.take(6).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.9,
        ),
        itemCount: displayedTools.length,
        itemBuilder: (context, index) {
          final tool = displayedTools[index];
          return _buildClickableToolCard(tool);
        },
      ),
    );
  }

  // Clickable Tool Card
  Widget _buildClickableToolCard(ManagementTool tool) {
    return Bounceable(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => tool.screen));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: tool.color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(tool.icon, color: tool.color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              tool.name,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
    String title, {
    String? actionText,
    VoidCallback? onActionTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0D3B66),
          ),
        ),
        if (actionText != null)
          GestureDetector(
            onTap: onActionTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF95738).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                actionText,
                style: GoogleFonts.inter(
                  color: const Color(0xFFF95738),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTeacherHeader(BuildContext context) {
    return Row(
      children: [
        Bounceable(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TeacherEditProfileScreen(),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const CircleAvatar(
              radius: 28,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 26,
                backgroundImage: AssetImage('assets/images/grade1.jpg'),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Good Morning,",
                style: GoogleFonts.inter(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                _userName,
                style: GoogleFonts.outfit(
                  color: const Color(0xFF0D3B66),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Bounceable(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TeacherNotificationScreen(),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  Icons.notifications_outlined,
                  color: Color(0xFF0D3B66),
                  size: 24,
                ),
                Positioned(
                  right: -2,
                  top: -2,
                  child: CircleAvatar(
                    radius: 5,
                    backgroundColor: Color(0xFFF95738),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGlassOverviewCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF0D3B66), Color(0xFF1E5B94)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D3B66).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Icon(
              Icons.school,
              size: 120,
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Academic Overview",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Semester 2 • 2023-24",
                        style: GoogleFonts.inter(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                    ),
                    child: const Text(
                      "Active",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildModernStatItem("Classes", _isLoading ? "..." : _classrooms.length.toString().padLeft(2, '0')),
                  _buildModernStatItem("Students", _isLoading ? "..." : _students.length.toString()),
                  _buildModernStatItem("Teachers", _isLoading ? "..." : _teachers.length.toString()),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModernStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildModernAnnouncementTile() {
    return Bounceable(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AnnounceToParentsScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFB75E), Color(0xFFED8F03)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.campaign_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Announce to Parents",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: const Color(0xFF0D3B66),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Send an important update",
                    style: GoogleFonts.inter(
                      color: Colors.grey.shade500,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F6F8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Color(0xFF0D3B66),
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildModernActionCard(
          Icons.qr_code_scanner_rounded,
          "Scan ID",
          const Color(0xFF00C4FF),
          onTap: () => _showFeatureComingSoon("Scan ID"),
        ),
        _buildModernActionCard(
          Icons.family_restroom_rounded,
          "Link Parent",
          const Color(0xFF50E3C2),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ParentManagementScreen(),
              ),
            );
          },
        ),
        _buildModernActionCard(
          Icons.assignment_turned_in_rounded,
          "Approve",
          const Color(0xFFB86DFF),
          onTap: () => _showFeatureComingSoon("Approval System"),
        ),
      ],
    );
  }

  Widget _buildModernActionCard(
    IconData icon,
    String label,
    Color accent, {
    required VoidCallback onTap,
  }) {
    return Bounceable(
      onTap: onTap,
      child: Container(
        width: 105,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: accent, size: 32),
            const SizedBox(height: 12),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF4A4A4A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFeatureComingSoon(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F6F8),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_awesome_rounded,
                color: const Color(0xFF0D3B66),
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Coming Soon",
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0D3B66),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "The $feature module is currently under maintenance and will be available in the next update.",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D3B66),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Got it",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildModernTimelineSchedule() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_classrooms.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.class_rounded, size: 48,
                  color: Colors.grey.shade300),
              const SizedBox(height: 12),
              Text("No classrooms yet",
                  style: GoogleFonts.inter(
                    color: Colors.grey.shade500, fontSize: 15)),
            ],
          ),
        ),
      );
    }

    // Build class cards from real classroom data
    final List<Color> cardColors = [
      const Color(0xFF4A90E2),
      const Color(0xFFE67E22),
      const Color(0xFF27AE60),
      const Color(0xFFF95738),
      const Color(0xFFB86DFF),
      const Color(0xFF50E3C2),
    ];
    final List<IconData> cardIcons = [
      Icons.functions_rounded,
      Icons.menu_book_rounded,
      Icons.biotech_rounded,
      Icons.science_rounded,
      Icons.calculate_rounded,
      Icons.computer_rounded,
    ];

    final List<Map<String, dynamic>> todayClasses = _classrooms
        .asMap()
        .entries
        .map((entry) {
      final i = entry.key;
      final c = entry.value;
      final color = cardColors[i % cardColors.length];
      return {
        'title': c.name,
        'subtitle':
            '${c.grade ?? "No grade"} • ${c.studentCount} students',
        'subject': c.name,
        'subjectIcon': cardIcons[i % cardIcons.length],
        'subjectColor': color,
        'time': '',
        'timeRange': c.academicYear ?? '',
        'accent': color,
        'isDone': false,
        'isCurrent': i == 0,
        'topic': c.teacherName != null
            ? 'Teacher: ${c.teacherName}'
            : 'No teacher assigned',
        'students': c.studentCount,
        'room': c.grade ?? '',
        'description': 'Academic Year: ${c.academicYear ?? "N/A"}',
        'homework': '',
        'materials': <String>[],
      };
    }).toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.95,
      ),
      itemCount: todayClasses.length,
      itemBuilder: (context, index) {
        return _buildClassCard(todayClasses[index]);
      },
    );
  }

  Widget _buildClassCard(Map<String, dynamic> classData) {
    final String title = classData['title'];
    final String subject = classData['subject'] ?? '';
    final IconData subjectIcon =
        classData['subjectIcon'] ?? Icons.class_rounded;
    final Color subjectColor =
        classData['subjectColor'] ?? const Color(0xFF4A90E2);
    final String timeRange = classData['timeRange'] ?? classData['time'] ?? '';
    final bool isDone = classData['isDone'] ?? false;
    final bool isCurrent = classData['isCurrent'] ?? false;

    // Extract class name from title (e.g., "Grade 10 - Biology" → "Grade 10 A")
    final parts = title.split(' - ');
    final className = parts.isNotEmpty ? parts[0] : title;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                TeacherScheduleDetailScreen(classData: classData),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          ),
                        ),
                    child: child,
                  );
                },
            transitionDuration: const Duration(milliseconds: 350),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isCurrent
              ? Border.all(color: subjectColor.withValues(alpha: 0.3), width: 1.5)
              : null,
          boxShadow: [
            BoxShadow(
              color: isCurrent
                  ? subjectColor.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.03),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon container
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: subjectColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(subjectIcon, color: subjectColor, size: 26),
            ),
            const Spacer(),

            // Subject label
            Text(
              subject,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),

            // Class name (bold)
            Text(
              className,
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0D3B66),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),

            // Time range row
            Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 14,
                  color: isCurrent ? subjectColor : Colors.grey.shade400,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    timeRange,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isCurrent ? subjectColor : Colors.grey.shade500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isDone)
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF27AE60).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Color(0xFF27AE60),
                      size: 12,
                    ),
                  ),
                if (isCurrent)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: subjectColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'LIVE',
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: subjectColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Model class for Management Tools
class ManagementTool {
  final String name;
  final IconData icon;
  final Color color;
  final Widget screen;

  ManagementTool({
    required this.name,
    required this.icon,
    required this.color,
    required this.screen,
  });
}

// ----------------------------------------------------------------------
// 3. SETTINGS SCREEN (INDEX 2)
// ----------------------------------------------------------------------
class TeacherSettingsScreen extends StatefulWidget {
  const TeacherSettingsScreen({super.key});

  @override
  State<TeacherSettingsScreen> createState() => _TeacherSettingsScreenState();
}

class _TeacherSettingsScreenState extends State<TeacherSettingsScreen> {
  String _userName = '';
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final api = ApiService();
    final name = await api.getUserName();
    final email = await api.getUserEmail();
    if (mounted) {
      setState(() {
        _userName = name ?? 'Teacher';
        _userEmail = email ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F8),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                "Settings",
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0D3B66),
                ),
              ),
              const SizedBox(height: 30),
              _buildModernProfileHeader(),
              const SizedBox(height: 40),
              _buildModernSettingsGroup([
                _modernSubTile(
                  icon: Icons.person_rounded,
                  title: "Personal Information",
                  color: const Color(0xFF4A90E2),
                ),
                _modernSubTile(
                  icon: Icons.security_rounded,
                  title: "Security & Login",
                  color: const Color(0xFF50E3C2),
                ),
                _modernSubTile(
                  icon: Icons.notifications_active_rounded,
                  title: "Notifications",
                  color: const Color(0xFFF5A623),
                ),
                _modernSubTile(
                  icon: Icons.translate_rounded,
                  title: "Language",
                  color: const Color(0xFFB86DFF),
                  trailing: "Khmer",
                ),
              ]),
              const SizedBox(height: 24),
              _buildModernSettingsGroup([
                _modernSubTile(
                  icon: Icons.support_agent_rounded,
                  title: "Help & Support",
                  color: Colors.grey.shade600,
                ),
                _modernSubTile(
                  icon: Icons.info_rounded,
                  title: "About Application",
                  color: Colors.grey.shade600,
                ),
              ]),
              const SizedBox(height: 40),
              _buildModernLogoutButton(context),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernProfileHeader() {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0D3B66).withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
                border: Border.all(color: Colors.white, width: 4),
              ),
              child: const CircleAvatar(
                radius: 54,
                backgroundImage: NetworkImage(
                  'https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?semt=ais_hybrid&w=740&q=80',
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Bounceable(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF95738),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          _userName.isNotEmpty ? _userName : "Teacher",
          style: GoogleFonts.outfit(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0D3B66),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF0D3B66).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _userEmail.isNotEmpty ? _userEmail : "Teacher",
            style: GoogleFonts.inter(
              color: const Color(0xFF0D3B66),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModernSettingsGroup(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: children.asMap().entries.map((entry) {
          int idx = entry.key;
          Widget tile = entry.value;
          return Column(
            children: [
              tile,
              if (idx != children.length - 1)
                Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey.shade100,
                  indent: 64,
                  endIndent: 24,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _modernSubTile({
    required IconData icon,
    required String title,
    required Color color,
    String? trailing,
  }) {
    return Bounceable(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF333333),
                ),
              ),
            ),
            if (trailing != null)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  trailing,
                  style: GoogleFonts.inter(
                    color: Colors.grey.shade500,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey.shade400,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Bounceable(
        onTap: () async {
          await ApiService().logout();
          if (context.mounted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/RoleSelection',
              (route) => false,
            );
          }
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF0F0),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFFFD6D6)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.logout_rounded,
                color: Color(0xFFE94A59),
                size: 22,
              ),
              const SizedBox(width: 12),
              Text(
                "Secure Log Out",
                style: GoogleFonts.outfit(
                  color: const Color(0xFFE94A59),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// TEACHER COURSES TAB (Embedded – No AppBar Back Button)
// =============================================================================
class TeacherCoursesTab extends StatefulWidget {
  const TeacherCoursesTab({super.key});

  @override
  State<TeacherCoursesTab> createState() => _TeacherCoursesTabState();
}

class _TeacherCoursesTabState extends State<TeacherCoursesTab> {
  String _selectedFilter = 'All';
  String _searchQuery = '';
  bool _isLoading = true;

  final List<String> _filters = ['All', 'Active', 'Inactive'];

  List<Map<String, dynamic>> _teacherCourses = [];

  @override
  void initState() {
    super.initState();
    _loadClassrooms();
  }

  Future<void> _loadClassrooms() async {
    try {
      final classrooms = await ApiService().getClassrooms();
      final List<Color> colors = [
        const Color(0xFF4A90E2),
        const Color(0xFFFFB75E),
        const Color(0xFF50E3C2),
        const Color(0xFFF95738),
        const Color(0xFFB86DFF),
        const Color(0xFF0D3B66),
      ];
      final List<IconData> icons = [
        Icons.calculate_rounded,
        Icons.bolt_rounded,
        Icons.science_rounded,
        Icons.biotech_rounded,
        Icons.bar_chart_rounded,
        Icons.computer_rounded,
      ];
      if (mounted) {
        setState(() {
          _teacherCourses = classrooms.asMap().entries.map((entry) {
            final i = entry.key;
            final c = entry.value;
            return {
              'title': c.name,
              'grade': c.grade ?? 'No grade',
              'students': c.studentCount,
              'lessons': 0,
              'progress': 0.0,
              'status': c.isActive ? 'Active' : 'Inactive',
              'color': colors[i % colors.length],
              'icon': icons[i % icons.length],
              'rating': 0.0,
              'nextClass': c.teacherName ?? 'No teacher',
            };
          }).toList();
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<Map<String, dynamic>> get _filteredCourses {
    return _teacherCourses.where((c) {
      final matchFilter =
          _selectedFilter == 'All' || c['status'] == _selectedFilter;
      final matchSearch = c['title'].toString().toLowerCase().contains(
        _searchQuery,
      );
      return matchFilter && matchSearch;
    }).toList();
  }

  int get _totalStudents =>
      _teacherCourses.fold(0, (sum, c) => sum + (c['students'] as int));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // ── Header ──
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF95738), Color(0xFFFF8A65)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFF95738).withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.auto_stories_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Courses',
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0D3B66),
                      ),
                    ),
                    Text(
                      '${_teacherCourses.length} courses · $_totalStudents students',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Bounceable(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TeacherCourseScreen(),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D3B66),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0D3B66).withValues(alpha: 0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Stats Overview Card ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0D3B66), Color(0xFF1E5B94)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0D3B66).withValues(alpha: 0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _buildStatItem(
                    '${_teacherCourses.where((c) => c['status'] == 'Active').length}',
                    'Active',
                    Icons.play_circle_outline_rounded,
                    const Color(0xFF50E3C2),
                  ),
                  _buildStatDivider(),
                  _buildStatItem(
                    '$_totalStudents',
                    'Students',
                    Icons.people_outline_rounded,
                    const Color(0xFF4A90E2),
                  ),
                  _buildStatDivider(),
                  _buildStatItem(
                    '${_teacherCourses.fold(0, (int sum, c) => sum + (c['lessons'] as int))}',
                    'Lessons',
                    Icons.menu_book_rounded,
                    const Color(0xFFFFB75E),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ── Search Bar ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: TextField(
                onChanged: (v) =>
                    setState(() => _searchQuery = v.toLowerCase()),
                style: GoogleFonts.inter(
                  color: const Color(0xFF0D3B66),
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  hintText: 'Search your courses...',
                  hintStyle: GoogleFonts.inter(
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w500,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Colors.grey.shade400,
                    size: 22,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── Filter Chips ──
          SizedBox(
            height: 42,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = filter == _selectedFilter;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Bounceable(
                    onTap: () => setState(() => _selectedFilter = filter),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF0D3B66)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: const Color(
                                    0xFF0D3B66,
                                  ).withValues(alpha: 0.25),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                      ),
                      child: Center(
                        child: Text(
                          filter,
                          style: GoogleFonts.inter(
                            color: isSelected
                                ? Colors.white
                                : Colors.grey.shade600,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // ── Course List ──
          Expanded(
            child: _filteredCourses.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 64,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No courses found',
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 4,
                    ),
                    itemCount: _filteredCourses.length,
                    itemBuilder: (context, index) {
                      final course = _filteredCourses[index];
                      return _buildTeacherCourseCard(course);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.inter(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.white.withValues(alpha: 0.15),
    );
  }

  Widget _buildTeacherCourseCard(Map<String, dynamic> course) {
    final Color accent = course['color'] as Color;
    final String status = course['status'] as String;

    Color statusColor;
    IconData statusIcon;
    switch (status) {
      case 'Active':
        statusColor = const Color(0xFF50E3C2);
        statusIcon = Icons.play_circle_rounded;
        break;
      case 'Completed':
        statusColor = const Color(0xFF4A90E2);
        statusIcon = Icons.check_circle_rounded;
        break;
      default:
        statusColor = Colors.grey.shade400;
        statusIcon = Icons.edit_note_rounded;
    }

    return Bounceable(
      onTap: () => _showCourseDetail(context, course),
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 62,
                    width: 62,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [accent, accent.withValues(alpha: 0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: accent.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      course['icon'] as IconData,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course['title'] as String,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: const Color(0xFF0D3B66),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.class_rounded,
                              size: 14,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              course['grade'] as String,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.people_outline_rounded,
                              size: 14,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '${course['students']}',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, size: 14, color: statusColor),
                        const SizedBox(width: 4),
                        Text(
                          status,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // Progress + info row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Progress',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${((course['progress'] as double) * 100).toInt()}%',
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: accent,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: course['progress'] as double,
                            minHeight: 6,
                            backgroundColor: const Color(0xFFF3F6F8),
                            color: accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F6F8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          size: 14,
                          color: Color(0xFF0D3B66),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          course['nextClass'] as String,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0D3B66),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCourseDetail(BuildContext context, Map<String, dynamic> course) {
    final Color accent = course['color'] as Color;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            // ── Course header ──
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [accent, accent.withValues(alpha: 0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    course['icon'] as IconData,
                    size: 42,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course['title'] as String,
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${course['grade']} · ${course['students']} students',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // ── Quick Actions ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  _buildQuickAction(
                    'Lessons',
                    Icons.menu_book_rounded,
                    const Color(0xFF4A90E2),
                  ),
                  const SizedBox(width: 12),
                  _buildQuickAction(
                    'Students',
                    Icons.people_rounded,
                    const Color(0xFF50E3C2),
                  ),
                  const SizedBox(width: 12),
                  _buildQuickAction(
                    'Grades',
                    Icons.assessment_rounded,
                    const Color(0xFFFFB75E),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // ── Lesson list ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Recent Lessons',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0D3B66),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: (course['lessons'] as int).clamp(0, 5),
                itemBuilder: (context, i) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F6F8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              '${i + 1}',
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                color: accent,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Lesson ${i + 1}: Chapter ${i + 1}',
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: const Color(0xFF0D3B66),
                                ),
                              ),
                              Text(
                                i < 3 ? 'Completed' : 'Upcoming',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: i < 3
                                      ? const Color(0xFF50E3C2)
                                      : Colors.grey.shade400,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          i < 3
                              ? Icons.check_circle_rounded
                              : Icons.radio_button_unchecked_rounded,
                          color: i < 3
                              ? const Color(0xFF50E3C2)
                              : Colors.grey.shade300,
                          size: 22,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(String label, IconData icon, Color color) {
    return Expanded(
      child: Bounceable(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: color.withValues(alpha: 0.15)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 26),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// TEACHER MESSAGES TAB
// =============================================================================
class TeacherMessagesTab extends StatefulWidget {
  const TeacherMessagesTab({super.key});

  @override
  State<TeacherMessagesTab> createState() => _TeacherMessagesTabState();
}

class _TeacherMessagesTabState extends State<TeacherMessagesTab>
    with SingleTickerProviderStateMixin {
  late TabController _msgTabController;
  String _searchQuery = '';

  final List<Map<String, dynamic>> _conversations = [
    {
      'name': 'John Doe (Parent)',
      'subject': 'Grade 12-A',
      'message': 'Thank you for the update on my son\'s progress.',
      'time': '3m ago',
      'unread': 2,
      'online': true,
      'avatar': Icons.person,
      'color': const Color(0xFF4A90E2),
      'type': 'parent',
    },
    {
      'name': 'Sarah Kim (Student)',
      'subject': 'Mathematics',
      'message': 'Can I schedule office hours this Friday?',
      'time': '10m ago',
      'unread': 1,
      'online': true,
      'avatar': Icons.person,
      'color': const Color(0xFF50E3C2),
      'type': 'student',
    },
    {
      'name': 'Grade 12-A Group',
      'subject': '32 members',
      'message': 'You: Homework is due on Monday.',
      'time': '30m ago',
      'unread': 0,
      'online': false,
      'avatar': Icons.groups_rounded,
      'color': const Color(0xFFB86DFF),
      'type': 'group',
    },
    {
      'name': 'Ms. Taylor',
      'subject': 'Co-teacher · English',
      'message': 'Should we combine the next exam?',
      'time': '1h ago',
      'unread': 3,
      'online': true,
      'avatar': Icons.person,
      'color': const Color(0xFFF95738),
      'type': 'colleague',
    },
    {
      'name': 'Alex Rivera (Student)',
      'subject': 'Physics',
      'message': 'Submitted the lab report. Please review.',
      'time': '2h ago',
      'unread': 0,
      'online': false,
      'avatar': Icons.person,
      'color': const Color(0xFFFFB75E),
      'type': 'student',
    },
    {
      'name': 'Faculty Room',
      'subject': '12 members',
      'message': 'Principal: Staff meeting at 3 PM today.',
      'time': '3h ago',
      'unread': 4,
      'online': false,
      'avatar': Icons.groups_rounded,
      'color': const Color(0xFF0D3B66),
      'type': 'group',
    },
    {
      'name': 'Admin Office',
      'subject': 'School Administration',
      'message': 'Your leave request has been approved.',
      'time': 'Yesterday',
      'unread': 0,
      'online': false,
      'avatar': Icons.admin_panel_settings_rounded,
      'color': const Color(0xFF4A4A4A),
      'type': 'admin',
    },
    {
      'name': 'Emily Park (Parent)',
      'subject': 'Grade 11-B',
      'message': 'Regarding the upcoming parent-teacher meeting.',
      'time': 'Yesterday',
      'unread': 1,
      'online': false,
      'avatar': Icons.person,
      'color': const Color(0xFF6C5CE7),
      'type': 'parent',
    },
  ];

  List<Map<String, dynamic>> _filterByTab(int tabIndex) {
    List<Map<String, dynamic>> list;
    if (tabIndex == 0) {
      list = _conversations;
    } else if (tabIndex == 1) {
      list = _conversations
          .where(
            (c) =>
                c['type'] == 'student' ||
                c['type'] == 'parent' ||
                c['type'] == 'colleague' ||
                c['type'] == 'admin',
          )
          .toList();
    } else {
      list = _conversations.where((c) => c['type'] == 'group').toList();
    }
    if (_searchQuery.isEmpty) return list;
    return list
        .where(
          (c) =>
              c['name'].toString().toLowerCase().contains(_searchQuery) ||
              c['message'].toString().toLowerCase().contains(_searchQuery),
        )
        .toList();
  }

  int get _totalUnread =>
      _conversations.fold(0, (sum, c) => sum + (c['unread'] as int));

  @override
  void initState() {
    super.initState();
    _msgTabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _msgTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // ── Header ──
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6C5CE7).withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.forum_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Messages',
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0D3B66),
                      ),
                    ),
                    Text(
                      '$_totalUnread unread messages',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Bounceable(
                  onTap: () => _showComposeSheet(context),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D3B66),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0D3B66).withValues(alpha: 0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.edit_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Tab Bar ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TabBar(
                controller: _msgTabController,
                onTap: (_) => setState(() {}),
                indicator: BoxDecoration(
                  color: const Color(0xFF0D3B66),
                  borderRadius: BorderRadius.circular(14),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey.shade500,
                labelStyle: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                unselectedLabelStyle: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
                dividerColor: Colors.transparent,
                splashBorderRadius: BorderRadius.circular(14),
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('All'),
                        if (_totalUnread > 0) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _msgTabController.index == 0
                                  ? const Color(0xFFF95738)
                                  : const Color(0xFFF95738).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '$_totalUnread',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: _msgTabController.index == 0
                                    ? Colors.white
                                    : const Color(0xFFF95738),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Tab(text: 'People'),
                  const Tab(text: 'Groups'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── Search Bar ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: TextField(
                onChanged: (v) =>
                    setState(() => _searchQuery = v.toLowerCase()),
                style: GoogleFonts.inter(
                  color: const Color(0xFF0D3B66),
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  hintText: 'Search messages...',
                  hintStyle: GoogleFonts.inter(
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w500,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Colors.grey.shade400,
                    size: 22,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // ── Online Now ──
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: _conversations
                  .where((c) => c['online'] == true)
                  .length,
              itemBuilder: (context, index) {
                final onlineUsers = _conversations
                    .where((c) => c['online'] == true)
                    .toList();
                final user = onlineUsers[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  user['color'] as Color,
                                  (user['color'] as Color).withValues(alpha: 0.6),
                                ],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: (user['color'] as Color).withValues(alpha: 
                                    0.3,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Icon(
                              user['avatar'] as IconData,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          Positioned(
                            bottom: 2,
                            right: 2,
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: const Color(0xFF50E3C2),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFF3F6F8),
                                  width: 2.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: 60,
                        child: Text(
                          (user['name'] as String).split(' ').first,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0D3B66),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // ── Conversations List ──
          Expanded(
            child: TabBarView(
              controller: _msgTabController,
              children: [
                _buildConversationList(_filterByTab(0)),
                _buildConversationList(_filterByTab(1)),
                _buildConversationList(_filterByTab(2)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationList(List<Map<String, dynamic>> conversations) {
    if (conversations.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.forum_outlined, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              'No conversations yet',
              style: GoogleFonts.outfit(
                fontSize: 18,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: conversations.length,
      itemBuilder: (context, index) {
        final conv = conversations[index];
        return _buildConversationTile(conv);
      },
    );
  }

  Widget _buildConversationTile(Map<String, dynamic> conv) {
    final int unread = conv['unread'] as int;
    final bool isOnline = conv['online'] as bool;
    final Color accent = conv['color'] as Color;
    final bool isGroup = conv['type'] == 'group';

    return Bounceable(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TeacherChatDetailScreen(conversation: conv),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: unread > 0
              ? const Color(0xFF0D3B66).withValues(alpha: 0.03)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: unread > 0
              ? Border.all(
                  color: const Color(0xFF4A90E2).withValues(alpha: 0.15),
                  width: 1.5,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [accent, accent.withValues(alpha: 0.6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: accent.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    isGroup ? Icons.groups_rounded : Icons.person_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                if (isOnline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: const Color(0xFF50E3C2),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.5),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conv['name'] as String,
                          style: GoogleFonts.outfit(
                            fontWeight: unread > 0
                                ? FontWeight.bold
                                : FontWeight.w600,
                            fontSize: 15,
                            color: const Color(0xFF0D3B66),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        conv['time'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: unread > 0
                              ? const Color(0xFF4A90E2)
                              : Colors.grey.shade400,
                          fontWeight: unread > 0
                              ? FontWeight.bold
                              : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    conv['subject'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conv['message'] as String,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: unread > 0
                                ? const Color(0xFF0D3B66)
                                : Colors.grey.shade500,
                            fontWeight: unread > 0
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (unread > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF95738),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$unread',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComposeSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'New Message',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0D3B66),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F6F8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  style: GoogleFonts.inter(color: const Color(0xFF0D3B66)),
                  decoration: InputDecoration(
                    hintText: 'Search student, parent, or group...',
                    hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
                    prefixIcon: const Icon(Icons.search_rounded),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _conversations.length,
                itemBuilder: (context, i) {
                  final c = _conversations[i];
                  return ListTile(
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: (c['color'] as Color).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        c['avatar'] as IconData,
                        color: c['color'] as Color,
                      ),
                    ),
                    title: Text(
                      c['name'] as String,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0D3B66),
                      ),
                    ),
                    subtitle: Text(
                      c['subject'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              TeacherChatDetailScreen(conversation: c),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// TEACHER CHAT DETAIL SCREEN
// =============================================================================
class TeacherChatDetailScreen extends StatefulWidget {
  final Map<String, dynamic> conversation;
  const TeacherChatDetailScreen({super.key, required this.conversation});

  @override
  State<TeacherChatDetailScreen> createState() =>
      _TeacherChatDetailScreenState();
}

class _TeacherChatDetailScreenState extends State<TeacherChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Good morning! I wanted to discuss something with you.',
      'isMe': false,
      'time': '9:00 AM',
    },
    {
      'text': 'Of course! What would you like to talk about?',
      'isMe': true,
      'time': '9:02 AM',
    },
    {
      'text': 'It\'s about the upcoming test schedule and materials.',
      'isMe': false,
      'time': '9:03 AM',
    },
    {
      'text': 'I\'ll share the review guide with the class today.',
      'isMe': true,
      'time': '9:05 AM',
    },
    {
      'text': 'That would be very helpful. Thank you so much!',
      'isMe': false,
      'time': '9:06 AM',
    },
    {
      'text':
          'No problem! I\'ll also post extra practice problems on the portal.',
      'isMe': true,
      'time': '9:08 AM',
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color accent = widget.conversation['color'] as Color;
    final bool isGroup = widget.conversation['type'] == 'group';

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F8),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20,
                      color: Color(0xFF0D3B66),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [accent, accent.withValues(alpha: 0.6)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      isGroup ? Icons.groups_rounded : Icons.person_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.conversation['name'] as String,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: const Color(0xFF0D3B66),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          widget.conversation['online'] == true
                              ? 'Online'
                              : widget.conversation['subject'] as String,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: widget.conversation['online'] == true
                                ? const Color(0xFF50E3C2)
                                : Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.videocam_rounded,
                      color: Color(0xFF0D3B66),
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.more_vert_rounded,
                      color: Color(0xFF0D3B66),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final bool isMe = msg['isMe'] as bool;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: isMe
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (!isMe) ...[
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person_rounded,
                            size: 18,
                            color: accent,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isMe
                                ? const Color(0xFF0D3B66)
                                : Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(20),
                              topRight: const Radius.circular(20),
                              bottomLeft: Radius.circular(isMe ? 20 : 4),
                              bottomRight: Radius.circular(isMe ? 4 : 20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                msg['text'] as String,
                                style: GoogleFonts.inter(
                                  color: isMe
                                      ? Colors.white
                                      : const Color(0xFF0D3B66),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                msg['time'] as String,
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: isMe
                                      ? Colors.white.withValues(alpha: 0.6)
                                      : Colors.grey.shade400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isMe) const SizedBox(width: 40),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F6F8),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.attach_file_rounded,
                    color: Color(0xFF0D3B66),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F6F8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _messageController,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF0D3B66),
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: GoogleFonts.inter(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Bounceable(
                  onTap: () {
                    final text = _messageController.text.trim();
                    if (text.isNotEmpty) {
                      setState(() {
                        _messages.add({
                          'text': text,
                          'isMe': true,
                          'time': 'Now',
                        });
                        _messageController.clear();
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0D3B66), Color(0xFF1E5B94)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0D3B66).withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
