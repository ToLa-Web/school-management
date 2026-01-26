import 'package:flutter/material.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: const [
            Icon(Icons.school, color: Color(0xFF007A8C)),
            SizedBox(width: 8),
            Text(
              "DENH JERNG SERS",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "ជ្រើសរើសតួនាទីរបស់អ្នក",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D2939),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "ជ្រើសរើសច្រកចូលរបស់អ្នក ដើម្បីប្រើប្រាស់ផ្ទាំងគ្រប់គ្រងសាលាផ្ទាល់ខ្លួន។",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 13),
            ),
            const SizedBox(height: 30),
            _buildRoleCard(
              context,
              icon: Icons.menu_book,
              title: "គ្រូបង្រៀន",
              subtitle:
                  "គ្រប់គ្រងថ្នាក់រៀន កត់ត្រាវត្តមាន និងដាក់ពិន្ទុលើកិច្ចការសិស្ស។",
              buttonText: "បន្តក្នុងនាមជា គ្រូបង្រៀន",
              route: '/login-teacher',
            ),

            // Student Card
            _buildRoleCard(
              context,
              icon: Icons.school,
              title: "សិស្ស",
              subtitle:
                  "មើលកាលវិភាគរបស់អ្នក ពិនិត្យលទ្ធផល និងដាក់កិច្ចការផ្ទះ។",

              buttonText: "បន្តក្នុងនាមជា សិស្ស",
              route: '/login-student',
            ),

            // Parent Card
            _buildRoleCard(
              context,
              icon: Icons.people,
              title: "មាតាបិតា",
              subtitle: "តាមដានវឌ្ឍនភាព មើលការជូនដំណឹង និងទំនាក់ទំនងជាមួយគ្រូ។",
              buttonText: "បន្តក្នុងនាមជា មាតាបិតា",
              route: '/ParentLoginScreen',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonText,
    required String route,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF007A8C), size: 30),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.black54, fontSize: 14),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, route),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE0F2F1),
                foregroundColor: const Color(0xFF007A8C),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(buttonText),
            ),
          ),
        ],
      ),
    );
  }
}
