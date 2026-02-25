import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tamdansers/Screen/Role_TEACHER/attendance_analysis_role.dart';
import 'package:tamdansers/services/api_service.dart';
import 'package:tamdansers/services/api_models.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      textTheme: GoogleFonts.interTextTheme(),
      scaffoldBackgroundColor: const Color(0xFFF3F6F8),
    ),
    home: const AttendanceScreen(),
  ),
);

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  // Selection State
  String? selectedClassroomId;
  String selectedGrade = '';         // display label for the dropdown
  DateTime selectedDate = DateTime.now();

  // API Data
  List<ClassroomDto> _classrooms = [];
  List<StudentDto> _classroomStudents = [];
  bool _isLoading = true;
  bool _isSubmitting = false;

  /// Maps studentId → status string ("Present" / "Absent" / "Late")
  Map<String, String> attendanceRecords = {};

  // Computed stats
  int get countPresent => attendanceRecords.values.where((v) => v == 'Present').length;
  int get countAbsent  => attendanceRecords.values.where((v) => v == 'Absent').length;
  int get countLate    => attendanceRecords.values.where((v) => v == 'Late').length;

  // Day picker — last 5 days
  List<DateTime> get _recentDays =>
      List.generate(5, (i) => DateTime.now().subtract(Duration(days: 4 - i)));

  @override
  void initState() {
    super.initState();
    _loadClassrooms();
  }

  Future<void> _loadClassrooms() async {
    try {
      final classrooms = await ApiService().getClassrooms();
      if (mounted) {
        setState(() {
          _classrooms = classrooms;
          if (classrooms.isNotEmpty) {
            selectedClassroomId = classrooms.first.id;
            selectedGrade = classrooms.first.name;
          }
          _isLoading = false;
        });
        if (selectedClassroomId != null) {
          await _loadStudentsForClassroom(selectedClassroomId!);
        }
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadStudentsForClassroom(String classroomId) async {
    try {
      final detail = await ApiService().getClassroomDetail(classroomId);
      if (detail == null) return;
      final dateKey = _formatDate(selectedDate);
      final existing = await ApiService().getClassroomAttendance(classroomId, dateKey);

      final existingMap = {for (var a in existing) a.studentId: a.status};

      if (mounted) {
        setState(() {
          _classroomStudents = detail.students
              .map((cs) => StudentDto(
                    id: cs.studentId,
                    firstName: cs.firstName,
                    lastName: cs.lastName,
                    gender: null,
                    dateOfBirth: null,
                    phone: null,
                    address: null,
                    isActive: true,
                    createdAt: '',
                  ))
              .toList();

          attendanceRecords = {
            for (var s in _classroomStudents)
              s.id: existingMap[s.id] ?? 'Present'
          };
        });
      }
    } catch (_) {}
  }

  Future<void> _submitAttendance() async {
    if (selectedClassroomId == null || _classroomStudents.isEmpty) return;
    setState(() => _isSubmitting = true);

    try {
      final statusMap = {'Present': 1, 'Absent': 2, 'Late': 3};
      final records = attendanceRecords.entries
          .map((e) => AttendanceMarkRequest(
                studentId: e.key,
                status: statusMap[e.value] ?? 1,
              ))
          .toList();

      final request = BulkMarkAttendanceRequest(
        classroomId: selectedClassroomId!,
        date: _formatDate(selectedDate),
        records: records,
      );

      await ApiService().markAttendance(request);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Attendance for $selectedGrade saved!',
                style: GoogleFonts.inter()),
            backgroundColor: const Color(0xFF0D3B66),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save attendance', style: GoogleFonts.inter()),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';


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
          'Manage Attendance',
          style: GoogleFonts.outfit(
            color: const Color(0xFF0D3B66),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_rounded, color: Color(0xFF0D3B66)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AttendanceAnalysisScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          _buildModernHeaderSection(),
          Expanded(
            child: _classroomStudents.isEmpty
                ? Center(
                    child: Text('No students enrolled in this classroom.',
                        style: GoogleFonts.inter(color: Colors.grey)))
                : ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              itemCount: _classroomStudents.length,
              itemBuilder: (context, index) {
                final student = _classroomStudents[index];
                final id = student.id;
                return ModernStudentAttendanceCard(
                  name: '${student.firstName} ${student.lastName}',
                  englishName: student.firstName,
                  id: id,
                  status: attendanceRecords[id] ?? 'Present',
                  onStatusChanged: (newStatus) {
                    setState(() => attendanceRecords[id] = newStatus);
                  },
                );
              },
            ),
          ),
          _buildModernBottomSummary(),
        ],
      ),
    );
  }

  Widget _buildModernHeaderSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 16),
      child: Column(
        children: [
          // Grade Selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
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
                value: selectedGrade,
                isExpanded: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFF0D3B66),
                ),
                style: GoogleFonts.inter(
                  color: const Color(0xFF0D3B66),
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
                items:
                    _classrooms
                        .map((c) => DropdownMenuItem(
                              value: c.name,
                              child: Text(c.name),
                              onTap: () async {
                                selectedClassroomId = c.id;
                                await _loadStudentsForClassroom(c.id);
                              },
                            ))
                        .toList(),
                onChanged: (val) => setState(() => selectedGrade = val!),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Day Picker
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _recentDays.map((d) {
              const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
              return _buildModernDateItem(
                '${d.day}',
                days[d.weekday - 1],
                isSelected: selectedDate.day == d.day &&
                    selectedDate.month == d.month,
                onTap: () async {
                  setState(() => selectedDate = d);
                  if (selectedClassroomId != null) {
                    await _loadStudentsForClassroom(selectedClassroomId!);
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          // Stats Row
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF0D3B66),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0D3B66).withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildModernStatBox(
                  'Total',
                  '${_classroomStudents.length}',
                  Colors.white,
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
                _buildModernStatBox(
                  'Present',
                  '$countPresent',
                  const Color(0xFF50E3C2),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
                _buildModernStatBox(
                  'Absent',
                  '$countAbsent',
                  const Color(0xFFF95738),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
                _buildModernStatBox(
                  'Late',
                  '$countLate',
                  const Color(0xFFFFB75E),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernDateItem(String day, String weekday,
      {bool isSelected = false, VoidCallback? onTap}) {
    return Bounceable(
      onTap: onTap ?? () {},
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 60,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF4A90E2), Color(0xFF00C4FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF4A90E2).withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          children: [
            Text(
              weekday,
              style: GoogleFonts.inter(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.9)
                    : Colors.grey.shade500,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              day,
              style: GoogleFonts.outfit(
                color: isSelected ? Colors.white : const Color(0xFF0D3B66),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernStatBox(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: Colors.white.withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildModernBottomSummary() {
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    const TextSpan(text: 'P: '),
                    TextSpan(
                      text: '$countPresent',
                      style: const TextStyle(
                        color: Color(0xFF50E3C2),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(text: ' • A: '),
                    TextSpan(
                      text: '$countAbsent',
                      style: const TextStyle(
                        color: Color(0xFFF95738),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(text: ' • L: '),
                    TextSpan(
                      text: '$countLate',
                      style: const TextStyle(
                        color: Color(0xFFFFB75E),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF50E3C2).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF50E3C2),
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Ready',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF2EA88D),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Bounceable(
            onTap: _isSubmitting ? null : _submitAttendance,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4A90E2), Color(0xFF00C4FF)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4A90E2).withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'Submit Attendance',
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
    );
  }
}

class ModernStudentAttendanceCard extends StatelessWidget {
  final String name;
  final String englishName;
  final String id;
  final String status;
  final Function(String) onStatusChanged;

  const ModernStudentAttendanceCard({
    super.key,
    required this.name,
    required this.englishName,
    required this.id,
    required this.status,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
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
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  backgroundImage: NetworkImage(
                    "https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?w=740",
                  ),
                  radius: 26,
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
                      englishName,
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
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F6F8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'ID: $id',
                  style: GoogleFonts.inter(
                    color: Colors.grey.shade600,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F6F8),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                _buildModernToggleBtn(
                  'Present',
                  status == 'Present',
                  const Color(0xFF50E3C2),
                  const Color(0xFF2EA88D),
                ),
                const SizedBox(width: 6),
                _buildModernToggleBtn(
                  'Absent',
                  status == 'Absent',
                  const Color(0xFFF95738),
                  Colors.white,
                ),
                const SizedBox(width: 6),
                _buildModernToggleBtn(
                  'Late',
                  status == 'Late',
                  const Color(0xFFFFB75E),
                  Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernToggleBtn(
    String label,
    bool active,
    Color activeBgColor,
    Color activeTextColor,
  ) {
    return Expanded(
      child: Bounceable(
        onTap: () => onStatusChanged(label),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? activeBgColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: activeBgColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.inter(
                color: active ? activeTextColor : Colors.grey.shade500,
                fontSize: 13,
                fontWeight: active ? FontWeight.bold : FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
