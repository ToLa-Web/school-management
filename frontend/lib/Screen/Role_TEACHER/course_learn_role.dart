import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tamdansers/Screen/Role_TEACHER/add_course_role.dart';
import 'package:tamdansers/model/course_model.dart';
import 'package:tamdansers/services/api_service.dart';
import 'package:tamdansers/services/api_models.dart';

class TeacherCourseScreen extends StatefulWidget {
  const TeacherCourseScreen({super.key});

  @override
  State<TeacherCourseScreen> createState() => _TeacherCourseScreenState();
}

class _TeacherCourseScreenState extends State<TeacherCourseScreen> {
  final Color _darkBlue = const Color(0xFF0F172A);
  final Color _subtleBg = const Color(0xFFFBFDFF);

  final ApiService _api = ApiService();
  List<SubjectDto> _apiSubjects = [];
  bool _loadingSubjects = false;

  @override
  void initState() {
    super.initState();
    _fetchSubjects();
    // Ensuring there is at least one default data point for a clean first look
    if (globalCourses.isEmpty) {
      globalCourses.add(
        Course(
          title: "Introduction to Contemporary Dance",
          subject: "Arts",
          grade: "Level 1",
          price: 25.00,
          description:
              "Master the basics of rhythmic movement and fluid expression.",
          startDate: DateTime.now(),
        ),
      );
    }
  }

  Future<void> _fetchSubjects() async {
    setState(() => _loadingSubjects = true);
    try {
      final subjects = await _api.getSubjects();
      if (mounted) setState(() => _apiSubjects = subjects);
    } catch (_) {}
    if (mounted) setState(() => _loadingSubjects = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _subtleBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Sleek, floating-style AppBar
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            elevation: 0,
            stretch: true,
            backgroundColor: _subtleBg.withValues(alpha: 0.9),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              title: Text(
                "Management",
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w800,
                  color: _darkBlue,
                  fontSize: 22,
                ),
              ),
            ),
            actions: [
              _buildAppBarIcon(Icons.search_rounded),
              _buildAppBarIcon(Icons.notifications_none_rounded),
              const SizedBox(width: 16),
            ],
          ),

          // Course List
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
            sliver: _loadingSubjects
                ? const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                : _apiSubjects.isNotEmpty
                    ? SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) =>
                              _buildSubjectCard(_apiSubjects[index]),
                          childCount: _apiSubjects.length,
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final course = globalCourses[index];
                          return _buildModernCourseCard(course);
                        }, childCount: globalCourses.length),
                      ),
          ),
        ],
      ),
      floatingActionButton: _buildPremiumFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildAppBarIcon(IconData icon) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: IconButton(
        icon: Icon(icon, color: _darkBlue, size: 20),
        onPressed: () {},
      ),
    );
  }

  Widget _buildSubjectCard(SubjectDto subject) {
    const colors = [
      Color(0xFF3B82F6), Color(0xFF8B5CF6), Color(0xFF10B981),
      Color(0xFFF59E0B), Color(0xFFEC4899), Color(0xFFEF4444),
    ];
    final color = colors[subject.subjectName.hashCode.abs() % colors.length];
    return Bounceable(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.grey.shade50),
          boxShadow: [
            BoxShadow(
              color: _darkBlue.withValues(alpha: 0.03),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    subject.subjectName.toUpperCase(),
                    style: GoogleFonts.plusJakartaSans(
                      color: color,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const Spacer(),
                CircleAvatar(
                  radius: 3,
                  backgroundColor: subject.isActive
                      ? const Color(0xFF10B981)
                      : Colors.grey,
                ),
                const SizedBox(width: 6),
                Text(
                  subject.isActive ? 'Active' : 'Inactive',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: subject.isActive
                        ? const Color(0xFF10B981)
                        : Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              subject.subjectName,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: _darkBlue,
              ),
            ),
            if (subject.teacherNames.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Teachers: ${subject.teacherNames.join(', ')}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.grey.shade500,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildModernCourseCard(Course course) {
    return Bounceable(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.grey.shade50),
          boxShadow: [
            BoxShadow(
              color: _darkBlue.withValues(alpha: 0.03),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Mini Subject Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _darkBlue.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    course.subject.toUpperCase(),
                    style: GoogleFonts.plusJakartaSans(
                      color: _darkBlue,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const Spacer(),
                // Status indicator
                const CircleAvatar(
                  radius: 3,
                  backgroundColor: Color(0xFF10B981),
                ),
                const SizedBox(width: 6),
                Text(
                  "Active",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              course.title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: _darkBlue,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              course.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.grey.shade500,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Divider(height: 1, color: Color(0xFFF1F5F9)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ENROLLMENT FEE",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    Text(
                      "\$${course.price.toStringAsFixed(2)}",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: _darkBlue,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _darkBlue,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    course.grade,
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
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

  Widget _buildPremiumFAB() {
    return Bounceable(
      onTap: () async {
        // 1. Navigate to the Add Course screen and wait for the result
        // We use 'await' so the code pauses here until the user returns.
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddCourse()),
        );

        // 2. The critical check:
        // If the user clicked the 'Back Arrow', result will be NULL.
        // If the user clicked 'Save/Publish', result will be a Course object.
        if (result != null && result is Course) {
          setState(() {
            // We insert at index 0 so the newest course appears at the top
            globalCourses.insert(0, result);
          });

          // Optional: Show a success snackbar for better UX
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("${result.title} added successfully!"),
              behavior: SnackBarBehavior.floating,
              backgroundColor: const Color(0xFF10B981),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      },
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 28),
        decoration: BoxDecoration(
          color: _darkBlue,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: _darkBlue.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add_rounded, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Text(
              "Create Course",
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
