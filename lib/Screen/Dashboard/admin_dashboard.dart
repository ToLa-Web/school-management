import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:tamdansers/Screen/Role_Admin/admin_control_parent.dart';
import 'package:tamdansers/Screen/Role_Admin/admin_control_report.dart';
import 'package:tamdansers/Screen/Role_Admin/admin_control_student.dart';
import 'package:tamdansers/Screen/Role_Admin/admin_control_teacher.dart'
    hide AdminControlParent;
// Ensure these imports match your actual file paths
// import 'package:tamdansers/Screen/Edit-Profile/student_edit_profile.dart';
// import 'package:tamdansers/contants/app_text_style.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _pageIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  // Define the screens for the bottom navigation
  final List<Widget> _screens = [
    const AdminHomeContent(),
    const Center(child: Text("Users Screen")),
    const Center(child: Text("Analytics Screen")),
    const Center(child: Text("Settings Screen")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: IndexedStack(index: _pageIndex, children: _screens),
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
        color: const Color(0xFF1A1FB1),
        buttonBackgroundColor: const Color(0xFF1A1FB1),
        backgroundColor: const Color(0xFFF5F7FA),
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
}

class AdminHomeContent extends StatefulWidget {
  const AdminHomeContent({super.key});

  @override
  State<AdminHomeContent> createState() => _AdminHomeContentState();
}

class _AdminHomeContentState extends State<AdminHomeContent> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(context),
          _buildStatsRow(),
          _buildMenuSection(),
        ],
      ),
    );
  }

  // --- HEADER SECTION ---
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 60, 25, 50),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1FB1),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  // Uncomment and use your actual navigation here
                  /*
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const StudentEditProfileScreen()),
                  );
                  */
                },
                child: const CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                    'https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?w=740',
                  ),
                ),
              ),
              const SizedBox(width: 15),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "លោក ម៉ៅ វិបុល",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "អភិបាលសាលា • #29401",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.notifications_active, color: Colors.white),
            ],
          ),
          const SizedBox(height: 30),
          const Text(
            "ជវាំងគ្រប់គ្រងអភិបាល",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "ទិដ្ឋភាពទូទៅនៃប្រព័ន្ធគ្រប់គ្រងសាលារៀន",
            style: TextStyle(color: Colors.white60, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // --- STATS SECTION ---
  Widget _buildStatsRow() {
    return Transform.translate(
      offset: const Offset(0, -35),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            _statCard("សរុបសិស្ស", "១២០០", hasIncrease: true),
            const SizedBox(width: 10),
            _statCard("គ្រូ", "៨០"),
            const SizedBox(width: 10),
            _statCard("មាតាបិតា", "៩៥០"),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, {bool hasIncrease = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1FB1),
                  ),
                ),
                if (hasIncrease) ...[
                  const Spacer(),
                  const Text(
                    "+៥%",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- MENU SECTION ---
  Widget _buildMenuSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "ម៉ូឌុលគ្រប់គ្រង",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "មើលទាំងអស់",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1.1,
            children: [
              _menuItem(
                "គ្រប់គ្រងគ្រូបង្រៀន",
                "គ្រូសកម្ម: ៧៨ នាក់",
                Icons.person,
                Colors.indigo,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminControlTeacher(),
                    ),
                  );
                  // Add navigation for teachers here if needed
                },
              ),
              _menuItem(
                "គ្រប់គ្រងសិស្ស",
                "សិស្សសកម្ម: ១១៨០ នាក់",
                Icons.school,
                Colors.indigo,
                onTap: () {
                  // NAVIGATE TO YOUR NEW SCREEN HERE
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminControlStudent(),
                    ),
                  );
                },
              ),
              _menuItem(
                "គ្រប់គ្រងអាណាព្យាបាល",
                "អាណាព្យាបាល: ១៨០ នាក់",
                Icons.person_2_outlined,
                Colors.indigo,
                onTap: () {
                  // NAVIGATE TO YOUR NEW SCREEN HERE
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminControlParent(),
                    ),
                  );
                },
              ),
              // ... Repeat for other items ...
              _menuItem(
                "របាយការណ៍សាលា",
                "របាយការណ៍ប្រចាំខែ",
                Icons.campaign,
                Colors.indigo,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminReportSchool(),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 10), // Padding for bottom nav
        ],
      ),
    );
  }

  Widget _menuItem(
    String title,
    String subTitle,
    IconData icon,
    Color color, {
    bool isDark = false,
    VoidCallback? onTap, // Add this line
  }) {
    return InkWell(
      // Wrap with InkWell for touch feedback
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isDark ? color : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: isDark ? Colors.white : color, size: 24),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            Text(
              subTitle,
              style: TextStyle(
                fontSize: 10,
                color: isDark ? Colors.white70 : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
