import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tamdansers/services/api_models.dart';
import 'package:tamdansers/services/api_service.dart';

class TeacherEditProfileScreen extends StatefulWidget {
  const TeacherEditProfileScreen({super.key});

  @override
  State<TeacherEditProfileScreen> createState() =>
      _TeacherEditProfileScreenState();
}

class _TeacherEditProfileScreenState extends State<TeacherEditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;
  String _teacherDbId = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _subjectController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final apiService = ApiService();

    // Start with cached auth data (fast)
    final name = await apiService.getUserName();
    final email = await apiService.getUserEmail();
    if (mounted) {
      setState(() {
        _nameController.text = name ?? '';
        _emailController.text = email ?? '';
      });
    }

    // Fetch full profile from API
    final entityId = await apiService.getEntityId();
    if (entityId != null && entityId.isNotEmpty) {
      _teacherDbId = entityId;
      final teacher = await apiService.getTeacherById(entityId);
      if (teacher != null && mounted) {
        setState(() {
          if (teacher.fullName.isNotEmpty) {
            _nameController.text = teacher.fullName;
          }
          if (teacher.email?.isNotEmpty == true) {
            _emailController.text = teacher.email!;
          }
          _phoneController.text = teacher.phone ?? '';
          _subjectController.text = teacher.specialization ?? '';
        });
      }
    }

    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _handleSave() async {
    if (_teacherDbId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot save: teacher ID not found.',
              style: GoogleFonts.inter()),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final apiService = ApiService();
      final nameParts = _nameController.text.trim().split(' ');
      final firstName = nameParts.first;
      final lastName =
          nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      final updated = TeacherDto(
        id: _teacherDbId,
        firstName: firstName,
        lastName: lastName,
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim().isNotEmpty
            ? _phoneController.text.trim()
            : null,
        specialization: _subjectController.text.trim().isNotEmpty
            ? _subjectController.text.trim()
            : null,
        isActive: true,
        createdAt: '',
      );

      final success = await apiService.updateTeacher(_teacherDbId, updated);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'Profile updated successfully!'
                  : 'Update failed. Please try again.',
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
            backgroundColor:
                success ? const Color(0xFF50E3C2) : Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Error: ${e.toString()}', style: GoogleFonts.inter()),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
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
          'Edit Profile',
          style: GoogleFonts.outfit(
            color: const Color(0xFF0D3B66),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF4A90E2)),
            )
          : SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image Section
            Center(
              child: Column(
                children: [
                  Bounceable(
                    onTap: () {},
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF4A90E2).withValues(alpha: 0.3),
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF4A90E2,
                                ).withValues(alpha: 0.15),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const CircleAvatar(
                            radius: 55,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(
                              'https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?semt=ais_hybrid&w=740&q=80',
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF4A90E2), Color(0xFF00C4FF)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF4A90E2,
                                  ).withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Change Photo',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF4A90E2),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 35),

            // Editable fields
            _buildInputField(
              'Full Name',
              _nameController,
              icon: Icons.person_rounded,
            ),
            _buildInputField(
              'Subject / Specialization',
              _subjectController,
              icon: Icons.menu_book_rounded,
              hintText: 'Enter your main subject',
            ),
            _buildInputField(
              'Email',
              _emailController,
              icon: Icons.email_rounded,
              keyboardType: TextInputType.emailAddress,
            ),
            _buildInputField(
              'Phone Number',
              _phoneController,
              icon: Icons.phone_rounded,
              hintText: 'Enter your phone number',
              keyboardType: TextInputType.phone,
            ),
            _buildInputField(
              'Address',
              _addressController,
              icon: Icons.location_on_rounded,
              hintText: 'Enter your address',
              maxLines: 2,
            ),

            const SizedBox(height: 40),

            // Save Changes Button
            Bounceable(
              onTap: _isSaving ? null : _handleSave,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0D3B66), Color(0xFF1E5B94)],
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
                child: Center(
                  child: _isSaving
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          'Save Changes',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Bounceable(
              onTap: () => Navigator.pop(context),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.inter(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller, {
    IconData? icon,
    bool isLocked = false,
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              color: Colors.grey.shade600,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: isLocked ? const Color(0xFFF3F6F8) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: isLocked
                  ? Border.all(color: Colors.transparent)
                  : Border.all(color: Colors.grey.shade100, width: 2),
              boxShadow: isLocked
                  ? []
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.01),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: TextFormField(
              controller: controller,
              enabled: !isLocked,
              keyboardType: keyboardType,
              maxLines: maxLines,
              style: GoogleFonts.inter(
                fontWeight: isLocked ? FontWeight.w500 : FontWeight.w600,
                color: isLocked
                    ? Colors.grey.shade600
                    : const Color(0xFF0D3B66),
                fontSize: isLocked ? 13 : 15,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: GoogleFonts.inter(
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w500,
                ),
                prefixIcon: icon != null
                    ? Icon(
                        icon,
                        size: 20,
                        color: isLocked
                            ? Colors.grey.shade400
                            : const Color(0xFF4A90E2),
                      )
                    : null,
                suffixIcon: isLocked
                    ? Icon(Icons.lock_rounded,
                        size: 16, color: Colors.grey.shade400)
                    : null,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: isLocked ? 10 : 16,
                  vertical: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
