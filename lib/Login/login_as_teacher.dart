import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tamdansers/contants/app_image.dart'; // Ensure this path is correct

class TeacherLoginScreen extends StatefulWidget {
  const TeacherLoginScreen({super.key});

  @override
  State<TeacherLoginScreen> createState() => _TeacherLoginScreenState();
}

class _TeacherLoginScreenState extends State<TeacherLoginScreen> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    const Color primaryTeal = Color(0xFF007A8C);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Center(
            child: Container(
              height: 40,
              width: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFE0F2F1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 18,
                  color: primaryTeal,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ),
        title: const Text(
          "EduPortal",
          style: TextStyle(
            color: Color(0xFF1D2939),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2F1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: SvgPicture.asset(
                AppImages.imageTeacher,
                height: 120,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "Login as Teacher",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D2939),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Please Input your information here ",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),

            const SizedBox(height: 40),

            _buildLabel("ID or Email"),
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.badge_outlined,
                  color: Colors.grey,
                ),
                hintText: "Please Input your ID or Email",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            _buildLabel("Password"),
            TextField(
              obscureText: _isObscured,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                hintText: "••••••••",
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscured
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: () => setState(() => _isObscured = !_isObscured),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(color: primaryTeal),
                ),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryTeal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Ensure this route is defined in your main.dart
                  Navigator.pushNamed(context, '/TeacherDashboard');
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Login",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.login, color: Colors.white),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),
            const Text(
              "Don't have account?",
              style: TextStyle(color: Colors.blue),
            ),
            const SizedBox(height: 12),

            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: primaryTeal),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(200, 45),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/RegisterScreen');
              },
              child: const Text(
                "Sign in",
                style: TextStyle(color: primaryTeal),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1D2939),
          ),
        ),
      ),
    );
  }
}
