import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final int initialTab;
  const LoginScreen({super.key, this.initialTab = 1});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: initialTab, // Set automatically from role selection
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const SizedBox(height: 60),
            // Fixed Logo Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.school,
                size: 60,
                color: Color(0xFF0D47A1),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Welcome Back",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // Fixed TabBar Selector
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  color: const Color(0xFF0D47A1),
                  borderRadius: BorderRadius.circular(8),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                tabs: const [
                  Tab(text: "Teacher"),
                  Tab(text: "Student"),
                  Tab(text: "Parent"),
                ],
              ),
            ),

            // Dynamic Content Area: Only this part changes
            Expanded(
              child: TabBarView(
                children: [
                  _buildLoginForm(
                    context,
                    "Teacher",
                    Icons.badge_outlined,
                  ), // Teacher
                  _buildLoginForm(
                    context,
                    "Student",
                    Icons.school_outlined,
                  ), // Student
                  _buildLoginForm(
                    context,
                    "Parent",
                    Icons.family_restroom,
                  ), // Parent
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm(
    BuildContext context,
    String roleName,
    IconData roleIcon,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Login as $roleName",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(height: 16),

          // Identity Field
          _buildTextField(
            label: roleName == "Teacher" ? "Teacher ID" : "Student ID",
            hint: "Enter your ID",
            icon: Icons.person_outline,
          ),

          const SizedBox(height: 16),

          // Password Field
          _buildTextField(
            label: "Password",
            hint: "••••••••",
            icon: Icons.lock_outline,
            isPassword: true,
          ),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text(
                "Forgot Password?",
                style: TextStyle(color: Color(0xFF0D47A1)),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Action Button
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D47A1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {},
              child: const Text(
                "Login",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          obscureText: isPassword,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey),
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFF5F7F9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
