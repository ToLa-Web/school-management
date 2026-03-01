// lib/screens/add_course.dart

import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tamdansers/model/course_model.dart';
import 'package:tamdansers/services/api_models.dart';
import 'package:tamdansers/services/api_service.dart';

class AddCourse extends StatefulWidget {
  const AddCourse({super.key});

  @override
  State<AddCourse> createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  String? _selectedSubject;
  String? _selectedGrade;
  DateTime? _startDate;
  bool _isCreating = false;

  // Controllers for text fields
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  final ApiService _api = ApiService();
  List<SubjectDto> _apiSubjects = [];
  final List<String> _subjects = [
    'Mathematics',
    'Khmer Literature',
    'Physics',
    'Chemistry',
    'Biology',
    'English',
    'History',
  ];

  List<String> get _gradeList => [
    'Grade 7',
    'Grade 8',
    'Grade 9',
    'Grade 10',
    'Grade 11',
    'Grade 12',
  ];

  final Map<String, Map<String, dynamic>> _subjectStyles = {
    'Mathematics': {
      'icon': Icons.calculate_rounded,
      'color': const Color(0xFF3B82F6),
    },
    'Khmer Literature': {
      'icon': Icons.book_rounded,
      'color': const Color(0xFF8B5CF6),
    },
    'Physics': {
      'icon': Icons.science_rounded,
      'color': const Color(0xFF10B981),
    },
    'Chemistry': {
      'icon': Icons.science_outlined,
      'color': const Color(0xFFF59E0B),
    },
    'Biology': {
      'icon': Icons.biotech_rounded,
      'color': const Color(0xFF6366F1),
    },
    'English': {
      'icon': Icons.language_rounded,
      'color': const Color(0xFFEC4899),
    },
    'History': {
      'icon': Icons.history_edu_rounded,
      'color': const Color(0xFFEF4444),
    },
  };

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _animController.forward();
    _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    try {
      final subjects = await _api.getSubjects();
      if (mounted) {
        setState(() {
          _apiSubjects = subjects;
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _pickStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 730)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF6366F1),
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: Color(0xFF1F2937),
          ),
          dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
        ),
        child: child!,
      ),
    );
    if (picked != null && picked != _startDate) {
      setState(() => _startDate = picked);
    }
  }

  Future<void> _handleCreateCourse() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedSubject == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select a subject',
            style: GoogleFonts.plusJakartaSans(),
          ),
          backgroundColor: const Color(0xFF6366F1),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }
    if (_selectedGrade == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select a grade',
            style: GoogleFonts.plusJakartaSans(),
          ),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    setState(() => _isCreating = true);

    try {
      // If the selected subject isn't in the API list, create it
      final existingNames = _apiSubjects
          .map((s) => s.subjectName.toLowerCase())
          .toSet();
      final subjectName = _selectedSubject ?? '';
      if (subjectName.isNotEmpty &&
          !existingNames.contains(subjectName.toLowerCase())) {
        await _api.createSubject(subjectName);
      }
    } catch (_) {}

    // Create course object for local display
    final newCourse = Course(
      title: _titleController.text.trim(),
      subject: _selectedSubject ?? '',
      grade: _selectedGrade ?? '',
      price: double.tryParse(_priceController.text.trim()) ?? 0.0,
      startDate: _startDate,
      description: _descriptionController.text.trim(),
    );

    if (mounted) setState(() => _isCreating = false);

    if (!mounted) return;

    Navigator.pop(context, newCourse);
  }

  static const _accentColors = [
    Color(0xFF6366F1),
    Color(0xFF8B5CF6),
    Color(0xFF10B981),
    Color(0xFFF59E0B),
    Color(0xFFEC4899),
    Color(0xFFEF4444),
  ];

  Color _subjectColor(String name) =>
      _accentColors[name.hashCode.abs() % _accentColors.length];

  // ── Field section label ─────────────────────────────────────────────
  Widget _buildFieldLabel(IconData icon, String label, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectCards() {
    // Source 1: API subjects
    if (_apiSubjects.isNotEmpty) {
      return Column(
        children: _apiSubjects.asMap().entries.map((e) {
          final s = e.value;
          final color = _subjectColor(s.subjectName);
          final isSelected = _selectedSubject == s.subjectName;
          return Bounceable(
            onTap: () => setState(
              () => _selectedSubject = isSelected ? null : s.subjectName,
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isSelected
                    ? color.withValues(alpha: 0.06)
                    : Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isSelected ? color : Colors.grey.shade200,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? color.withValues(alpha: 0.14)
                        : Colors.black.withValues(alpha: 0.03),
                    blurRadius: isSelected ? 20 : 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color, color.withValues(alpha: 0.65)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        s.subjectName.isNotEmpty
                            ? s.subjectName[0].toUpperCase()
                            : '?',
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
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
                          s.subjectName,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: s.isActive
                                    ? const Color(0xFF10B981)
                                    : Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              s.isActive ? 'Active' : 'Inactive',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: s.isActive
                                    ? const Color(0xFF10B981)
                                    : Colors.grey,
                              ),
                            ),
                            if (s.teacherNames.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              Container(
                                width: 3,
                                height: 3,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  s.teacherNames.join(', '),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                    )
                  else
                    Icon(
                      Icons.radio_button_off_rounded,
                      color: Colors.grey.shade300,
                      size: 22,
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    }

    // Source 2: globalCourses
    final globalSubjects = globalCourses.map((c) => c.subject).toSet().toList();
    final displaySubjects = globalSubjects.isNotEmpty
        ? globalSubjects
        : _subjects;

    return Column(
      children: displaySubjects.asMap().entries.map((e) {
        final name = e.value;
        final color = _subjectColor(name);
        final style = _subjectStyles[name];
        final isSelected = _selectedSubject == name;
        return Bounceable(
          onTap: () =>
              setState(() => _selectedSubject = isSelected ? null : name),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isSelected
                  ? color.withValues(alpha: 0.06)
                  : Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isSelected ? color : Colors.grey.shade200,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? color.withValues(alpha: 0.14)
                      : Colors.black.withValues(alpha: 0.03),
                  blurRadius: isSelected ? 20 : 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withValues(alpha: 0.65)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: style != null
                        ? Icon(
                            style['icon'] as IconData,
                            color: Colors.white,
                            size: 22,
                          )
                        : Text(
                            name.isNotEmpty ? name[0].toUpperCase() : '?',
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    name,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ),
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                  )
                else
                  Icon(
                    Icons.radio_button_off_rounded,
                    color: Colors.grey.shade300,
                    size: 22,
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGradeChips() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _gradeList.map((grade) {
        final isSelected = _selectedGrade == grade;
        const color = Color(0xFF10B981);
        return Bounceable(
          onTap: () =>
              setState(() => _selectedGrade = isSelected ? null : grade),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                      colors: [Color(0xFF10B981), Color(0xFF059669)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isSelected ? null : Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? Colors.transparent : Colors.grey.shade200,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? color.withValues(alpha: 0.25)
                      : Colors.black.withValues(alpha: 0.03),
                  blurRadius: isSelected ? 12 : 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected) ...[
                  const Icon(
                    Icons.school_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                ],
                Text(
                  grade,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: _buildCircleButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          'Create Course',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F2937),
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FAFC), Color(0xFFE0F2FE)],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Form(
              key: _formKey,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _buildSectionHeader('Course Cover'),
                        const SizedBox(height: 12),
                        _buildThumbnailUploader(),
                        const SizedBox(height: 32),

                        _buildSectionHeader('Course Information'),
                        const SizedBox(height: 16),

                        _buildModernTextField(
                          controller: _titleController,
                          label: 'Course Title',
                          hint: 'e.g. Mathematics Grade 10 - Semester 2',
                          validator: (v) =>
                              v?.trim().isEmpty ?? true ? 'Required' : null,
                        ),
                        const SizedBox(height: 28),

                        _buildFieldLabel(
                          Icons.auto_stories_rounded,
                          'Select Subject',
                          const Color(0xFF6366F1),
                        ),
                        const SizedBox(height: 14),
                        _buildSubjectCards(),
                        const SizedBox(height: 28),

                        _buildFieldLabel(
                          Icons.school_rounded,
                          'Select Grade',
                          const Color(0xFF10B981),
                        ),
                        const SizedBox(height: 14),
                        _buildGradeChips(),
                        const SizedBox(height: 28),

                        _buildModernTextField(
                          controller: _priceController,
                          label: 'Price (USD)',
                          hint: '0.00 for free courses',
                          keyboardType: TextInputType.number,
                          prefix: r'$ ',
                          validator: (v) {
                            if (v?.trim().isEmpty ?? true) return 'Required';
                            if (double.tryParse(v!) == null) return 'Invalid';
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        _buildDatePickerField(),
                        const SizedBox(height: 24),

                        _buildModernTextField(
                          controller: _descriptionController,
                          label: 'Description',
                          hint: 'What will students learn in this course?...',
                          maxLines: 6,
                          minLines: 4,
                          validator: (v) =>
                              v?.trim().isEmpty ?? true ? 'Required' : null,
                        ),

                        const SizedBox(height: 48),

                        _buildCreateButton(),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.92),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 20, color: const Color(0xFF1F2937)),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1F2937),
      ),
    );
  }

  Widget _buildThumbnailUploader() {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image picker coming soon')),
        );
      },
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [
              Colors.white.withValues(alpha: 0.35),
              Colors.white.withValues(alpha: 0.08),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_photo_alternate_rounded,
                size: 56,
                color: const Color(0xFF6366F1).withValues(alpha: 0.8),
              ),
              const SizedBox(height: 16),
              Text(
                'Upload Course Cover\n1280×720 recommended • JPG/PNG',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernTextField({
    TextEditingController? controller,
    required String label,
    String? hint,
    TextInputType? keyboardType,
    String? prefix,
    int maxLines = 1,
    int minLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      minLines: minLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixText: prefix,
        labelStyle: const TextStyle(color: Color(0xFF6366F1)),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 18,
        ),
      ),
    );
  }

  Widget _buildDatePickerField() {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => _pickStartDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Start Date (optional)',
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 18,
          ),
          suffixIcon: const Icon(
            Icons.calendar_today_rounded,
            color: Color(0xFF6366F1),
          ),
        ),
        child: Text(
          _startDate == null
              ? 'Select start date'
              : '${_startDate!.day.toString().padLeft(2, '0')}/${_startDate!.month.toString().padLeft(2, '0')}/${_startDate!.year}',
          style: TextStyle(
            color: _startDate == null
                ? Colors.grey.shade600
                : const Color(0xFF1F2937),
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildCreateButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: _isCreating ? null : _handleCreateCourse,
        icon: _isCreating
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Icon(Icons.add_rounded, size: 24),
        label: Text(_isCreating ? 'Creating...' : 'Create Course'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
