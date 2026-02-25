import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tamdansers/services/api_service.dart';

class ClassCourseStudentScreen extends StatefulWidget {
  const ClassCourseStudentScreen({super.key});

  @override
  State<ClassCourseStudentScreen> createState() =>
      _ClassCourseStudentScreenState();
}

class _ClassCourseStudentScreenState extends State<ClassCourseStudentScreen> {
  List<Map<String, dynamic>> _allCourses = [];
  List<Map<String, dynamic>> _foundCourses = [];
  bool _isLoading = true;

  // Color and icon palette for subjects
  static const List<Color> _palette = [
    Color(0xFF4A90E2), Color(0xFFFFB75E), Color(0xFF50E3C2),
    Color(0xFFB86DFF), Color(0xFFF95738), Color(0xFF4A4A4A),
    Color(0xFFFF6B6B), Color(0xFF0D3B66),
  ];

  static IconData _iconForSubject(String name) {
    final n = name.toLowerCase();
    if (n.contains('math')) return Icons.calculate_rounded;
    if (n.contains('phys')) return Icons.bolt_rounded;
    if (n.contains('chem')) return Icons.science_rounded;
    if (n.contains('bio'))  return Icons.biotech_rounded;
    if (n.contains('hist')) return Icons.museum_rounded;
    if (n.contains('eng'))  return Icons.translate_rounded;
    if (n.contains('comp') || n.contains('it')) return Icons.computer_rounded;
    if (n.contains('art'))  return Icons.palette_rounded;
    if (n.contains('khmer') || n.contains('kh')) return Icons.menu_book_rounded;
    return Icons.book_rounded;
  }

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    try {
      final subjects = await ApiService().getSubjects();
      final courses = subjects.asMap().entries.map((e) {
        final sub = e.value;
        final idx = e.key;
        final teacher = sub.teacherNames.isNotEmpty ? sub.teacherNames.first : '';
        return {
          'title':    sub.subjectName,
          'lessons':  teacher.isNotEmpty ? 'by $teacher' : 'No teacher assigned',
          'progress': 0.0,
          'percent':  '—',
          'color':    _palette[idx % _palette.length],
          'icon':     _iconForSubject(sub.subjectName),
        };
      }).toList();
      if (mounted) {
        setState(() {
          _allCourses   = courses;
          _foundCourses = courses;
          _isLoading    = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _runFilter(String enteredKeyword) {
    setState(() {
      _foundCourses = _allCourses
          .where((c) => (c['title'] as String)
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F8),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 140.0,
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: const Color(0xFFF3F6F8),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Color(0xFF0D3B66),
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 18,
              ),
              title: Text(
                'My Learning',
                style: GoogleFonts.outfit(
                  color: const Color(0xFF0D3B66),
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: _buildModernSearchBar(),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: _isLoading
                ? SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(48.0),
                        child: CircularProgressIndicator(
                          color: const Color(0xFF0D3B66),
                        ),
                      ),
                    ),
                  )
                : _foundCourses.isEmpty
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(48.0),
                            child: Text(
                              'No subjects found.',
                              style: GoogleFonts.inter(color: Colors.grey),
                            ),
                          ),
                        ),
                      )
                    : SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) =>
                    _buildModernCourseCard(_foundCourses[index]),
                childCount: _foundCourses.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: TextField(
        onChanged: _runFilter,
        style: GoogleFonts.inter(
          color: const Color(0xFF0D3B66),
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: 'Search subjects...',
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
            vertical: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildModernCourseCard(Map<String, dynamic> course) {
    return Bounceable(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LessonDetailScreen(course: course),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Hero(
                tag: 'icon_${course['title']}',
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: course['color'].withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Icon(course['icon'], color: course['color'], size: 32),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course['title'],
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: const Color(0xFF0D3B66),
                      ),
                    ),
                    const SizedBox(height: 6),
                    _buildModernProgressBar(course),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F6F8),
                  borderRadius: BorderRadius.circular(14),
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

  Widget _buildModernProgressBar(Map<String, dynamic> course) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              course['lessons'],
              style: GoogleFonts.inter(
                color: Colors.grey.shade500,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              course['percent'],
              style: GoogleFonts.inter(
                color: course['color'],
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: course['progress'],
            backgroundColor: const Color(0xFFF3F6F8),
            color: course['color'],
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}

// --- MODERN DETAIL SCREEN ---

class LessonDetailScreen extends StatelessWidget {
  final Map<String, dynamic> course;
  const LessonDetailScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final Color themeColor = course['color'];

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F8),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            elevation: 0,
            backgroundColor: themeColor,
            leading: Bounceable(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [themeColor, themeColor.withValues(alpha: 0.8)],
                  ),
                ),
                child: Center(
                  child: Hero(
                    tag: 'icon_${course['title']}',
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        course['icon'],
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              title: Text(
                course['title'],
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
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
                        Text(
                          "Course Overview",
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0D3B66),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Total duration: 4h 32m • ${course['lessons']}",
                          style: GoogleFonts.inter(
                            color: Colors.grey.shade500,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Completion",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF0D3B66),
                              ),
                            ),
                            Text(
                              course['percent'],
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: themeColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: course['progress'],
                            minHeight: 10,
                            backgroundColor: const Color(0xFFF3F6F8),
                            color: themeColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 35),
                  Text(
                    "Curriculum",
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D3B66),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildModernLessonItem(
                    1,
                    "Course Overview",
                    "12:00",
                    true,
                    themeColor,
                  ),
                  _buildModernLessonItem(
                    2,
                    "Fundamentals & Logic",
                    "45:30",
                    true,
                    themeColor,
                  ),
                  _buildModernLessonItem(
                    3,
                    "Deep Dive: Advanced Theory",
                    "22:15",
                    false,
                    themeColor,
                  ),
                  _buildModernLessonItem(
                    4,
                    "Interactive Workshop",
                    "15:00",
                    false,
                    themeColor,
                  ),
                  _buildModernLockedLesson(5, "Final Examination"),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernLessonItem(
    int index,
    String title,
    String time,
    bool isDone,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDone ? color.withValues(alpha: 0.3) : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: [
          if (!isDone)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: isDone ? color : color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isDone
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 22,
                    )
                  : Text(
                      "$index",
                      style: GoogleFonts.outfit(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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
                  title,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: const Color(0xFF0D3B66),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      time,
                      style: GoogleFonts.inter(
                        color: Colors.grey.shade500,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Bounceable(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDone
                    ? color.withValues(alpha: 0.1)
                    : const Color(0xFFF3F6F8),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_arrow_rounded,
                color: isDone ? color : Colors.grey.shade400,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernLockedLesson(int index, String title) {
    return Opacity(
      opacity: 0.6,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F6F8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            Icon(
              Icons.lock_outline_rounded,
              color: Colors.grey.shade400,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
