import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Added missing import
import 'package:tamdansers/contants/app_image.dart'; // Ensure this matches your file path

class StudentLoginScreen extends StatefulWidget {
  const StudentLoginScreen({super.key});

  @override
  State<StudentLoginScreen> createState() => _StudentLoginScreenState();
}

class _StudentLoginScreenState extends State<StudentLoginScreen> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    const Color studentPrimary = Color(0xFF007A8C);
    const Color lightBlueBg = Color(0xFFE8EAF6);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: lightBlueBg,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: studentPrimary,
                size: 18,
              ),
              onPressed: () => Navigator.pop(context),
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

            // Fixed Image Reference
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: lightBlueBg,
                borderRadius: BorderRadius.circular(24),
              ),
              child: SvgPicture.asset(
                // Corrected from AppImages.imageStudent if your class uses imageSelectRole
                AppImages.imageStudent,
                height: 120,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "Login as Student",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D2939),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Please Input your information here",//សូមបញ្ចូលព័ត៌មានរបស់អ្នកដើម្បីចូលប្រើប្រាស់
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),

            const SizedBox(height: 40),

            _buildLabel("ID or Email"),
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.person_outline,
                  color: Colors.grey,
                ),
                hintText: "Please Input ID or Email",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
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
                  borderRadius: BorderRadius.circular(14),
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
                  style: TextStyle(
                    color: studentPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: studentPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/StudentDashboard');
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Login",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    SizedBox(width: 8),
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
                side: const BorderSide(color: studentPrimary),
                minimumSize: const Size(220, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/RegisterScreen');
              },
              child: const Text(
                "Sign in",
                style: TextStyle(
                  color: studentPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 40),
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
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
