import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:tamdansers/Screen/Edit-Profile/student_edit_profile.dart';
import 'package:tamdansers/contants/app_text_style.dart';

// 1. Changed to StatefulWidget to handle navigation index changes
class StudentHomeworkScreen extends StatefulWidget {
  const StudentHomeworkScreen({super.key});

  @override
  State<StudentHomeworkScreen> createState() => _StudentHomeworkScreenState();
}

class _StudentHomeworkScreenState extends State<StudentHomeworkScreen> {
  int _pageIndex = 1; // Default to Homework tab (index 1)
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final Color primaryTeal = const Color(0xFF007A7C);

  @override
  Widget build(BuildContext context) {
    // List of screens for the Curved Navigation Bar
    final List<Widget> screens = [
      const Center(child: Text("Home Content")), // Tab 0
      _buildHomeworkMainContent(), // Tab 1 (Current)
      Center(
        child: Text("Library", style: AppTextStyle.sectionTitle20),
      ), // Tab 2
      const StudentEditProfileScreen(), // Tab 3
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      body: IndexedStack(index: _pageIndex, children: screens),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _pageIndex,
        height: 60.0,
        items: const <Widget>[
          Icon(Icons.grid_view_rounded, size: 30, color: Colors.white),
          Icon(
            Icons.assignment,
            size: 30,
            color: Colors.white,
          ), // Homework Icon
          Icon(Icons.menu_book, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
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

  // --- Main Homework Content with TabBar ---
  Widget _buildHomeworkMainContent() {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7F9),
        appBar: AppBar(
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
            'My Homework',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: primaryTeal,
            indicatorWeight: 3,
            labelColor: primaryTeal,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: 'Not Submitted'),
              Tab(text: 'Under Review'),
              Tab(text: 'Graded'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Not Submitted
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildHomeworkCard(
                  title: 'Khmer Language',
                  homeworkNumber: 'Homework 1',
                  teacher: 'Mr. Sok Chea',
                  deadline: 'Tomorrow at 5:00 PM',
                  imageUrl:
                      'https://img.freepik.com/free-photo/opened-book-with-feather_23-2148882766.jpg',
                  isUrgent: true,
                ),
                const SizedBox(height: 16),
                _buildHomeworkCard(
                  title: 'Mathematics',
                  homeworkNumber: 'Homework 2',
                  teacher: 'Ms. Nary',
                  deadline: 'Friday at 8:00 AM',
                  imageUrl:
                      'https://img.freepik.com/free-vector/math-background-with-formulas_23-2148145533.jpg',
                  isUrgent: false,
                ),
              ],
            ),
            const Center(child: Text('No assignments under review')),
            const Center(child: Text('No graded assignments yet')),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets (Moved inside the State class) ---

  Widget _buildHomeworkCard({
    required String title,
    required String homeworkNumber,
    required String teacher,
    required String deadline,
    required String imageUrl,
    required bool isUrgent,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.network(
                  imageUrl,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              if (isUrgent)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Due Soon',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      homeworkNumber,
                      style: const TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 12,
                      ),
                    ),
                    const Icon(Icons.more_horiz, color: Colors.grey),
                  ],
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.person, size: 18, color: Colors.blueGrey),
                    const SizedBox(width: 8),
                    Text(
                      teacher,
                      style: const TextStyle(color: Colors.blueGrey),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Deadline: $deadline',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 70,
                      height: 30,
                      child: Stack(
                        children: [
                          _buildMiniAvatar(0, Colors.blue.shade100, 'A'),
                          _buildMiniAvatar(15, Colors.green.shade100, 'B'),
                          _buildMiniAvatar(30, Colors.grey.shade200, '+12'),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryTeal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      child: const Text(
                        'Submit Assignment',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniAvatar(double left, Color color, String text) {
    return Positioned(
      left: left,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
