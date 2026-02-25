
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class AdminControlTeacher extends StatefulWidget {
  const AdminControlTeacher({super.key});

  @override
  State<AdminControlTeacher> createState() => _AdminControlTeacherState();
}

class _AdminControlTeacherState extends State<AdminControlTeacher> {
  int _pageIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  // Color Constants
  static const Color primaryBlue = Color(0xFF1A1FB1);
  static const Color scaffoldBg = Color(0xFFF5F7FA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBg,
      // The body handles the main content scrolling
      body: IndexedStack(
        index: _pageIndex,
        children: [
          _buildHomeContent(), // Main Dashboard Content
          const Center(child: Text("Users Screen")),
          const Center(child: Text("Analytics Screen")),
          const Center(child: Text("Settings Screen")),
        ],
      ),

      // --- ADDED NAVIGATION BAR ---
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _pageIndex,
        height: 65.0,
        items: const <Widget>[
          Icon(Icons.grid_view_rounded, size: 30, color: Colors.white),
          Icon(Icons.people, size: 30, color: Colors.white),
          Icon(Icons.bar_chart, size: 30, color: Colors.white),
          Icon(Icons.settings, size: 30, color: Colors.white),
        ],
        color: primaryBlue,
        buttonBackgroundColor: primaryBlue,
        backgroundColor: Colors.transparent, // Makes the curve look smooth
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
      ),
    );
  }

  // Refactored the dashboard UI into a method to keep the build clean
  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 40),
            decoration: const BoxDecoration(
              color: primaryBlue,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(35)),
            ),
            child: Column(
              children: [
                _buildHeaderTopRow(),
                const SizedBox(height: 30),
                const Row(
                  children: [
                    _TopStatCard(
                      label: "សំណើសុំច្បាប់សរុប",
                      value: "១២",
                      sub: "ក្នុងខែនេះ",
                    ),
                    SizedBox(width: 15),
                    _TopStatCard(
                      label: "សកម្មភាពថ្មីៗ",
                      value: "២៥",
                      sub: "ថ្ងៃនេះ",
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Requests Section
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionTitle(title: "សំណើសុំការអនុម័ត", color: Colors.amber),
                SizedBox(height: 15),
                _TeacherRequestCard(
                  name: "អ្នកគ្រូ លឹម ស្រីនី",
                  requestType: "សំណើសុំច្បាប់ឈប់សម្រាក",
                  reason: "មានធុរៈផ្ទាល់ខ្លួនចាំបាច់រយៈពេល ២ថ្ងៃ",
                  time: "១០ នាទីមុន",
                ),
                _TeacherRequestCard(
                  name: "លោកគ្រូ សុខ ហេង",
                  requestType: "សុំអនុម័តបញ្ជីពិន្ទុ (ថ្នាក់ទី១២A)",
                  fileName: "Score_Final_T1.pdf",
                  time: "១ ម៉ោងមុន",
                  isScoreRequest: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 100), // Space for Nav Bar
        ],
      ),
    );
  }

  Widget _buildHeaderTopRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
        ),
        const Column(
          children: [
            Text(
              "គ្រប់គ្រងគ្រូបង្រៀន",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "ការត្រួតពិនិត្យ និងការអនុម័ត",
              style: TextStyle(color: Colors.white54, fontSize: 10),
            ),
          ],
        ),
        const Icon(Icons.search, color: Colors.white),
      ],
    );
  }
}

// --- SUPPORTING UI COMPONENTS ---

class _SectionTitle extends StatelessWidget {
  final String title;
  final Color color;
  const _SectionTitle({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 4, height: 20, color: color),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

// Ensure cards are wrapped in Material to prevent the "Red Screen" error
class _TeacherRequestCard extends StatelessWidget {
  final String name, requestType, time;
  final String? reason, fileName;
  final bool isScoreRequest;

  const _TeacherRequestCard({
    required this.name,
    required this.requestType,
    required this.time,
    this.reason,
    this.fileName,
    this.isScoreRequest = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      // This prevents the ListTile error from image_d4fb01.png
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: isScoreRequest
                    ? Colors.blue[50]
                    : Colors.orange[50],
                child: Icon(
                  isScoreRequest ? Icons.person : Icons.person_3,
                  color: isScoreRequest ? Colors.blue : Colors.orange,
                ),
              ),
              title: Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                requestType,
                style: const TextStyle(color: Color(0xFF1A1FB1), fontSize: 12),
              ),
              trailing: Text(
                time,
                style: const TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ),
            if (reason != null)
              Text(
                "\"$reason\"",
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: _buildActionBtn(
                    "អនុម័ត",
                    const Color(0xFF1A1FB1),
                    true,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildActionBtn(
                    "បដិសេធ",
                    const Color(0xFFF1F2F6),
                    false,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionBtn(String label, Color color, bool primary) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: primary ? Colors.white : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _TopStatCard extends StatelessWidget {
  final String label, value, sub;
  const _TopStatCard({
    required this.label,
    required this.value,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 10),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              sub,
              style: const TextStyle(color: Colors.white38, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
