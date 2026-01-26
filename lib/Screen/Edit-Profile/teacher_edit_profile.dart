import 'package:flutter/material.dart';

class TeacherEditProfileScreen extends StatelessWidget {
  const TeacherEditProfileScreen({super.key});

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
          'កែសម្រួលប្រវត្តិរូបគ្រូបង្រៀន',
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
                    'ផ្លាស់ប្តូររូបភាព',
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
                Expanded(child: _buildField('អត្តលេខគ្រូ', 'TCH-2024-001')),
                const SizedBox(width: 15),
                Expanded(child: _buildField('ដេប៉ាតឺម៉ង់', 'វិទ្យាសាស្ត្រ')),
              ],
            ),
            const SizedBox(height: 15),
            _buildField('ឈ្មោះពេញ', 'សេង វណ្ណា', icon: Icons.person_outline),
            const SizedBox(height: 15),
            _buildField(
              'មុខវិជ្ជាបង្រៀន',
              'រូបវិទ្យា',
              icon: Icons.book_outlined,
            ),
            const SizedBox(height: 15),
            _buildField(
              'អ៊ីមែល',
              'sok.vanna@school.edu.kh',
              icon: Icons.email_outlined,
            ),
            const SizedBox(height: 15),
            _buildField(
              'លេខទូរស័ព្ទ',
              '098 012 345 678',
              icon: Icons.phone_outlined,
            ),
            const SizedBox(height: 15),
            const Text(
              'អាសយដ្ឋានបច្ចុប្បន្ន',
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
                'ផ្ទះលេខ ១២៣, ផ្លូវ ៤៥៦, រាជធានីភ្នំពេញ',
                style: TextStyle(fontSize: 14, height: 1.5),
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
                  'រក្សាទុកការផ្លាស់ប្តូរ',
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
                  'បោះបង់',
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
  }) {
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
                value,
                style: TextStyle(
                  color: isLocked ? Colors.black38 : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
