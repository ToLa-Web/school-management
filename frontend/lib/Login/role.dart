import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tamdansers/contants/app_image.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB), // Light greyish background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. Title at the top
              const Text(
                "Select Your Role",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 40),

              // 2. Illustration Image
              SvgPicture.asset(
                AppImages.imageSelectRole,
                height: MediaQuery.of(context).size.height * 0.45,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 50),

              // 3. Teacher Button
              _buildLargeButton(
                text: "Teacher",
                onPressed: () => Navigator.pushNamed(context, '/login-teacher'),
              ),
              const SizedBox(height: 15),

              // 4. Student Button
              _buildLargeButton(
                text: "Student",
                onPressed: () => Navigator.pushNamed(context, '/login-student'),
              ),
              const SizedBox(height: 15),

              // 5. Parent Button
              _buildLargeButton(
                text: "Parent",
                onPressed: () =>
                    Navigator.pushNamed(context, '/ParentLoginScreen'),
              ),
              SizedBox(height: 10),
              _buildLargeButton(
                text: "Admin",
                onPressed: () =>
                    Navigator.pushNamed(context, '/AdminLoginScreen'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Custom helper to create the blue rounded buttons
  Widget _buildLargeButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(
            0xFF4A89F3,
          ), // Bright blue color from image
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Fully rounded corners
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
