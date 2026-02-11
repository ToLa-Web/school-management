import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // FIX: Added missing import
import 'package:tamdansers/contants/app_image.dart'; // FIX: Added missing import

class ParentLoginScreen extends StatefulWidget {
  // FIX: Changed to StatefulWidget for visibility toggle
  const ParentLoginScreen({super.key});

  @override
  State<ParentLoginScreen> createState() => _ParentLoginScreenState();
}

class _ParentLoginScreenState extends State<ParentLoginScreen> {
  bool _isObscured = true; // State for password visibility

  @override
  Widget build(BuildContext context) {
    const Color primaryTeal = Color(0xFF007A8C);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xFFE0F2F1),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: primaryTeal,
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
            const SizedBox(height: 40),

            // 1. Family Icon Container
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2F1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: SvgPicture.asset(
                AppImages.imageParent, // Using your existing constant
                height: 120,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 24),

            // 2. Title and Subtitle
            const Text(
              "Login as Parent",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D2939),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Please Input your information here",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),

            const SizedBox(height: 40),

            // 3. Email Input
            _buildInputLabel("ID or Email"),
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.person_outline,
                  color: Colors.grey,
                ),
                hintText: "Enter your name",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 4. Password Input with Toggle Fix
            _buildInputLabel("Password"),
            TextField(
              obscureText: _isObscured,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                hintText: "••••••••••••",
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
                  "Forgot password?",
                  style: TextStyle(color: primaryTeal),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 6. Login Button
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
                  Navigator.pushNamed(context, '/ParentDashboard');
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

            // 7. Register Button
            SizedBox(
              width: 200,
              height: 45,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: primaryTeal),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/RegisterScreen');
                },
                child: const Text(
                  "Sign in",
                  style: TextStyle(color: primaryTeal),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1D2939),
          ),
        ),
      ),
    );
  }
}
