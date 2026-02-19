
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:tamdansers/Screen/Edit-Profile/student_edit_profile.dart';
import 'package:tamdansers/contants/app_text_style.dart';

class StudentScheduleScreen extends StatefulWidget {
  const StudentScheduleScreen({super.key});

  @override
  State<StudentScheduleScreen> createState() => _StudentScheduleScreenState();
}

class _StudentScheduleScreenState extends State<StudentScheduleScreen> {
  int _pageIndex = 0;
  int _selectedSemester = 1;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  // Design Palette
  final Color primaryTeal = const Color(0xFF007A7C);
  final Color scaffoldBg = const Color(0xFFF8FAFC);
  final Color cardWhite = Colors.white;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      _buildScheduleMainContent(),
      Center(child: Text("Library", style: AppTextStyle.sectionTitle20)),
      Center(child: Text("Messages", style: AppTextStyle.sectionTitle20)),
      const StudentEditProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: _pageIndex == 0 ? _buildModernAppBar() : null,
      body: IndexedStack(index: _pageIndex, children: screens),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildScheduleMainContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildSemesterToggle(),
          const SizedBox(height: 30),
          _buildSectionHeader(
            'Weekly Schedule',
            _selectedSemester == 1 ? 'Week 12' : 'Week 1',
          ),
          const SizedBox(height: 20),
          _buildTimeline(),
          const SizedBox(height: 30),
          _buildSectionHeader('Year-end Review', 'Upcoming'),
          const SizedBox(height: 15),
          _buildModernReviewBanner(),
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildSemesterToggle() {
    return Container(
      height: 55,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _toggleButton('Semester 1', 1),
          _toggleButton('Semester 2', 2),
        ],
      ),
    );
  }

  Widget _toggleButton(String label, int val) {
    bool isSelected = _selectedSemester == val;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedSemester = val),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: isSelected ? primaryTeal : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.blueGrey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeline() {
    return Column(
      children: _selectedSemester == 1
          ? [
              _modernScheduleTile(
                Icons.functions,
                'Mathematics',
                '08:00 AM',
                'Room 302',
                Colors.orange,
                true,
              ),
              _modernScheduleTile(
                Icons.biotech,
                'Science',
                '10:00 AM',
                'Lab 01',
                Colors.blue,
                false,
              ),
              _modernScheduleTile(
                Icons.history_edu,
                'Khmer Literature',
                '01:30 PM',
                'Room 105',
                Colors.purple,
                false,
              ),
              _modernScheduleTile(
                Icons.language,
                'English',
                '03:00 PM',
                'Room 201',
                Colors.red,
                false,
                isLast: true,
              ),
            ]
          : [
              _modernScheduleTile(
                Icons.museum,
                'History',
                '08:00 AM',
                'Room 401',
                Colors.brown,
                true,
              ),
              _modernScheduleTile(
                Icons.computer,
                'ICT',
                '10:00 AM',
                'IT Lab 1',
                Colors.teal,
                false,
                isLast: true,
              ),
            ],
    );
  }

  Widget _modernScheduleTile(
    IconData icon,
    String title,
    String time,
    String room,
    Color accent,
    bool isActive, {
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        children: [
          // Timeline Indicator
          Column(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: isActive ? accent : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: accent, width: 3),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: accent.withOpacity(0.3),
                            blurRadius: 8,
                          ),
                        ]
                      : null,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: accent.withOpacity(0.2)),
                ),
            ],
          ),
          const SizedBox(width: 20),
          // Content Card
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: isActive
                    ? Border.all(color: accent.withOpacity(0.3), width: 1)
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: accent, size: 22),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          time,
                          style: TextStyle(
                            color: Colors.blueGrey.withOpacity(0.7),
                            fontSize: 12,
                          ),
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
                      color: scaffoldBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      room,
                      style: TextStyle(
                        color: primaryTeal,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernReviewBanner() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryTeal, primaryTeal.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryTeal.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white.withOpacity(0.1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Exam Prep Mode',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Review your Semester 1 notes and practice mock tests.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Start Review',
                    style: TextStyle(
                      color: primaryTeal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Visual separation helpers
  Widget _buildSectionHeader(String title, String trailing) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        Text(
          trailing,
          style: TextStyle(
            color: primaryTeal,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  AppBar _buildModernAppBar() {
    return AppBar(
      backgroundColor: scaffoldBg,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 16,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      title: const Text(
        'Schedule',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBottomNav() {
    return CurvedNavigationBar(
      key: _bottomNavigationKey,
      index: _pageIndex,
      height: 65.0,
      items: const [
        Icon(Icons.calendar_month_rounded, size: 28, color: Colors.white),
        Icon(Icons.local_library_rounded, size: 28, color: Colors.white),
        Icon(Icons.forum_rounded, size: 28, color: Colors.white),
        Icon(Icons.face_rounded, size: 28, color: Colors.white),
      ],
      color: primaryTeal,
      buttonBackgroundColor: primaryTeal,
      backgroundColor: scaffoldBg,
      animationDuration: const Duration(milliseconds: 400),
      onTap: (index) => setState(() => _pageIndex = index),
    );
  }
}
