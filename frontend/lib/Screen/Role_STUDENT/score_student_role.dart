import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tamdansers/services/api_service.dart';
import 'package:tamdansers/services/api_models.dart';
import 'package:tamdansers/Screen/Edit-Profile/student_edit_profile.dart'; // Adjust path if needed

class StudentScoreScreen extends StatefulWidget {
  const StudentScoreScreen({super.key});

  @override
  State<StudentScoreScreen> createState() => _StudentScoreScreenState();
}

class _StudentScoreScreenState extends State<StudentScoreScreen> {
  int pageIndex = 0;
  int selectedSemesterIndex = 0; // 0 = Semester 1, 1 = Semester 2

  // Design Palette
  final Color primaryTeal = const Color(0xFF0D3B66);
  final Color scaffoldBg = const Color(0xFFF3F6F8);

  // API data
  final _api = ApiService();
  bool _isLoading = true;
  // semesterIndex → list of grade data
  final Map<int, List<Map<String, dynamic>>> _semesterData = {};

  // Calculator
  final List<TextEditingController> _calcControllers = List.generate(
    7,
    (index) => TextEditingController(text: '0'),
  );
  double _calculatedAverage = 0.0;

  static const List<String> _semesters = ['Semester 1', 'Semester 2'];
  static const List<Color> _subjectColors = [
    Color(0xFFFFB75E),
    Color(0xFF4A90E2),
    Color(0xFFB86DFF),
    Color(0xFFFF6B6B),
    Color(0xFF50E3C2),
    Color(0xFFFFB75E),
    Color(0xFF4A90E2),
  ];
  static const List<IconData> _subjectIcons = [
    Icons.calculate_rounded,
    Icons.science_rounded,
    Icons.menu_book_rounded,
    Icons.language_rounded,
    Icons.biotech_rounded,
    Icons.museum_rounded,
    Icons.computer_rounded,
  ];

  @override
  void initState() {
    super.initState();
    for (var ctrl in _calcControllers) {
      ctrl.addListener(_updateCalculation);
    }
    _loadGrades();
  }

  @override
  void dispose() {
    for (var ctrl in _calcControllers) {
      ctrl.dispose();
    }
    super.dispose();
  }

  void _updateCalculation() {
    double total = 0;
    for (var ctrl in _calcControllers) {
      total += double.tryParse(ctrl.text) ?? 0;
    }
    setState(() {
      _calculatedAverage = total / _calcControllers.length;
    });
  }

  Future<void> _loadGrades() async {
    setState(() => _isLoading = true);
    try {
      final entityId = await _api.getEntityId();
      if (entityId == null || entityId.isEmpty) {
        setState(() => _isLoading = false);
        return;
      }
      final grades = await _api.getGrades(studentId: entityId);
      final Map<int, List<Map<String, dynamic>>> data = {0: [], 1: []};
      for (final grade in grades) {
        final semIndex = (grade.semester == '1' || grade.semester == 'Semester 1') ? 0 : 1;
        final colorIdx = data[semIndex]!.length % _subjectColors.length;
        data[semIndex]!.add({
          'name': grade.subjectName,
          'score': grade.score.toStringAsFixed(0),
          'color': _subjectColors[colorIdx],
          'icon': _subjectIcons[colorIdx],
        });
      }
      if (mounted) {
        setState(() {
          _semesterData.clear();
          _semesterData.addAll(data);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<Map<String, dynamic>> get _currentSubjects =>
      _semesterData[selectedSemesterIndex] ?? [];

  double _getCurrentSemesterAvg() {
    final subjects = _currentSubjects;
    if (subjects.isEmpty) return 0.0;
    double sum = 0;
    for (final item in subjects) {
      sum += double.tryParse(item['score'] as String) ?? 0;
    }
    return sum / subjects.length;
  }

  @override
  Widget build(BuildContext context) {
    late final List<Widget> screens = [
      _buildScoreContent(),
      Center(
        child: Text(
          "Library",
          style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      Center(
        child: Text(
          "Messages",
          style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      const StudentEditProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: pageIndex == 0 ? _buildAppBar(context) : null,
      body: IndexedStack(index: pageIndex, children: screens),
    );
  }

  Widget _buildScoreContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 15),
          _buildSemesterSelector(),
          const SizedBox(height: 30),
          _buildSummaryCard(),
          const SizedBox(height: 35),
          _buildSubjectScoreList(),
          const SizedBox(height: 35),
          _buildCalculatorSection(),
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildSemesterSelector() {
    return Row(
      children: List.generate(_semesters.length, (index) {
        final isSelected = selectedSemesterIndex == index;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index < _semesters.length - 1 ? 12 : 0),
            child: Bounceable(
              onTap: () => setState(() => selectedSemesterIndex = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected ? primaryTeal : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: primaryTeal.withValues(alpha: 0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                ),
                child: Center(
                  child: Text(
                    _semesters[index],
                    style: GoogleFonts.inter(
                      color: isSelected ? Colors.white : Colors.grey.shade600,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSummaryCard() {
    if (_isLoading) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryTeal, primaryTeal.withValues(alpha: 0.85)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }
    final avg = _getCurrentSemesterAvg();
    return Bounceable(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryTeal, primaryTeal.withValues(alpha: 0.85)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: primaryTeal.withValues(alpha: 0.3),
              blurRadius: 25,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Average for ${_semesters[selectedSemesterIndex]}',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              avg.toStringAsFixed(2),
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 56,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
              ),
            ),
            Text(
              'TOTAL SCORE AVERAGE',
              style: GoogleFonts.inter(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatDetail(
                  'GRADE',
                  avg >= 90 ? 'A+' : (avg >= 80 ? 'B' : 'C'),
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
                _buildStatDetail('STATUS', avg >= 50 ? 'PASSED' : 'FAILED'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectScoreList() {
    final subjects = _currentSubjects;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subject Analysis',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: primaryTeal,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryTeal.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.insights_rounded,
                  size: 20,
                  color: primaryTeal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          if (subjects.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'No grades recorded for this semester',
                style: GoogleFonts.outfit(color: Colors.grey.shade400),
              ),
            )
          else
            ...subjects.map(
              (s) => _subjectTile(
                s['name'] as String,
                '${s['score']}/100',
                s['color'] as Color,
                s['icon'] as IconData,
              ),
            ),
        ],
      ),
    );
  }

  Widget _subjectTile(String name, String score, Color color, IconData icon) {
    double scoreVal = double.tryParse(score.split('/')[0]) ?? 0;
    return Bounceable(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Row(
          children: [
            Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: const Color(0xFF0D3B66),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: scoreVal / 100,
                      backgroundColor: Colors.grey.withValues(alpha: 0.15),
                      color: color,
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Text(
              score.split('/')[0],
              style: GoogleFonts.outfit(
                color: primaryTeal,
                fontWeight: FontWeight.w900,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculatorSection() {
    final subjects = _currentSubjects;
    final subjectNames = subjects.isNotEmpty
        ? subjects.map((s) => s['name'] as String).toList()
        : ['Mathematics', 'Physics', 'Khmer Literature', 'English', 'Chemistry', 'History', 'ICT'];
    final count = subjectNames.length.clamp(1, _calcControllers.length);
    // Sync calculator count if needed
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calculate_rounded, color: primaryTeal, size: 24),
              const SizedBox(width: 10),
              Text(
                "Score Predictor",
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: primaryTeal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          ...List.generate(
            count,
            (index) =>
                _calcInputField(subjectNames[index], _calcControllers[index]),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 25),
            child: Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "ESTIMATED AVG",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w800,
                  color: Colors.grey.shade500,
                  fontSize: 12,
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                "${_calculatedAverage.toStringAsFixed(2)}%",
                style: GoogleFonts.outfit(
                  color: primaryTeal,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _calcInputField(String label, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: scaffoldBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: GoogleFonts.inter(
                color: const Color(0xFF0D3B66),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w900,
                color: primaryTeal,
                fontSize: 18,
              ),
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "0",
                hintStyle: GoogleFonts.outfit(
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.normal,
                ),
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "/ 100",
            style: GoogleFonts.inter(
              color: Colors.grey.shade500,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Bounceable(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF0D3B66),
            size: 18,
          ),
        ),
      ),
      title: Text(
        "Performance",
        style: GoogleFonts.outfit(
          color: const Color(0xFF0D3B66),
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildStatDetail(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ],
    );
  }
}
