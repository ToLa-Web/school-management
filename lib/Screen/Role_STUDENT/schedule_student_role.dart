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
  // Navigation State
  int _pageIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  // Design Colors
  final Color primaryTeal = const Color(0xFF007A7C);

  @override
  Widget build(BuildContext context) {
    // List of screens for the Curved Navigation Bar
    final List<Widget> screens = [
      _buildScheduleMainContent(), // Tab 0: Your Schedule
      Center(child: Text("Library", style: AppTextStyle.sectionTitle20)),
      Center(child: Text("Messages", style: AppTextStyle.sectionTitle20)),
      const StudentEditProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      // App bar only shows for the Schedule tab
      appBar: _pageIndex == 0
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(
                'Academic Schedule',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              actions: const [
                Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: Icon(Icons.calendar_month, color: Colors.black),
                ),
              ],
            )
          : null,
      body: IndexedStack(index: _pageIndex, children: screens),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _pageIndex,
        height: 60.0,
        items: const <Widget>[
          Icon(Icons.calendar_today, size: 30, color: Colors.white), // Schedule
          Icon(Icons.menu_book, size: 30, color: Colors.white), // Library
          Icon(Icons.chat_bubble, size: 30, color: Colors.white), // Chat
          Icon(Icons.person, size: 30, color: Colors.white), // Profile
        ],
        color: primaryTeal,
        buttonBackgroundColor: primaryTeal,
        backgroundColor: const Color(0xFFF5F7F9),
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

  // --- Main Schedule UI Content ---
  Widget _buildScheduleMainContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Term Switcher
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _buildTermButton('Semester 1', true),
                _buildTermButton('Semester 2', false),
              ],
            ),
          ),
          const SizedBox(height: 25),

          // 2. Weekly Schedule Title
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weekly Schedule',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text('Week 12', style: TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 15),

          // 3. Timeline Schedule List
          _buildScheduleItem(
            icon: Icons.grid_view_rounded,
            subject: 'Mathematics',
            time: 'Mon 08:00 - 09:30',
            room: 'Room 302',
            isFirst: true,
          ),
          _buildScheduleItem(
            icon: Icons.science_outlined,
            subject: 'Science',
            time: 'Mon 10:00 - 11:30',
            room: 'Laboratory',
          ),
          _buildScheduleItem(
            icon: Icons.book_outlined,
            subject: 'Khmer Literature',
            time: 'Tue 08:00 - 09:30',
            room: 'Room 105',
          ),
          _buildScheduleItem(
            icon: Icons.public_outlined,
            subject: 'English',
            time: 'Tue 10:00 - 11:30',
            room: 'Room 201',
            isLast: true,
          ),

          const SizedBox(height: 25),

          // 4. Year-end Review Banner
          const Text(
            'Year-end Review',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          _buildReviewBanner(),
        ],
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildTermButton(String text, bool isActive) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                  ),
                ]
              : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? primaryTeal : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleItem({
    required IconData icon,
    required String subject,
    required String time,
    required String room,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 2,
                height: 20,
                color: isFirst ? Colors.transparent : Colors.grey.shade300,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: primaryTeal.withOpacity(0.4),
                    width: 2,
                  ),
                ),
                child: Icon(icon, size: 20, color: primaryTeal),
              ),
              Expanded(
                child: Container(
                  width: 2,
                  color: isLast ? Colors.transparent : Colors.grey.shade300,
                ),
              ),
            ],
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subject,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              time,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text(
                    room,
                    style: TextStyle(
                      color: primaryTeal,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
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

  Widget _buildReviewBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryTeal,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Semester Exam Preparation',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Review lessons and practice exercises to prepare for final exams and improve results.',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: primaryTeal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('View Review Lessons'),
                SizedBox(width: 10),
                Icon(Icons.arrow_forward, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
