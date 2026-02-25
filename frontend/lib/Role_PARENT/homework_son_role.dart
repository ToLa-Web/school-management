// }import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:tamdansers/Screen/Edit-Profile/student_edit_profile.dart';
import 'package:tamdansers/contants/app_text_style.dart';

class ParentHomeworkScreen extends StatefulWidget {
  const ParentHomeworkScreen({super.key});

  @override
  State<ParentHomeworkScreen> createState() => _ParentHomeworkScreenState();
}

class _ParentHomeworkScreenState extends State<ParentHomeworkScreen> {
  int _pageIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final Color primaryTeal = const Color(0xFF007A7C);

  // Define the screens for each tab
  late final List<Widget> _screens = [
    _buildHomeworkHome(), // Tab 0: Homework Center
    Center(child: Text("Library", style: AppTextStyle.sectionTitle20)),
    Center(child: Text("Messages", style: AppTextStyle.sectionTitle20)),
    const StudentEditProfileScreen(), // Tab 3: Settings/Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _pageIndex == 0
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: () {},
              ),
              title: const Text(
                'Homework Center',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications_none,
                    color: Colors.black,
                  ),
                  onPressed: () {},
                ),
              ],
            )
          : null,
      body: IndexedStack(index: _pageIndex, children: _screens),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _pageIndex,
        height: 60.0,
        items: const <Widget>[
          Icon(Icons.assignment_rounded, size: 30, color: Colors.white),
          Icon(Icons.menu_book, size: 30, color: Colors.white),
          Icon(Icons.chat_bubble, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
        ],
        color: primaryTeal,
        buttonBackgroundColor: primaryTeal,
        backgroundColor: const Color(0xFFF8F9FA),
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

  // --- Main Homework Content ---
  Widget _buildHomeworkHome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStudentHeader(),
          const SizedBox(height: 25),
          _buildProgressCard(primaryTeal),
          const SizedBox(height: 25),
          _buildSearchBar(),
          const SizedBox(height: 15),
          _buildStatusFilters(primaryTeal),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Upcoming Assignments',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          _buildHomeworkCard(
            subject: 'Mathematics',
            title: 'Quadratic Equations',
            desc: 'Complete the worksheet on page 42. Show solution steps...',
            teacher: 'Ms. Sarah Jenkins',
            status: 'Overdue',
            statusColor: Colors.red,
            icon: Icons.calculate,
          ),
          _buildHomeworkCard(
            subject: 'English Literature',
            title: 'Book Report: The Hobbit',
            desc:
                'Write an introduction and analyze the character Bilbo Baggins.',
            teacher: 'Ms. Alice Wong',
            status: 'Due Tomorrow',
            statusColor: Colors.orange,
            icon: Icons.menu_book,
          ),
        ],
      ),
    );
  }

  // --- UI Helper Components ---

  Widget _buildStudentHeader() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 35,
          backgroundImage: NetworkImage(
            'https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?w=740',
          ),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Alex's Assignments",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              'Grade 4 • Oakwood Primary School',
              style: TextStyle(color: Colors.blueGrey.shade400),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressCard(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 15),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Weekly Progress',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                '70%',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          const Text(
            '7 of 10 assignments completed',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 15),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 0.7,
              minHeight: 12,
              backgroundColor: Colors.grey.shade100,
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search assignments',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildStatusFilters(Color primaryColor) {
    final filters = ['All', 'Pending', 'Completed', 'Overdue'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((f) {
          bool isActive = f == 'All';
          return Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isActive ? primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Text(
              f,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHomeworkCard({
    required String subject,
    required String title,
    required String desc,
    required String teacher,
    required String status,
    required Color statusColor,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border(left: BorderSide(color: statusColor, width: 5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, color: statusColor, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      subject,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              desc,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Divider(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  teacher,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const Text(
                  'Details >',
                  style: TextStyle(
                    color: Color(0xFF007A7C),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
