import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:tamdansers/Screen/Edit-Profile/teacher_edit_profile.dart';
import 'package:tamdansers/Screen/Role_TEACHER/add_student_role.dart';
import 'package:tamdansers/Screen/Role_TEACHER/create_class_role.dart';
import 'package:tamdansers/Screen/Role_TEACHER/student_list_screen.dart';
import 'package:tamdansers/services/api_service.dart';
import 'package:tamdansers/services/api_models.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(),
        scaffoldBackgroundColor: const Color(0xFFF3F6F8),
      ),
      home: const TeacherManagementClassScreen(),
    ),
  );
}

// ----------------------------------------------------------------------
// 1. MAIN NAVIGATION WRAPPER
// ----------------------------------------------------------------------
class TeacherManagementClassScreen extends StatefulWidget {
  const TeacherManagementClassScreen({super.key});

  @override
  State<TeacherManagementClassScreen> createState() =>
      _TeacherManagementClassScreenState();
}

class _TeacherManagementClassScreenState
    extends State<TeacherManagementClassScreen> {
  int _pageIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  // Screens for the Bottom Navigation Bar
  final List<Widget> _screens = [
    const TeacherManagementHomeContent(),
    const StudentListScreen(),
    const AddStudentScreen(),
    const TeacherEditProfileScreen(),
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
          Icon(Icons.class_rounded, size: 28, color: Colors.white),
          Icon(Icons.people_rounded, size: 28, color: Colors.white),
          Icon(Icons.person_add_rounded, size: 28, color: Colors.white),
          Icon(Icons.settings_rounded, size: 28, color: Colors.white),
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
// 2. HOME CONTENT (With Search and Filter Logic)
// ----------------------------------------------------------------------
class TeacherManagementHomeContent extends StatefulWidget {
  const TeacherManagementHomeContent({super.key});

  @override
  State<TeacherManagementHomeContent> createState() =>
      _TeacherManagementHomeContentState();
}

class _TeacherManagementHomeContentState
    extends State<TeacherManagementHomeContent> {
  List<ClassroomDto> _allClassrooms = [];
  bool _isLoading = true;

  String _searchQuery = "";
  String _selectedGradeFilter = "All";
  String? _myTeacherId;
  String? _myTeacherName;

  @override
  void initState() {
    super.initState();
    _loadClassrooms();
  }

  Future<void> _loadClassrooms() async {
    try {
      final api = ApiService();
      final entityId = await api.getEntityId();
      final results = await Future.wait([
        api.getClassrooms(),
        if (entityId != null) api.getTeacherById(entityId) else Future.value(null),
      ]);
      if (mounted) {
        final teacher = results[1] as dynamic;
        setState(() {
          _allClassrooms = results[0] as List<ClassroomDto>;
          _myTeacherId = entityId;
          _myTeacherName = teacher != null ? teacher.fullName as String? : null;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredClasses = _allClassrooms.where((c) {
      final query = _searchQuery.toLowerCase();
      final resolvedTeacher = (c.teacherName != null && c.teacherName!.isNotEmpty)
          ? c.teacherName!
          : (c.teacherId != null && c.teacherId == _myTeacherId && _myTeacherName != null)
              ? _myTeacherName!
              : '';
      final matchesSearch = c.name.toLowerCase().contains(query) ||
          resolvedTeacher.toLowerCase().contains(query);
      // c.grade is stored as just a number e.g. "10", filter label is "Grade 10"
      final gradeNumber = _selectedGradeFilter == "All"
          ? ""
          : _selectedGradeFilter.replaceAll('Grade ', '').trim();
      final matchesGrade = _selectedGradeFilter == "All" ||
          (c.grade ?? '').trim() == gradeNumber ||
          c.name.contains(gradeNumber);
      return matchesSearch && matchesGrade;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF0D3B66),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Manage Classes',
          style: GoogleFonts.outfit(
            color: const Color(0xFF0D3B66),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Color(0xFF0D3B66),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          // Search and Add Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search by grade or teacher...',
                        hintStyle: GoogleFonts.inter(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Bounceable(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateClassScreen(),
                      ),
                    );
                    if (result == true) _loadClassrooms();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF95738),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFF95738).withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children:
                  [
                    'All',
                    'Grade 12',
                    'Grade 11',
                    'Grade 10',
                    'Grade 9',
                    'Grade 8',
                    'Grade 7',
                  ].map((label) {
                    bool isSelected = _selectedGradeFilter == label;
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Bounceable(
                        onTap: () {
                          setState(() {
                            _selectedGradeFilter = isSelected ? "All" : label;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF0D3B66)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF0D3B66)
                                  : Colors.grey.shade200,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF0D3B66,
                                      ).withValues(alpha: 0.2),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Text(
                            label,
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
                    );
                  }).toList(),
            ),
          ),
          const SizedBox(height: 10),
          // Classroom List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredClasses.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 60,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "No classes found.",
                              style: GoogleFonts.inter(color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(24),
                        itemCount: filteredClasses.length,
                        itemBuilder: (context, index) {
                          final c = filteredClasses[index];
                          final List<Color> cardColors = [
                            const Color(0xFF4A90E2),
                            const Color(0xFF50E3C2),
                            const Color(0xFFB86DFF),
                            const Color(0xFFF5A623),
                          ];
                          final Color cardColor =
                              cardColors[index % cardColors.length];

                          final resolvedTeacher = (c.teacherName != null && c.teacherName!.isNotEmpty)
                              ? c.teacherName!
                              : (c.teacherId != null && c.teacherId == _myTeacherId && _myTeacherName != null)
                                  ? _myTeacherName!
                                  : 'No teacher';
                          return Bounceable(
                            onTap: () {},
                            child: ModernClassCard(
                              grade: c.name,
                              teacher: resolvedTeacher,
                              students: '${c.studentCount} students',
                              accentColor: cardColor,
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------------
// 3. REUSABLE MODERN CLASS CARD
// ----------------------------------------------------------------------
class ModernClassCard extends StatelessWidget {
  final String grade;
  final String teacher;
  final String students;
  final Color accentColor;

  const ModernClassCard({
    super.key,
    required this.grade,
    required this.teacher,
    required this.students,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accentColor.withValues(alpha: 0.85), accentColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  grade,
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.more_horiz_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: accentColor.withValues(alpha: 0.1),
                  child: Icon(
                    Icons.person_rounded,
                    color: accentColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        teacher,
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0D3B66),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Homeroom Teacher",
                        style: GoogleFonts.inter(
                          color: Colors.grey.shade500,
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
                    color: const Color(0xFFF3F6F8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.groups_rounded,
                        size: 18,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        students.split(' ')[0], // just the number
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF333333),
                        ),
                      ),
                    ],
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
