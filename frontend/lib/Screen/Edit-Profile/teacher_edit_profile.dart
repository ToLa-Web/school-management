import 'package:flutter/material.dart';
import 'package:tamdansers/services/api_service.dart';

class TeacherEditProfileScreen extends StatefulWidget {
  const TeacherEditProfileScreen({super.key});

  @override
  State<TeacherEditProfileScreen> createState() =>
      _TeacherEditProfileScreenState();
}

class _TeacherEditProfileScreenState extends State<TeacherEditProfileScreen> {
  String _userName = '';
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final apiService = ApiService();
    final name = await apiService.getUserName();
    final email = await apiService.getUserEmail();
    if (mounted) {
      setState(() {
        _userName = name ?? '';
        _userEmail = email ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color teacherPrimary = Color(0xFF007A7C);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Teacher Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image Section
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.blueGrey.shade100,
                        backgroundImage: const NetworkImage(
                          'https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?semt=ais_hybrid&w=740&q=80',
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(0, 122, 124, 1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Change Photo',
                    style: TextStyle(
                      color: teacherPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Read-Only Teacher Info
            Row(
              children: [
                Expanded(child: _buildField('Teacher ID', 'TCH-2024-001')),
                const SizedBox(width: 15),
                Expanded(child: _buildField('Department', 'Science')),
              ],
            ),
            const SizedBox(height: 15),
            _buildField('Full Name', _userName, icon: Icons.person_outline),
            const SizedBox(height: 15),
            _buildField(
              'Subject',
              '',
              icon: Icons.book_outlined,
              hintText: 'Enter your subject',
            ),
            const SizedBox(height: 15),
            _buildField(
              'Email',
              _userEmail,
              icon: Icons.email_outlined,
            ),
            const SizedBox(height: 15),
            _buildField(
              'Phone Number',
              '',
              icon: Icons.phone_outlined,
              hintText: 'Enter your phone number',
            ),
            const SizedBox(height: 15),
            const Text(
              'Current Address',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              child: const Text(
                'Enter your address',
                style: TextStyle(fontSize: 14, height: 1.5, color: Colors.grey),
              ),
            ),

            const SizedBox(height: 30),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: teacherPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Cancel Button
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    String value, {
    IconData? icon,
    bool isLocked = false,
    String? hintText,
  }) {
    final displayText = value.isNotEmpty ? value : (hintText ?? '');
    final textColor = value.isNotEmpty
        ? (isLocked ? Colors.black38 : Colors.black87)
        : Colors.grey;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: isLocked ? const Color(0xFFF1F3F4) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12),
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: Colors.grey),
                const SizedBox(width: 10),
              ],
              Text(
                displayText,
                style: TextStyle(
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
