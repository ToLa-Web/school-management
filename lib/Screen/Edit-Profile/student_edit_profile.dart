import 'package:flutter/material.dart';

class StudentEditProfileScreen extends StatefulWidget {
  const StudentEditProfileScreen({super.key});

  @override
  State<StudentEditProfileScreen> createState() =>
      _StudentEditProfileScreenState();
}

class _StudentEditProfileScreenState extends State<StudentEditProfileScreen> {
  // Controllers to handle text input
  final TextEditingController _nameController = TextEditingController(
    text: 'សេង វិបុល',
  );
  final TextEditingController _addressController = TextEditingController(
    text: 'ផ្ទះលេខ ១២៣, ភ្នំពេញ',
  );
  final TextEditingController _phoneController = TextEditingController(
    text: '012 345 678',
  );
  final TextEditingController _emailController = TextEditingController(
    text: 'vibol.seng@school.edu.kh',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black54,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'កែសម្រួលព័ត៌មានរូប',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Profile Picture Section
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(
                      0xFFFFE0B2,
                    ), // Light peach background
                    backgroundImage: NetworkImage(
                      'https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?semt=ais_hybrid&w=740&q=80',
                    ), // Replace with local image
                  ),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit, size: 16, color: Colors.cyan),
                    label: const Text(
                      'ប្តូររូបភាព',
                      style: TextStyle(color: Colors.cyan),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.cyan.withValues(alpha: 0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            const Text(
              'ព័ត៌មានផ្ទាល់ខ្លួន',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 15),

            // Input Fields
            _buildTextField('ឈ្មោះពេញ', _nameController),
            _buildTextField('អាសយដ្ឋាន', _addressController),
            _buildTextField('លេខទូរស័ព្ទ', _phoneController),
            _buildTextField('អ៊ីមែល', _emailController),

            const SizedBox(height: 20),
            const Text(
              'ព័ត៌មានការសិក្សា',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 15),

            // Read-only info (grayed out in your image)
            _buildTextField(
              'លេខសម្គាល់សិស្ស',
              TextEditingController(text: 'SID-2023-9901'),
              enabled: false,
            ),
            _buildTextField(
              'ថ្នាក់រៀន',
              TextEditingController(text: 'ថ្នាក់ទី ១២A'),
              enabled: false,
            ),

            const SizedBox(height: 40),

            // Action Buttons
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
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
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'បោះបង់',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.black54, fontSize: 14),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            enabled: enabled,
            decoration: InputDecoration(
              filled: !enabled,
              fillColor: enabled ? Colors.transparent : Colors.grey[50],
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.black12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.black12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
