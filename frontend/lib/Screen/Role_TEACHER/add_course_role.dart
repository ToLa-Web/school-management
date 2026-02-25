// lib/screens/add_course.dart

import 'package:flutter/material.dart';
import 'package:tamdansers/Screen/Role_TEACHER/course_learn_role.dart';
import 'package:tamdansers/model/course_model.dart';
import 'package:tamdansers/services/api_service.dart';
import 'package:tamdansers/services/api_models.dart';
 // ← list screen

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
  bool _loadingSubjects = true;

  final List<String> _subjects = [
    'Mathematics',
    'Khmer Literature',
    'Physics',
    'Chemistry',
    'Biology',
    'English',
    'History',
  ];

  List<String> get _effectiveSubjects => _apiSubjects.isNotEmpty
      ? _apiSubjects.map((s) => s.subjectName).toList()
      : _subjects;

  final List<String> _grades = [
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
          _loadingSubjects = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingSubjects = false);
    }
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
          dialogTheme: const DialogThemeData(
            backgroundColor: Colors.white,
          ),
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

    setState(() => _isCreating = true);

    try {
      // If the selected subject isn't in the API list, create it
      final existingNames =
          _apiSubjects.map((s) => s.subjectName.toLowerCase()).toSet();
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

    globalCourses.add(newCourse);

    if (mounted) setState(() => _isCreating = false);

    if (!mounted) return;

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Course created successfully!'),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        duration: const Duration(seconds: 2),
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const TeacherCourseScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final subjectStyle = _selectedSubject != null
        ? _subjectStyles[_selectedSubject]
        : null;

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
                        const SizedBox(height: 24),

                        _buildModernDropdown(
                          label: 'Subject',
                          value: _selectedSubject,
                          items: _effectiveSubjects,
                          selectedIcon: subjectStyle?['icon'],
                          selectedColor: subjectStyle?['color'],
                          onChanged: (v) {
                            setState(() => _selectedSubject = v);
                            _animController.reset();
                            _animController.forward();
                          },
                          validator: (v) => v == null ? 'Required' : null,
                        ),

                        if (_selectedSubject != null) ...[
                          const SizedBox(height: 16),
                          _buildSelectedChip(
                            label: _selectedSubject!,
                            icon: subjectStyle?['icon'],
                            color: subjectStyle?['color'],
                          ),
                        ],

                        const SizedBox(height: 24),

                        _buildModernDropdown(
                          label: 'Grade',
                          value: _selectedGrade,
                          items: _grades,
                          selectedIcon: Icons.school_rounded,
                          selectedColor: const Color(0xFF10B981),
                          onChanged: (v) {
                            setState(() => _selectedGrade = v);
                            _animController.reset();
                            _animController.forward();
                          },
                          validator: (v) => v == null ? 'Required' : null,
                        ),

                        if (_selectedGrade != null) ...[
                          const SizedBox(height: 16),
                          _buildSelectedChip(
                            label: _selectedGrade!,
                            icon: Icons.school_rounded,
                            color: const Color(0xFF10B981),
                          ),
                        ],

                        const SizedBox(height: 24),

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

  Widget _buildModernDropdown({
    required String label,
    required String? value,
    required List<String> items,
    IconData? selectedIcon,
    Color? selectedColor,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    final isSelected = value != null;

    return DropdownButtonFormField<String>(
      initialValue: value,
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
      validator: validator,
      icon: Icon(
        Icons.arrow_drop_down_rounded,
        color: isSelected
            ? (selectedColor ?? const Color(0xFF6366F1))
            : Colors.grey,
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: isSelected && selectedIcon != null
            ? Icon(
                selectedIcon,
                color: selectedColor ?? const Color(0xFF6366F1),
              )
            : null,
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
          borderSide: BorderSide(
            color: selectedColor ?? const Color(0xFF6366F1),
            width: 2.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
      ),
    );
  }

  Widget _buildSelectedChip({
    required String label,
    IconData? icon,
    Color? color,
  }) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.9, end: 1.0).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: (color ?? const Color(0xFF6366F1)).withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: (color ?? const Color(0xFF6366F1)).withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: color ?? const Color(0xFF6366F1)),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: color ?? const Color(0xFF1F2937),
              ),
            ),
          ],
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
