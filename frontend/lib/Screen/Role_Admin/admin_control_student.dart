import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class AdminControlStudent extends StatefulWidget {
  const AdminControlStudent({super.key});

  @override
  State<AdminControlStudent> createState() => _AdminControlStudentState();
}

class _AdminControlStudentState extends State<AdminControlStudent> {
  int _pageIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  // Color Constants matching your theme
  static const Color primaryBlue = Color(0xFF1A1FB1);
  static const Color scaffoldBg = Color(0xFFF5F7FA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBg,
      // IndexedStack maintains the state of each page so they don't reload
      body: IndexedStack(
        index: _pageIndex,
        children: [
          _buildHomeContent(), // Main Student Oversight Content
          const Center(child: Text("Users Screen")),
          const Center(child: Text("Analytics Screen")),
          const Center(child: Text("Settings Screen")),
        ],
      ),

      // --- CURVED NAVIGATION BAR ---
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
        backgroundColor: Colors.transparent,
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

  // Refactored Student Dashboard Content
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _OversightHeaderStat(
                      label: "សកម្មភាពសរុប",
                      value: "២៤៨",
                      change: "+១២%",
                      isPositive: true,
                    ),
                    _OversightHeaderStat(
                      label: "ពិន្ទុមធ្យម",
                      value: "B+",
                      change: "ល្អប្រសើរ",
                      isPositive: true,
                    ),
                    _OversightHeaderStat(
                      label: "អវត្តមាន",
                      value: "៩៨%",
                      change: "ទាប",
                      isPositive: false,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Student Requests Section
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionTitle(
                  title: "សំណើសុំរបស់សិស្ស",
                  color: Colors.blue,
                ),
                const SizedBox(height: 15),
                const _StudentRequestCard(
                  name: "សុខ ចាន់ដារ៉ា",
                  id: "ID-20492",
                  gpa: "៣.៨",
                  absent: "២ ថ្ងៃ",
                  requestType: "ច្បាប់ឈប់សម្រាក",
                ),
                const _StudentRequestCard(
                  name: "កែវ មុន្នី",
                  id: "ID-20381",
                  gpa: "២.៥",
                  absent: "០ ថ្ងៃ",
                  requestType: "សុំប្តូរថ្នាក់",
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
              "ត្រួតពិនិត្យសិស្ស",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "STUDENT OVERSIGHT",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 10,
                letterSpacing: 1.2,
              ),
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

class _OversightHeaderStat extends StatelessWidget {
  final String label, value, change;
  final bool isPositive;

  const _OversightHeaderStat({
    required this.label,
    required this.value,
    required this.change,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          change,
          style: TextStyle(
            color: isPositive ? Colors.greenAccent : Colors.redAccent,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _StudentRequestCard extends StatelessWidget {
  final String name, id, gpa, absent, requestType;

  const _StudentRequestCard({
    required this.name,
    required this.id,
    required this.gpa,
    required this.absent,
    required this.requestType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFFE6B89C),
                child: Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      id,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1FB1).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  requestType,
                  style: const TextStyle(
                    color: Color(0xFF1A1FB1),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Color(0xFFF1F2F6)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _miniStat("លទ្ធផលសិក្សា", gpa),
              _miniStat("អវត្តមាន", absent),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _actionBtn("យល់ព្រម", const Color(0xFF1A1FB1), true),
              ),
              const SizedBox(width: 10),
              Expanded(child: _actionBtn("បដិសេធ", Colors.white, false)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String label, String val) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        const SizedBox(height: 4),
        Text(
          val,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }

  Widget _actionBtn(String label, Color bg, bool isPrimary) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: isPrimary
            ? null
            : Border.all(color: const Color(0xFF1A1FB1).withOpacity(0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isPrimary ? Colors.white : Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}
