import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tamdansers/services/api_service.dart';
import 'package:tamdansers/services/api_models.dart';

class StudentResultScreen extends StatefulWidget {
  const StudentResultScreen({super.key});

  @override
  State<StudentResultScreen> createState() => _StudentResultScreenState();
}

class _StudentResultScreenState extends State<StudentResultScreen> {
  final _api = ApiService();

  List<ClassroomDto> _classrooms           = [];
  List<StudentDto>   _students             = [];
  List<GradeDto>     _grades               = [];
  String?            _selectedClassroomId;
  int                _selectedStudentIndex = 0;
  bool               _isLoading            = true;
  bool               _isGradeLoading       = false;

  static const List<Color> _accentColors = [
    Color(0xFF4A90E2), Color(0xFF50E3C2), Color(0xFFB86DFF),
    Color(0xFFFF6B6B), Color(0xFFFFB75E), Color(0xFF0D3B66),
  ];

  @override
  void initState() {
    super.initState();
    _loadClassrooms();
  }

  Future<void> _loadClassrooms() async {
    try {
      final cls = await _api.getClassrooms();
      if (mounted) {
        setState(() {
          _classrooms = cls;
          if (cls.isNotEmpty) _selectedClassroomId = cls.first.id;
          _isLoading = false;
        });
        if (_selectedClassroomId != null) {
          await _loadStudents(_selectedClassroomId!);
        }
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadStudents(String classroomId) async {
    try {
      final detail = await _api.getClassroomDetail(classroomId);
      if (detail == null || !mounted) return;
      setState(() {
        _students = detail.students
            .map((cs) => StudentDto(
                  id: cs.studentId,
                  firstName: cs.firstName,
                  lastName: cs.lastName,
                  gender: null, dateOfBirth: null,
                  phone: null, address: null,
                  isActive: true, createdAt: '',
                ))
            .toList();
        _selectedStudentIndex = 0;
        _grades = [];
      });
      if (_students.isNotEmpty) {
        await _loadGrades(_students.first.id);
      }
    } catch (_) {}
  }

  Future<void> _loadGrades(String studentId) async {
    setState(() => _isGradeLoading = true);
    try {
      final g = await _api.getGrades(studentId: studentId);
      if (mounted) setState(() { _grades = g; _isGradeLoading = false; });
    } catch (_) {
      if (mounted) setState(() => _isGradeLoading = false);
    }
  }

  List<Widget> _buildGradeItems() {
    return _grades.asMap().entries.map((e) {
      final grade = e.value;
      final color = _accentColors[e.key % _accentColors.length];
      return _buildModernScoreItem(
        grade.subjectName,
        grade.semester,
        grade.score.round(),
        color,
        Icons.menu_book_rounded,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF3F6F8),
        body: Center(child: CircularProgressIndicator()),
      );
    }
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
          "Results & Rankings",
          style: GoogleFonts.outfit(
            color: const Color(0xFF0D3B66),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Classroom Dropdown
            _buildModernDropdownSelector(),
            const SizedBox(height: 30),

            Text(
              "Select Student",
              style: GoogleFonts.outfit(
                color: const Color(0xFF0D3B66),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),

            // Student Selection Carousel
            _buildModernStudentCarousel(),
            const SizedBox(height: 35),

            // Subject Scores Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Subject Scores",
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0D3B66),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Score List (dynamic from API)
            if (_isGradeLoading)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_grades.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'No grades recorded for this student.',
                  style: GoogleFonts.inter(color: Colors.grey),
                ),
              )
            else
              ..._buildGradeItems(),

            const SizedBox(height: 35),

            // Results Summary Card
            _buildModernSummaryCard(),

            const SizedBox(height: 35),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: Bounceable(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "Save Draft",
                          style: GoogleFonts.inter(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Bounceable(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0D3B66), Color(0xFF1E5B94)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0D3B66).withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Publish",
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildModernDropdownSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
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
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedClassroomId,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF0D3B66),
          ),
          style: GoogleFonts.inter(
            color: const Color(0xFF0D3B66),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          items: _classrooms.map((c) {
            return DropdownMenuItem<String>(
              value: c.id,
              child: Text(c.name),
            );
          }).toList(),
          onChanged: (newId) async {
            if (newId == null) return;
            setState(() {
              _selectedClassroomId = newId;
              _students = [];
              _grades = [];
            });
            await _loadStudents(newId);
          },
        ),
      ),
    );
  }

  Widget _buildModernStudentCarousel() {
    if (_students.isEmpty) {
      return Text(
        'No students in this class.',
        style: GoogleFonts.inter(color: Colors.grey),
      );
    }
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _students.length,
        itemBuilder: (context, index) {
          final s = _students[index];
          final selected = _selectedStudentIndex == index;
          return Bounceable(
            onTap: () {
              setState(() => _selectedStudentIndex = index);
              _loadGrades(s.id);
            },
            child: _buildModernStudentAvatar(
              '${s.firstName} ${s.lastName}',
              '',
              selected,
            ),
          );
        },
      ),
    );
  }

  Widget _buildModernStudentAvatar(String name, String gpa, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Column(
        children: [
          Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF4A90E2)
                        : Colors.transparent,
                    width: 2.5,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFF4A90E2).withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                ),
                child: const CircleAvatar(
                  radius: 32,
                  backgroundImage: NetworkImage(
                    'https://via.placeholder.com/150',
                  ),
                ),
              ),
              if (isSelected && gpa.isNotEmpty)
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF95738),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Text(
                      gpa,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: GoogleFonts.inter(
              color: isSelected
                  ? const Color(0xFF0D3B66)
                  : Colors.grey.shade500,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernScoreItem(
    String title,
    String subtitle,
    int score,
    Color accentColor,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: accentColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: const Color(0xFF0D3B66),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    color: Colors.grey.shade500,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F6F8),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "$score",
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: const Color(0xFF0D3B66),
                  ),
                ),
                Text(
                  "/100",
                  style: GoogleFonts.inter(
                    color: Colors.grey.shade400,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernSummaryCard() {
    final total   = _grades.fold(0.0, (s, g) => s + g.score);
    final avg     = _grades.isEmpty ? 0.0 : total / _grades.length;
    final maxTotal = _grades.length * 100.0;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D3B66), Color(0xFF16477A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D3B66).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Performance Summary",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const Icon(Icons.analytics_rounded, color: Colors.white70),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildModernSummaryStat(
                "Total Score",
                _grades.isEmpty ? "--" : "${total.round()}",
                "of ${maxTotal.round()}",
                const Color(0xFF50E3C2),
              ),
              Container(
                width: 1, height: 40,
                color: Colors.white.withValues(alpha: 0.1),
              ),
              _buildModernSummaryStat(
                "Average",
                _grades.isEmpty ? "--" : "${avg.toStringAsFixed(1)}%",
                "${_grades.length} subject(s)",
                const Color(0xFF4A90E2),
              ),
              Container(
                width: 1, height: 40,
                color: Colors.white.withValues(alpha: 0.1),
              ),
              _buildModernSummaryStat(
                "Subjects",
                "${_grades.length}",
                "recorded",
                const Color(0xFFFFB75E),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModernSummaryStat(
    String label,
    String value,
    String sub,
    Color accentColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.outfit(
            color: accentColor,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          sub,
          style: GoogleFonts.inter(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
