import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tamdansers/services/api_service.dart';
import 'package:tamdansers/services/api_models.dart';

class CreateClassScreen extends StatefulWidget {
  const CreateClassScreen({super.key});

  @override
  State<CreateClassScreen> createState() => _CreateClassScreenState();
}

class _CreateClassScreenState extends State<CreateClassScreen> {
  final Color primaryTeal = const Color(0xFF00B2B2);
  final Color deepBlue = const Color(0xFF0D3B66);
  final Color backgroundColor = const Color(0xFFF3F6F8);

  String? selectedGradeNumber; // '7' .. '12'
  String? selectedSection; // 'A' .. 'E'
  String? selectedSubjectId;
  String? selectedAcademicYear;
  String? _myTeacherId;

  // Computed class name from grade + section
  String get _computedName =>
      (selectedGradeNumber != null && selectedSection != null)
      ? 'Class $selectedGradeNumber-$selectedSection'
      : '';

  List<SubjectDto> _subjects = [];
  List<StudentDto> _allStudents = [];
  Set<String> _selectedStudentIds = {};
  bool _isLoading = true;
  bool _isSubmitting = false;

  final List<String> gradeNumbers = ['7', '8', '9', '10', '11', '12'];
  final List<String> sections = ['A', 'B', 'C', 'D', 'E'];
  final List<String> academicYears = ['2025-2026', '2026-2027'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final api = ApiService();
      final results = await Future.wait([api.getSubjects(), api.getStudents()]);
      final entityId = await api.getEntityId();
      if (mounted) {
        setState(() {
          _subjects = results[0] as List<SubjectDto>;
          _allStudents = results[1] as List<StudentDto>;
          _myTeacherId = entityId;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: deepBlue,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Create New Class',
          style: GoogleFonts.outfit(
            color: deepBlue,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Class Information
                  _buildSectionLabel(Icons.school_rounded, 'Class Information'),
                  _buildFormCard([
                    // Grade + Section row → auto-generates class name
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInputLabel('Grade'),
                              _buildModernDropdown(
                                hint: 'Grade',
                                value: selectedGradeNumber,
                                items: gradeNumbers,
                                itemLabels: gradeNumbers
                                    .map((g) => 'Grade $g')
                                    .toList(),
                                onChanged: (val) =>
                                    setState(() => selectedGradeNumber = val),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInputLabel('Section'),
                              _buildModernDropdown(
                                hint: 'Section',
                                value: selectedSection,
                                items: sections,
                                onChanged: (val) =>
                                    setState(() => selectedSection = val),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Live preview of generated name
                    if (_computedName.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: primaryTeal.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: primaryTeal.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.label_rounded,
                              size: 16,
                              color: primaryTeal,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Class name: ',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              _computedName,
                              style: GoogleFonts.outfit(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: primaryTeal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),
                    _buildInputLabel('Academic Year'),
                    _buildModernDropdown(
                      hint: 'Select year',
                      value: selectedAcademicYear,
                      items: academicYears,
                      onChanged: (val) =>
                          setState(() => selectedAcademicYear = val),
                    ),
                  ]),

                  const SizedBox(height: 32),

                  // 2. Select Subject
                  _buildSectionLabel(Icons.menu_book_rounded, 'Assign Subject'),
                  _buildFormCard([
                    _buildInputLabel('Select Subject'),
                    _buildModernDropdown(
                      hint: 'Choose a subject',
                      value: selectedSubjectId,
                      items: _subjects.map((s) => s.id).toList(),
                      itemLabels: _subjects.map((s) => s.subjectName).toList(),
                      onChanged: (val) =>
                          setState(() => selectedSubjectId = val),
                    ),
                  ]),

                  const SizedBox(height: 32),

                  // 3. Add Students
                  _buildSectionLabel(Icons.person_add_rounded, 'Add Students'),
                  Row(
                    children: [
                      Expanded(
                        child: _buildCreativeActionCard(
                          Icons.group_add_rounded,
                          'Select Students (${_selectedStudentIds.length})',
                          () => _showStudentListDialog(),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 48),

                  // CREATE BUTTON
                  Bounceable(
                    onTap: _isSubmitting ? null : _handleCreateClass,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            primaryTeal,
                            primaryTeal.withValues(alpha: 0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: primaryTeal.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.add_circle_outline_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Create New Class',
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
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionLabel(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryTeal.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: primaryTeal, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: deepBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildInputLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade500,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildModernDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    List<String>? itemLabels,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          hint: Text(
            hint,
            style: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 14),
          ),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.grey.shade400,
          ),
          items: List.generate(items.length, (i) {
            return DropdownMenuItem<String>(
              value: items[i],
              child: Text(
                itemLabels != null ? itemLabels[i] : items[i],
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: deepBlue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildCreativeActionCard(
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return Bounceable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 15,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primaryTeal.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: primaryTeal, size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: deepBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleCreateClass() async {
    if (selectedGradeNumber == null || selectedSection == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select a grade and section',
            style: GoogleFonts.inter(),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final classroom = ClassroomDto(
        id: '',
        name: _computedName,
        grade: 'Grade $selectedGradeNumber',
        academicYear: selectedAcademicYear,
        teacherId: _myTeacherId,
        isActive: true,
        createdAt: '',
        studentCount: 0,
      );

      final api = ApiService();
      final created = await api.createClassroom(classroom);
      if (created != null && mounted) {
        if (selectedSubjectId != null && _myTeacherId != null) {
          await api.assignTeacherToSubject(selectedSubjectId!, _myTeacherId!);
        }
        for (final studentId in _selectedStudentIds) {
          await api.enrollStudent(created.id, studentId);
        }
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${created.name} created successfully!',
              style: GoogleFonts.inter(),
            ),
            backgroundColor: primaryTeal,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to create class: $e',
              style: GoogleFonts.inter(),
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showStudentListDialog() {
    // Use a local copy so checkboxes are interactive
    final localSelected = Set<String>.from(_selectedStudentIds);

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Select Students (${localSelected.length}/${_allStudents.length})',
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              color: deepBlue,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: _allStudents.isEmpty
                ? Center(
                    child: Text(
                      'No students found.\nCreate students first.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: _allStudents.length,
                    itemBuilder: (_, i) {
                      final s = _allStudents[i];
                      return CheckboxListTile(
                        activeColor: primaryTeal,
                        checkboxShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        title: Text(
                          s.fullName,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            color: deepBlue,
                          ),
                        ),
                        subtitle: Text(
                          s.gender ?? '',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        value: localSelected.contains(s.id),
                        onChanged: (val) {
                          setDialogState(() {
                            if (val == true) {
                              localSelected.add(s.id);
                            } else {
                              localSelected.remove(s.id);
                            }
                          });
                        },
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryTeal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                setState(() => _selectedStudentIds = localSelected);
                Navigator.pop(ctx);
              },
              child: Text(
                'Add (${localSelected.length})',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
