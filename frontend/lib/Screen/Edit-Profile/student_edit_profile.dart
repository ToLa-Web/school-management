import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tamdansers/Login/role.dart';
import 'package:tamdansers/services/api_service.dart';

class StudentEditProfileScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const StudentEditProfileScreen({super.key, this.onBack});

  @override
  State<StudentEditProfileScreen> createState() =>
      _StudentEditProfileScreenState();
}

class _StudentEditProfileScreenState extends State<StudentEditProfileScreen> {
  // Controllers to handle text input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final apiService = ApiService();

    // Fetching the data you already have stored from sign-in
    final name = await apiService.getUserName();
    final email = await apiService.getUserEmail();

    if (mounted) {
      setState(() {
        _nameController.text = name ?? '';
        _emailController.text = email ?? '';
        _isLoading = false; // Data is loaded
      });
    }
  }

  // Method to handle updating profile logic
  Future<void> _handleSave() async {
    // Show a loading dialog or snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Updating profile...', style: GoogleFonts.inter()),
        duration: const Duration(seconds: 1),
      ),
    );

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Profile updated successfully!',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF50E3C2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
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
          onPressed: () {
            if (widget.onBack != null) {
              widget.onBack!();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          'Edit Profile',
          style: GoogleFonts.outfit(
            color: const Color(0xFF0D3B66),
            fontWeight: FontWeight.bold,
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
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Profile Picture Section
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
                                    color: const Color(
                                      0xFF4A90E2,
                                    ).withValues(alpha: 0.3),
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
                                      colors: [
                                        Color(0xFF4A90E2),
                                        Color(0xFF00C4FF),
                                      ],
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
                  Text(
                    'Personal Information',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: const Color(0xFF0D3B66),
                    ),
                  ),
                  const SizedBox(height: 15),

                  _buildModernTextField(
                    'Full Name',
                    _nameController,
                    icon: Icons.person_rounded,
                  ),
                  _buildModernTextField(
                    'Email',
                    _emailController,
                    icon: Icons.email_rounded,
                  ),
                  _buildModernTextField(
                    'Address',
                    _addressController,
                    hintText: 'Enter your address',
                    icon: Icons.location_on_rounded,
                  ),
                  _buildModernTextField(
                    'Phone Number',
                    _phoneController,
                    hintText: 'Enter your phone number',
                    icon: Icons.phone_rounded,
                  ),

                  const SizedBox(height: 20),
                  Text(
                    'Academic Information',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: const Color(0xFF0D3B66),
                    ),
                  ),
                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Expanded(
                        child: _buildModernTextField(
                          'Student ID',
                          TextEditingController(text: 'SID-9901'),
                          enabled: false,
                          icon: Icons.badge_rounded,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildModernTextField(
                          'Class',
                          TextEditingController(text: 'Grade 12A'),
                          enabled: false,
                          icon: Icons.class_rounded,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Save Changes Button
                  Bounceable(
                    onTap: _handleSave,
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
                        child: Text(
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

                  // Cancel Button
                  Bounceable(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.outfit(
                            color: Colors.grey.shade600,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Log Out Button
                  Bounceable(
                    onTap: () async {
                      await ApiService().logout();
                      if (mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RoleSelectionScreen(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF95738).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFF95738).withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.logout_rounded,
                            color: Color(0xFFE84C3D),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Log Out",
                            style: GoogleFonts.outfit(
                              color: const Color(0xFFE84C3D),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _buildModernTextField(
    String label,
    TextEditingController controller, {
    bool enabled = true,
    String? hintText,
    IconData? icon,
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
              color: enabled ? Colors.white : const Color(0xFFF3F6F8),
              borderRadius: BorderRadius.circular(16),
              border: enabled
                  ? Border.all(color: Colors.grey.shade100, width: 2)
                  : Border.all(color: Colors.transparent),
              boxShadow: enabled
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.01),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: TextFormField(
              controller: controller,
              enabled: enabled,
              style: GoogleFonts.inter(
                fontWeight: enabled ? FontWeight.w600 : FontWeight.w500,
                color: enabled ? const Color(0xFF0D3B66) : Colors.grey.shade600,
                fontSize: 15,
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
                        color: enabled
                            ? const Color(0xFF4A90E2)
                            : Colors.grey.shade400,
                      )
                    : null,
                suffixIcon: !enabled
                    ? Icon(
                        Icons.lock_rounded,
                        size: 16,
                        color: Colors.grey.shade400,
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
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
