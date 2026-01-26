import 'package:flutter/material.dart';

class TeacherLoginScreen extends StatefulWidget {
  const TeacherLoginScreen({super.key});

  @override
  State<TeacherLoginScreen> createState() => _TeacherLoginScreenState();
}

class _TeacherLoginScreenState extends State<TeacherLoginScreen> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    // Primary Teal color from image_10584b
    const Color primaryTeal = Color(0xFF007A8C);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA), // Off-white background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Center(
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2F1), // Light teal circle
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

            // 1. Icon Container (Matches image_10584b)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2F1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.school, size: 60, color: primaryTeal),
            ),

            const SizedBox(height: 24),

            // 2. Main Title (Matches image_10584b)
            const Text(
              "ចូលប្រើជាគ្រូបង្រៀន",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D2939),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "សូមបញ្ចូលព័ត៌មានរបស់អ្នកដើម្បីចូលប្រើប្រាស់",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),

            const SizedBox(height: 40),

            // 3. ID Input Field
            _buildLabel("លេខសម្គាល់បុគ្គលិក ឬ អ៊ីមែល"),
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.badge_outlined,
                  color: Colors.grey,
                ),
                hintText: "បញ្ចូលលេខសម្គាល់បុគ្គលិក",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 4. Password Field with Visibility Toggle
            _buildLabel("លេខសម្ងាត់"),
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

            // 5. Forgot Password
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  "ភ្លេចលេខសម្ងាត់?",
                  style: TextStyle(color: primaryTeal),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 6. Login Button with Arrow (Matches image_10584b)
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
                  Navigator.pushNamed(context, '/TeacherDashboard');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "ចូលប្រើ",
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
              "មិនទាន់មានគណនី?",
              style: TextStyle(color: Colors.blue),
            ),
            const SizedBox(height: 12),

            // 7. Register Outline Button
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
                "ចុះឈ្មោះគណនីថ្មី",
                style: TextStyle(color: primaryTeal),
              ),
            ),

            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.help_outline, size: 16, color: Colors.grey),
                SizedBox(width: 5),
                Text(
                  "ត្រូវការជំនួយក្នុងការចូលប្រើ?",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Alan 1.11.0\n© 2096 EduPortal Systems Inc.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
            const SizedBox(height: 20),
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
