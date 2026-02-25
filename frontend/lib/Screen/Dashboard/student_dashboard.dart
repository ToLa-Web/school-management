import 'package:carousel_slider/carousel_slider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:google_fonts/google_fonts.dart';
// --- CONTROLLER & SERVICE IMPORTS ---
import 'package:tamdansers/Controller/activity_list_widget.dart';
import 'package:tamdansers/Controller/course_card_widget.dart';
import 'package:tamdansers/Screen/Edit-Profile/student_edit_profile.dart';
import 'package:tamdansers/Screen/Role_STUDENT/attendance_student_role.dart';
import 'package:tamdansers/Screen/Role_STUDENT/course_student.role.dart';
import 'package:tamdansers/Screen/Role_STUDENT/homework_student_role.dart';
import 'package:tamdansers/Screen/Role_STUDENT/notification_student_role.dart';
import 'package:tamdansers/Screen/Role_STUDENT/permision_student_role.dart';
import 'package:tamdansers/Screen/Role_STUDENT/schedule_student_role.dart';
import 'package:tamdansers/Screen/Role_STUDENT/score_student_role.dart';
import 'package:tamdansers/constants/app_image.dart';
import 'package:tamdansers/services/api_service.dart';

// =============================================================================
// MAIN DASHBOARD
// =============================================================================
class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _pageIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const StudentHomeContent(),
      const StudentCoursesTab(),
      const StudentMessagesTab(),
      StudentEditProfileScreen(onBack: () => setState(() => _pageIndex = 0)),
    ];
  }

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
          Icon(Icons.person_outline_rounded, size: 28, color: Colors.white),
        ],
        color: const Color(0xFF0D3B66), // Deep professional blue
        buttonBackgroundColor: const Color(0xFFF95738), // Vibrant Accent
        backgroundColor: const Color(0xFFF3F6F8),
        animationCurve: Curves.easeInOutCubic,
        animationDuration: const Duration(milliseconds: 400),
        onTap: (index) => setState(() => _pageIndex = index),
      ),
    );
  }
}

// =============================================================================
// STUDENT HOME CONTENT
// =============================================================================
class StudentHomeContent extends StatefulWidget {
  const StudentHomeContent({super.key});

  @override
  State<StudentHomeContent> createState() => _StudentHomeContentState();
}

class _StudentHomeContentState extends State<StudentHomeContent> {
  String _userName = '';
  int _currentCarouselIndex = 0;
  final ApiService _api = ApiService();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final name = await _api.getUserName();
    if (mounted) setState(() => _userName = name ?? 'Student');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            _buildModernHeader(context),
            const SizedBox(height: 35),

            _buildModernSectionTitle("Academic Options"),
            const SizedBox(height: 20),
            _buildModernGridMenu(context),
            const SizedBox(height: 35),

            // PROGRESS SECTION
            _buildModernSectionTitle(
              "Current Progress",
              actionText: "View All",
              onActionTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AllProgressScreen(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Bounceable(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CourseDetailScreen(
                    title: "Advanced Mathematics II",
                    progress: 0.75,
                  ),
                ),
              ),
              child: const CourseProgressCard(
                title: "Advanced Mathematics II",
                subtitle: "28 lessons • 112 exercises",
                progress: 0.75,
                percentage: "75%",
                imagePath: AppImages.subjectMath,
              ),
            ),

            const SizedBox(height: 40),
            // EVENTS SECTION
            _buildModernSectionTitle(
              "School Events",
              actionText: "See All",
              onActionTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SchoolEventsListScreen(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildEnhancedActivitySlider(),

            const SizedBox(height: 40),
            _buildModernSectionTitle(
              "Recent Activity",
              actionText: "View All",
              onActionTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AllActivityScreen(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const ActivityList(limit: 2),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildModernHeader(BuildContext context) {
    return Row(
      children: [
        Bounceable(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const StudentEditProfileScreen(),
            ),
          ),
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
                backgroundImage: AssetImage(AppImages.userProfile),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome back,",
              style: GoogleFonts.inter(
                color: Colors.grey.shade500,
                fontSize: 13,
                fontWeight: FontWeight.w600,
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
            ),
          ],
        ),
        const Spacer(),
        Bounceable(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NotificationScreen()),
          ),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Stack(
              children: [
                Icon(
                  Icons.notifications_none_rounded,
                  color: Color(0xFF0D3B66),
                  size: 26,
                ),
                Positioned(
                  right: 2,
                  top: 2,
                  child: CircleAvatar(
                    radius: 4,
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

  Widget _buildModernSectionTitle(
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
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: const Color(0xFF0D3B66),
          ),
        ),
        if (actionText != null)
          Bounceable(
            onTap: onActionTap ?? () {},
            child: Text(
              actionText,
              style: GoogleFonts.inter(
                color: const Color(0xFF4A90E2),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildModernGridMenu(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 0.85,
      children: [
        _buildModernMenuIcon(
          context,
          Icons.calendar_month_rounded,
          "Attendance",
          const Color(0xFFFFB75E),
          const AttendanceDashboard(),
        ),
        _buildModernMenuIcon(
          context,
          Icons.analytics_rounded,
          "Scores",
          const Color(0xFF50E3C2),
          const StudentScoreScreen(),
        ),
        _buildModernMenuIcon(
          context,
          Icons.assignment_ind_rounded,
          "Permission",
          const Color(0xFF4A90E2),
          const StudentPermissionScreen(),
        ),
        _buildModernMenuIcon(
          context,
          Icons.history_edu_rounded,
          "Homework",
          const Color(0xFFB86DFF),
          const StudentHomeworkScreen(),
        ),
        _buildModernMenuIcon(
          context,
          Icons.timer_rounded,
          "Schedule",
          const Color(0xFFF95738),
          const StudentScheduleScreen(),
        ),
        _buildModernMenuIcon(
          context,
          Icons.menu_book_rounded,
          "Course",
          const Color(0xFF4A90E2),
          const ClassCourseStudentScreen(),
        ),
      ],
    );
  }

  Widget _buildModernMenuIcon(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    Widget screen,
  ) {
    return Bounceable(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.15),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0D3B66),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ENHANCED CAROUSEL SLIDER
  Widget _buildEnhancedActivitySlider() {
    final List<Map<String, dynamic>> events = [
      {
        "title": "Annual Sports Day",
        "date": "14 Oct 2026",
        "time": "10:00 AM - 4:00 PM",
        "location": "School Grounds",
        "img": AppImages.event1,
        "category": "Sports",
        "attendees": 245,
        "description":
            "Join us for a day of athletic excellence and teamwork! Featuring track & field events, team sports, and fun activities for everyone.",
      },
      {
        "title": "Tech Exhibition",
        "date": "20 Oct 2026",
        "time": "9:00 AM - 3:00 PM",
        "location": "Innovation Lab",
        "img": AppImages.event2,
        "category": "Technology",
        "attendees": 189,
        "description":
            "Showcasing the latest student innovations in robotics, software development, and engineering projects.",
      },
      {
        "title": "Science Fair 2026",
        "date": "12 Nov 2026",
        "time": "11:00 AM - 5:00 PM",
        "location": "Science Hall",
        "img": AppImages.event3,
        "category": "Science",
        "attendees": 312,
        "description":
            "Explore groundbreaking experiments and discoveries presented by our talented young scientists.",
      },
      {
        "title": "Music Festival",
        "date": "05 Dec 2026",
        "time": "2:00 PM - 8:00 PM",
        "location": "Auditorium",
        "img": AppImages.grade1,
        "category": "Arts",
        "attendees": 450,
        "description":
            "A celebration of student musical talent featuring bands, choirs, and solo performances.",
      },
    ];

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: events.length,
          itemBuilder: (context, index, realIndex) {
            final event = events[index];
            return Bounceable(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetailScreen(event: event),
                ),
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                      spreadRadius: 2,
                    ),
                  ],
                  image: DecorationImage(
                    image: AssetImage(event["img"]),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    // Dark overlay gradient
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.3),
                            Colors.black.withValues(alpha: 0.8),
                          ],
                          stops: const [0.3, 0.7, 1.0],
                        ),
                      ),
                    ),

                    // Category badge
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(event["category"]),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: _getCategoryColor(
                                event["category"],
                              ).withValues(alpha: 0.5),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          event["category"],
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    // Event details at bottom
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(28),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.9),
                            ],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event["title"],
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                letterSpacing: -0.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),

                            // Date and time row
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.calendar_month_rounded,
                                    color: Colors.white70,
                                    size: 14,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "${event["date"]} • ${event["time"]}",
                                    style: GoogleFonts.inter(
                                      color: Colors.white70,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),

                            // Location and attendees row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.location_on_rounded,
                                          color: Colors.white70,
                                          size: 14,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          event["location"],
                                          style: GoogleFonts.inter(
                                            color: Colors.white70,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Attendees count
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFFF95738,
                                    ).withValues(alpha: 0.8),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.people_rounded,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "${event["attendees"]}",
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
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
                  ],
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: 300,
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            pauseAutoPlayOnTouch: true,
            viewportFraction: 0.85,
            enlargeFactor: 0.2,
            onPageChanged: (index, reason) {
              setState(() {
                _currentCarouselIndex = index;
              });
            },
          ),
        ),

        // Custom page indicator
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: events.asMap().entries.map((entry) {
            return Container(
              width: 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(
                  0xFF0D3B66,
                ).withValues(alpha: entry.key == _currentCarouselIndex ? 1 : 0.3),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Helper method for category colors
  Color _getCategoryColor(String category) {
    switch (category) {
      case "Sports":
        return const Color(0xFFFFB75E);
      case "Technology":
        return const Color(0xFF4A90E2);
      case "Science":
        return const Color(0xFF50E3C2);
      case "Arts":
        return const Color(0xFFB86DFF);
      default:
        return const Color(0xFFF95738);
    }
  }
}

// =============================================================================
// PROGRESS SCREENS
// =============================================================================
class AllProgressScreen extends StatelessWidget {
  const AllProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> courses = [
      {"title": "Advanced Mathematics II", "sub": "28 lessons", "prog": 0.75},
      {"title": "Quantum Physics", "sub": "18 lessons", "prog": 0.45},
      {"title": "World History", "sub": "22 lessons", "prog": 0.90},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F8),
      appBar: AppBar(
        title: Text(
          "All Course Progress",
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0D3B66),
          ),
        ),
        foregroundColor: const Color(0xFF0D3B66),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Bounceable(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseDetailScreen(
                    title: course["title"] as String,
                    progress: course["prog"] as double,
                  ),
                ),
              ),
              child: CourseProgressCard(
                title: course["title"] as String,
                subtitle: course["sub"] as String,
                progress: course["prog"] as double,
                percentage: "${((course["prog"] as double) * 100).toInt()}%",
                imagePath: AppImages.subjectMath,
              ),
            ),
          );
        },
      ),
    );
  }
}

class CourseDetailScreen extends StatelessWidget {
  final String title;
  final double progress;

  const CourseDetailScreen({
    super.key,
    required this.title,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F8),
      appBar: AppBar(
        title: Text(
          title,
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF0D3B66),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
                image: const DecorationImage(
                  image: AssetImage(AppImages.subjectMath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Course Completion",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      Text(
                        "${(progress * 100).toInt()}%",
                        style: GoogleFonts.outfit(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF50E3C2),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 12,
                      color: const Color(0xFF50E3C2),
                      backgroundColor: Colors.grey.shade100,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Text(
              "Course Curriculum",
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0D3B66),
              ),
            ),
            const SizedBox(height: 16),
            _buildModernLessonTile("Chapter 1: Foundations", true),
            _buildModernLessonTile("Chapter 2: Intermediate Concepts", true),
            _buildModernLessonTile("Chapter 3: Final Assessment", false),
          ],
        ),
      ),
    );
  }

  Widget _buildModernLessonTile(String title, bool isCompleted) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted
              ? const Color(0xFF50E3C2).withValues(alpha: 0.5)
              : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isCompleted
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            color: isCompleted ? const Color(0xFF50E3C2) : Colors.grey.shade400,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontWeight: isCompleted ? FontWeight.bold : FontWeight.w500,
                color: isCompleted
                    ? const Color(0xFF0D3B66)
                    : Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// EVENT SCREENS
// =============================================================================
class SchoolEventsListScreen extends StatelessWidget {
  const SchoolEventsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> events = [
      {
        "title": "Annual Sports Day",
        "date": "14 Oct 2026",
        "time": "10:00 AM - 4:00 PM",
        "location": "School Grounds",
        "img": AppImages.event1,
        "category": "Sports",
        "attendees": 245,
        "description":
            "Join us for a day of athletic excellence and teamwork! Featuring track & field events, team sports, and fun activities for everyone.",
      },
      {
        "title": "Tech Exhibition",
        "date": "20 Oct 2026",
        "time": "9:00 AM - 3:00 PM",
        "location": "Innovation Lab",
        "img": AppImages.event2,
        "category": "Technology",
        "attendees": 189,
        "description":
            "Showcasing the latest student innovations in robotics, software development, and engineering projects.",
      },
      {
        "title": "Science Fair 2026",
        "date": "12 Nov 2026",
        "time": "11:00 AM - 5:00 PM",
        "location": "Science Hall",
        "img": AppImages.event3,
        "category": "Science",
        "attendees": 312,
        "description":
            "Explore groundbreaking experiments and discoveries presented by our talented young scientists.",
      },
      {
        "title": "Music Festival",
        "date": "05 Dec 2026",
        "time": "2:00 PM - 8:00 PM",
        "location": "Auditorium",
        "img": AppImages.grade1,
        "category": "Arts",
        "attendees": 450,
        "description":
            "A celebration of student musical talent featuring bands, choirs, and solo performances.",
      },
      {
        "title": "Charity Auction",
        "date": "15 Dec 2026",
        "time": "6:00 PM - 9:00 PM",
        "location": "Main Hall",
        "img": AppImages.event1,
        "category": "Fundraising",
        "attendees": 150,
        "description":
            "Raising funds for local community projects. Come bid on amazing items donated by local businesses.",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F8),
      appBar: AppBar(
        title: Text(
          "Upcoming Events",
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0D3B66),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF0D3B66),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        itemCount: events.length,
        itemBuilder: (context, index) => Bounceable(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailScreen(event: events[index]),
            ),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                      child: Image.asset(
                        events[index]["img"],
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(events[index]["category"]),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          events[index]["category"],
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              events[index]["title"],
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: const Color(0xFF0D3B66),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_month_rounded,
                                  size: 14,
                                  color: Color(0xFFF95738),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  events[index]["date"],
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFFF95738),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Icon(
                                  Icons.access_time_rounded,
                                  size: 14,
                                  color: Color(0xFF4A90E2),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  events[index]["time"].split(" - ")[0],
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF4A90E2),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
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
                          size: 14,
                          color: Color(0xFF0D3B66),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case "Sports":
        return const Color(0xFFFFB75E);
      case "Technology":
        return const Color(0xFF4A90E2);
      case "Science":
        return const Color(0xFF50E3C2);
      case "Arts":
        return const Color(0xFFB86DFF);
      default:
        return const Color(0xFFF95738);
    }
  }
}

class EventDetailScreen extends StatelessWidget {
  final Map<String, dynamic> event;
  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F8),
      appBar: AppBar(
        title: Text(
          event["title"],
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        foregroundColor: const Color(0xFF0D3B66),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  event["img"],
                  height: 280,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(event["category"]),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: _getCategoryColor(
                            event["category"],
                          ).withValues(alpha: 0.5),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      event["category"],
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              transform: Matrix4.translationValues(0.0, -30.0, 0.0),
              padding: const EdgeInsets.all(30),
              decoration: const BoxDecoration(
                color: Color(0xFFF3F6F8),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event stats row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoChip(
                        Icons.calendar_month_rounded,
                        event["date"],
                        const Color(0xFFF95738),
                      ),
                      _buildInfoChip(
                        Icons.access_time_rounded,
                        event["time"],
                        const Color(0xFF4A90E2),
                      ),
                      _buildInfoChip(
                        Icons.location_on_rounded,
                        event["location"],
                        const Color(0xFF50E3C2),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Attendees count
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0D3B66).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.people_rounded,
                                color: Color(0xFF0D3B66),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Attendees",
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Text(
                                  "${event["attendees"]} people",
                                  style: GoogleFonts.outfit(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF0D3B66),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF50E3C2).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "${((event["attendees"] / 500) * 100).toInt()}% capacity",
                            style: GoogleFonts.inter(
                              color: const Color(0xFF50E3C2),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // About Event
                  Text(
                    "About Event",
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D3B66),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    event["description"] ?? "No description available.",
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      height: 1.6,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Register button
                  Bounceable(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Registered for ${event["title"]}"),
                          backgroundColor: const Color(0xFF0D3B66),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0D3B66), Color(0xFF1E5B94)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0D3B66).withValues(alpha: 0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "Register for Event",
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label.length > 10 ? "${label.substring(0, 8)}..." : label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case "Sports":
        return const Color(0xFFFFB75E);
      case "Technology":
        return const Color(0xFF4A90E2);
      case "Science":
        return const Color(0xFF50E3C2);
      case "Arts":
        return const Color(0xFFB86DFF);
      default:
        return const Color(0xFFF95738);
    }
  }
}

class AllActivityScreen extends StatefulWidget {
  const AllActivityScreen({super.key});

  @override
  State<AllActivityScreen> createState() => _AllActivityScreenState();
}

class _AllActivityScreenState extends State<AllActivityScreen> {
  String selectedFilter = "All";
  final List<String> filters = [
    "All",
    "Science",
    "Biology",
    "Math",
    "Literature",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F8),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 120.0,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: const Color(0xFF0D3B66),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                "Recent Activities",
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0D3B66), Color(0xFF1E5B94)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    "Track your progress",
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 45,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: filters.length,
                    itemBuilder: (context, index) {
                      final filter = filters[index];
                      final bool isSelected = selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Bounceable(
                          onTap: () => setState(() => selectedFilter = filter),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF0D3B66)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF0D3B66,
                                        ).withValues(alpha: 0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : null,
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
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: ActivityList(isDetailed: true),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// STUDENT COURSES TAB (Embedded – No AppBar Back Button)
// =============================================================================
class StudentCoursesTab extends StatefulWidget {
  const StudentCoursesTab({super.key});

  @override
  State<StudentCoursesTab> createState() => _StudentCoursesTabState();
}

class _StudentCoursesTabState extends State<StudentCoursesTab> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isLoading = true;

  final List<String> _categories = [
    'All',
    'Active',
    'Inactive',
  ];

  List<Map<String, dynamic>> _allCourses = [];

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    try {
      final classrooms = await ApiService().getClassrooms();
      final List<Color> colors = [
        const Color(0xFF4A90E2),
        const Color(0xFFFFB75E),
        const Color(0xFF50E3C2),
        const Color(0xFFB86DFF),
        const Color(0xFFF95738),
        const Color(0xFF4A4A4A),
        const Color(0xFF0D3B66),
        const Color(0xFF6C5CE7),
      ];
      final List<IconData> icons = [
        Icons.calculate_rounded,
        Icons.bolt_rounded,
        Icons.science_rounded,
        Icons.palette_rounded,
        Icons.biotech_rounded,
        Icons.museum_rounded,
        Icons.computer_rounded,
        Icons.auto_stories_rounded,
      ];
      if (mounted) {
        setState(() {
          _allCourses = classrooms.asMap().entries.map((entry) {
            final i = entry.key;
            final c = entry.value;
            return {
              'title': c.name,
              'lessons': '${c.studentCount} Students',
              'progress': 0.0,
              'percent': '${c.studentCount}',
              'color': colors[i % colors.length],
              'icon': icons[i % icons.length],
              'category': c.isActive ? 'Active' : 'Inactive',
              'teacher': c.teacherName ?? 'No teacher',
              'rating': 0.0,
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
    return _allCourses.where((c) {
      final matchCategory =
          _selectedCategory == 'All' || c['category'] == _selectedCategory;
      final matchSearch = c['title'].toString().toLowerCase().contains(
        _searchQuery,
      );
      return matchCategory && matchSearch;
    }).toList();
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
                      colors: [Color(0xFF4A90E2), Color(0xFF6FB1FC)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4A90E2).withValues(alpha: 0.3),
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
                      '${_allCourses.length} courses enrolled',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.tune_rounded,
                    color: Color(0xFF0D3B66),
                    size: 22,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Overall Progress Card ──
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
                  SizedBox(
                    height: 70,
                    width: 70,
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 70,
                          width: 70,
                          child: CircularProgressIndicator(
                            value: _allCourses.isEmpty ? 0.0 : _allCourses.where((c) => c['category'] == 'Active').length / _allCourses.length,
                            strokeWidth: 7,
                            backgroundColor: Colors.white.withValues(alpha: 0.15),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF50E3C2),
                            ),
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        Center(
                          child: Text(
                            _isLoading ? '...' : '${_allCourses.length}',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Classrooms',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${_allCourses.where((c) => c['category'] == 'Active').length} active classrooms',
                          style: GoogleFonts.inter(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF50E3C2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_allCourses.length}',
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF0D3B66),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
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
                  hintText: 'Search courses...',
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

          // ── Category Chips ──
          SizedBox(
            height: 42,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = cat == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Bounceable(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
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
                          cat,
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
                      return _buildCourseCard(course);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(Map<String, dynamic> course) {
    final Color accent = course['color'] as Color;
    return Bounceable(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LessonDetailScreen(course: course),
        ),
      ),
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
          child: Row(
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
                        fontSize: 17,
                        color: const Color(0xFF0D3B66),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline_rounded,
                          size: 14,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          course['teacher'] as String,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.star_rounded,
                          size: 14,
                          color: Color(0xFFFFB75E),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${course['rating']}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: course['progress'] as double,
                              minHeight: 6,
                              backgroundColor: const Color(0xFFF3F6F8),
                              color: accent,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          course['percent'] as String,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: accent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F6F8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Color(0xFF0D3B66),
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
// STUDENT MESSAGES TAB
// =============================================================================
class StudentMessagesTab extends StatefulWidget {
  const StudentMessagesTab({super.key});

  @override
  State<StudentMessagesTab> createState() => _StudentMessagesTabState();
}

class _StudentMessagesTabState extends State<StudentMessagesTab>
    with SingleTickerProviderStateMixin {
  late TabController _msgTabController;
  String _searchQuery = '';

  final List<Map<String, dynamic>> _conversations = [
    {
      'name': 'Mr. Johnson',
      'subject': 'Mathematics',
      'message': 'Great work on the assignment! Keep it up.',
      'time': '2m ago',
      'unread': 2,
      'online': true,
      'avatar': Icons.person,
      'color': const Color(0xFF4A90E2),
    },
    {
      'name': 'Ms. Williams',
      'subject': 'Physics',
      'message': "Don't forget to submit your lab report by Friday.",
      'time': '15m ago',
      'unread': 1,
      'online': true,
      'avatar': Icons.person,
      'color': const Color(0xFFFFB75E),
    },
    {
      'name': 'Dr. Smith',
      'subject': 'Chemistry',
      'message': 'The exam schedule has been updated.',
      'time': '1h ago',
      'unread': 0,
      'online': false,
      'avatar': Icons.person,
      'color': const Color(0xFF50E3C2),
    },
    {
      'name': 'Class Group',
      'subject': 'Grade 12-A',
      'message': 'Alex: Who has the notes from today?',
      'time': '2h ago',
      'unread': 5,
      'online': false,
      'avatar': Icons.groups_rounded,
      'color': const Color(0xFFB86DFF),
      'isGroup': true,
    },
    {
      'name': 'Ms. Davis',
      'subject': 'Art History',
      'message': 'Your project proposal is approved!',
      'time': '3h ago',
      'unread': 0,
      'online': false,
      'avatar': Icons.person,
      'color': const Color(0xFFF95738),
    },
    {
      'name': 'Study Group',
      'subject': 'Physics Lab',
      'message': 'Sarah: Meeting at 4pm tomorrow.',
      'time': '5h ago',
      'unread': 3,
      'online': false,
      'avatar': Icons.groups_rounded,
      'color': const Color(0xFF0D3B66),
      'isGroup': true,
    },
    {
      'name': 'Admin Office',
      'subject': 'School Administration',
      'message': 'Your scholarship application has been received.',
      'time': 'Yesterday',
      'unread': 0,
      'online': false,
      'avatar': Icons.admin_panel_settings_rounded,
      'color': const Color(0xFF4A4A4A),
    },
    {
      'name': 'Ms. Lee',
      'subject': 'Computer Science',
      'message': 'Check out the new tutorial I shared.',
      'time': 'Yesterday',
      'unread': 1,
      'online': true,
      'avatar': Icons.person,
      'color': const Color(0xFF6C5CE7),
    },
  ];

  List<Map<String, dynamic>> get _filteredConversations {
    if (_searchQuery.isEmpty) return _conversations;
    return _conversations
        .where(
          (c) =>
              c['name'].toString().toLowerCase().contains(_searchQuery) ||
              c['subject'].toString().toLowerCase().contains(_searchQuery) ||
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
                  const Tab(text: 'Teachers'),
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

          // ── Online Now (horizontal list) ──
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
                          (user['name'] as String).split(' ').last,
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
                _buildConversationList(_filteredConversations),
                _buildConversationList(
                  _filteredConversations
                      .where((c) => c['isGroup'] != true)
                      .toList(),
                ),
                _buildConversationList(
                  _filteredConversations
                      .where((c) => c['isGroup'] == true)
                      .toList(),
                ),
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
    final bool isGroup = conv['isGroup'] == true;

    return Bounceable(
      onTap: () => _showChatDetail(context, conv),
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
                            fontSize: 16,
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

  void _showChatDetail(BuildContext context, Map<String, dynamic> conv) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentChatDetailScreen(conversation: conv),
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
                    hintText: 'Search teacher or group...',
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
                      _showChatDetail(context, c);
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
// CHAT DETAIL SCREEN
// =============================================================================
class StudentChatDetailScreen extends StatefulWidget {
  final Map<String, dynamic> conversation;
  const StudentChatDetailScreen({super.key, required this.conversation});

  @override
  State<StudentChatDetailScreen> createState() =>
      _StudentChatDetailScreenState();
}

class _StudentChatDetailScreenState extends State<StudentChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Hello! How can I help you today?',
      'isMe': false,
      'time': '10:00 AM',
    },
    {
      'text': 'I had a question about the homework assignment.',
      'isMe': true,
      'time': '10:02 AM',
    },
    {
      'text': 'Sure! Which part are you having trouble with?',
      'isMe': false,
      'time': '10:03 AM',
    },
    {
      'text': 'Problem 3 on the derivatives section.',
      'isMe': true,
      'time': '10:05 AM',
    },
    {
      'text':
          'Great question! Let me explain the approach. You need to apply the chain rule first, then simplify using the product rule.',
      'isMe': false,
      'time': '10:06 AM',
    },
    {
      'text': 'That makes sense now, thank you!',
      'isMe': true,
      'time': '10:08 AM',
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
    final bool isGroup = widget.conversation['isGroup'] == true;

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
