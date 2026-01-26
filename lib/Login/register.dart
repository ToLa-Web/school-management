import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F9FA),
        appBar: _buildAppBar(context),
        body: Column(
          children: [
            _buildFixedHeader(),
            _buildFixedTabBar(),
            Expanded(
              child: TabBarView(
                children: [
                  _buildForm(role: "Teacher"), // គ្រូបង្រៀន
                  _buildForm(role: "Student"), // សិស្ស
                  _buildForm(role: "Parent"), // មាតាបិតា
                ],
              ),
            ),
            _buildFixedFooter(context),
          ],
        ),
      ),
    );
  }

  // Header and Tabs stay fixed at the top
  Widget _buildFixedHeader() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            "ចូលរួមជាមួយសាលាយើង",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            "សូមបំពេញព័ត៌មានលម្អិតរបស់អ្នកខាងក្រោមដើម្បីចាប់ផ្តើម។",
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildFixedTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFECEFF1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TabBar(
        indicator: BoxDecoration(
          color: Color(0xFF007A8C),
          borderRadius: BorderRadius.circular(15),
        ),
        labelColor: const Color(0xFFFFFFFF),
        unselectedLabelColor: const Color(0xFF007A8C),
        tabs: const [
          Tab(text: "   គ្រូបង្រៀន    "),
          Tab(text: "   សិស្ស    "),
          Tab(text: "   មាតាបិតា    "),
        ],
      ),
    );
  }

  Widget _buildForm({required String role}) {
    String idLabel = role == "Teacher"
        ? "លេខសម្គាល់បុគ្គលិក"
        : "លេខសម្គាល់សិស្ស";
    if (role == "Parent") idLabel = "លេខសម្គាល់សិស្ស (កូនរបស់អ្នក)";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _inputField("ឈ្មោះពេញ", "បញ្ចូលឈ្មោះពេញ", Icons.person_outline),
          _inputField(
            "អាសយដ្ឋានអ៊ីមែល",
            "name@school.edu",
            Icons.email_outlined,
          ),
          _inputField("លេខទូរស័ព្ទ", "012 345 678", Icons.phone_outlined),
          _inputField(idLabel, "បញ្ចូលលេខកូដសម្គាល់", Icons.badge_outlined),
          _inputField("លេខសម្ងាត់", " ", Icons.lock_outline, isPass: true),
        ],
      ),
    );
  }

  Widget _buildFixedFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007A8C), // Fixed Teal Button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/login-teacher');
              },
              child: const Text(
                "បង្កើតគណនី",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("មានគណនីរួចហើយ? "),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "ចូលប្រើ",
                  style: TextStyle(
                    color: Color(0xFF007A8C),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _inputField(
    String label,
    String hint,
    IconData icon, {
    bool isPass = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            obscureText: isPass,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.grey),
              hintText: hint,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF007A8C)),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text("EduPortal", style: TextStyle(color: Colors.black)),
      centerTitle: true,
    );
  }
}
