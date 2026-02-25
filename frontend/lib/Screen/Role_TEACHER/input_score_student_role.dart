import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tamdansers/services/api_service.dart';
import 'package:tamdansers/services/api_models.dart';

class ScoreInputScreen extends StatefulWidget {
  const ScoreInputScreen({super.key});

  @override
  State<ScoreInputScreen> createState() => _ScoreInputScreenState();
}

class _ScoreInputScreenState extends State<ScoreInputScreen> {
  final _api = ApiService();

  List<ClassroomDto> _classrooms = [];
  List<SubjectDto> _subjects = [];
  List<StudentDto> _students = [];

  String? _selectedClassroomId;
  String _selectedSemester = 'Semester 1';
  bool _isLoading = true;
  bool _isSaving = false;

  // studentId → subjectId → TextEditingController
  final Map<String, Map<String, TextEditingController>> _scoreControllers = {};

  static const List<String> _semesters = ['Semester 1', 'Semester 2'];
  static const List<Color> _accentColors = [
    Color(0xFF4A90E2),
    Color(0xFF50E3C2),
    Color(0xFFB86DFF),
    Color(0xFFFF6B6B),
    Color(0xFFFFB75E),
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    for (final subMap in _scoreControllers.values) {
      for (final ctrl in subMap.values) {
        ctrl.dispose();
      }
    }
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    try {
      final classrooms = await _api.getClassrooms();
      final subjects = await _api.getSubjects();
      setState(() {
        _classrooms = classrooms;
        _subjects = subjects;
        if (classrooms.isNotEmpty) {
          _selectedClassroomId = classrooms.first.id;
        }
      });
      if (_selectedClassroomId != null) {
        await _loadStudents(_selectedClassroomId!);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load data: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadStudents(String classroomId) async {
    setState(() => _isLoading = true);
    try {
      final detail = await _api.getClassroomDetail(classroomId);
      if (detail == null) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }
      final students = detail.students
          .map((s) => StudentDto(
                id: s.studentId,
                firstName: s.firstName,
                lastName: s.lastName,
                isActive: true,
                createdAt: '',
              ))
          .toList();
      // Load existing grades for this semester
      final semester = _selectedSemester == 'Semester 1' ? 1 : 2;
      final Map<String, Map<String, TextEditingController>> controllers = {};
      for (final student in students) {
        final subMap = <String, TextEditingController>{};
        for (final subject in _subjects) {
          subMap[subject.id] = TextEditingController();
        }
        controllers[student.id] = subMap;
      }
      // Pre-fill existing grades
      for (final student in students) {
        try {
          final grades = await _api.getGrades(
            studentId: student.id,
            semester: semester.toString(),
          );
          for (final grade in grades) {
            final ctrl = controllers[student.id]?[grade.subjectId];
            if (ctrl != null) {
              ctrl.text = grade.score.toStringAsFixed(0);
            }
          }
        } catch (_) {}
      }
      if (mounted) {
        setState(() {
          _students = students;
          // dispose old controllers not in new set
          for (final subMap in _scoreControllers.values) {
            for (final ctrl in subMap.values) {
              ctrl.dispose();
            }
          }
          _scoreControllers
            ..clear()
            ..addAll(controllers);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load students: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _publishScores() async {
    final semester = _selectedSemester == 'Semester 1' ? 1 : 2;
    int saved = 0;
    int errors = 0;
    setState(() => _isSaving = true);
    for (final student in _students) {
      final subMap = _scoreControllers[student.id];
      if (subMap == null) continue;
      for (final subject in _subjects) {
        final ctrl = subMap[subject.id];
        if (ctrl == null || ctrl.text.trim().isEmpty) continue;
        final scoreVal = double.tryParse(ctrl.text.trim());
        if (scoreVal == null) continue;
        try {
          await _api.createGrade(GradeDto(
            id: '',
            studentId: student.id,
            studentName: '${student.firstName} ${student.lastName}',
            subjectId: subject.id,
            subjectName: subject.subjectName,
            score: scoreVal,
            semester: semester.toString(),
            createdAt: '',
          ));
          saved++;
        } catch (_) {
          errors++;
        }
      }
    }
    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errors > 0
              ? 'Saved $saved scores. $errors failed.'
              : 'Successfully published $saved scores!'),
          backgroundColor: errors > 0 ? Colors.orange : const Color(0xFF50E3C2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
          'Score Entry',
          style: GoogleFonts.outfit(
            color: const Color(0xFF0D3B66),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFF0D3B66),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _buildModernFilterSection(),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF0D3B66),
                        ),
                      )
                    : _students.isEmpty
                        ? Center(
                            child: Text(
                              'No students in this classroom',
                              style: GoogleFonts.outfit(
                                color: Colors.grey.shade500,
                                fontSize: 16,
                              ),
                            ),
                          )
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding:
                                const EdgeInsets.fromLTRB(24, 8, 24, 100),
                            itemCount: _students.length,
                            itemBuilder: (context, index) {
                              final student = _students[index];
                              final subMap =
                                  _scoreControllers[student.id] ?? {};
                              final scoresMap = <String,
                                  TextEditingController>{};
                              for (final sub in _subjects) {
                                final ctrl = subMap[sub.id];
                                if (ctrl != null) {
                                  scoresMap[sub.subjectName] = ctrl;
                                }
                              }
                              return ModernScoreCard(
                                name:
                                    '${student.firstName} ${student.lastName}',
                                id: student.id.length > 8
                                    ? student.id.substring(0, 8)
                                    : student.id,
                                gender: student.gender ?? '',
                                scoreControllers: scoresMap,
                                accentColor: _accentColors[
                                    index % _accentColors.length],
                              );
                            },
                          ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildModernStickySaveButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildModernFilterSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildClassDropdown()),
              const SizedBox(width: 16),
              Expanded(child: _buildSemesterDropdown()),
            ],
          ),
          const SizedBox(height: 16),
          Bounceable(
            onTap: () {
              // Auto-calculate: nothing to compute server-side, scores are entered manually
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fill in the scores above and press Publish.'),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF4A90E2).withValues(alpha: 0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4A90E2).withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.auto_awesome_rounded,
                    color: Color(0xFF4A90E2),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Auto Calculate Scores',
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF4A90E2),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Class',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          DropdownButtonHideUnderline(
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
                fontSize: 14,
              ),
              items: _classrooms
                  .map((c) => DropdownMenuItem(
                        value: c.id,
                        child: Text(c.name),
                      ))
                  .toList(),
              onChanged: (val) {
                if (val == null) return;
                setState(() => _selectedClassroomId = val);
                _loadStudents(val);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSemesterDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Semester',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedSemester,
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF0D3B66),
              ),
              style: GoogleFonts.inter(
                color: const Color(0xFF0D3B66),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              items: _semesters
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (val) {
                if (val == null) return;
                setState(() => _selectedSemester = val);
                if (_selectedClassroomId != null) {
                  _loadStudents(_selectedClassroomId!);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernStickySaveButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Bounceable(
        onTap: _isSaving ? null : _publishScores,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _isSaving
                  ? [Colors.grey.shade400, Colors.grey.shade500]
                  : [const Color(0xFF0D3B66), const Color(0xFF1E5B94)],
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.cloud_upload_rounded,
                color: Colors.white,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                _isSaving ? 'Publishing...' : 'Publish Scores',
                style: GoogleFonts.outfit(
                  color: Colors.white,
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

class ModernScoreCard extends StatelessWidget {
  final String name, id, gender;
  final Map<String, TextEditingController> scoreControllers;
  final Color accentColor;

  const ModernScoreCard({
    super.key,
    required this.name,
    required this.id,
    required this.gender,
    required this.scoreControllers,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: accentColor.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: accentColor.withValues(alpha: 0.1),
                    child: Icon(
                      Icons.person_rounded,
                      color: accentColor,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: const Color(0xFF0D3B66),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'ID: $id • $gender',
                        style: GoogleFonts.inter(
                          color: Colors.grey.shade500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (scoreControllers.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildScoreInputGrid(context),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildScoreInputGrid(BuildContext context) {
    final subjects = scoreControllers.keys.toList();
    final rows = <Widget>[];
    for (int i = 0; i < subjects.length; i += 3) {
      final rowSubjects = subjects.skip(i).take(3).toList();
      rows.add(
        Row(
          children: rowSubjects.map((subjectName) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _buildScoreInputCell(
                  context,
                  subjectName,
                  scoreControllers[subjectName]!,
                ),
              ),
            );
          }).toList(),
        ),
      );
      if (i + 3 < subjects.length) {
        rows.add(const SizedBox(height: 8));
      }
    }
    return Column(children: rows);
  }

  Widget _buildScoreInputCell(
    BuildContext context,
    String label,
    TextEditingController ctrl,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(
            label.length > 8 ? label.substring(0, 8) : label,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: accentColor.withValues(alpha: 0.8),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 32,
            child: TextField(
              controller: ctrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: const Color(0xFF0D3B66),
              ),
              decoration: InputDecoration(
                hintText: '-',
                hintStyle: GoogleFonts.outfit(
                  color: Colors.grey.shade400,
                  fontSize: 15,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
