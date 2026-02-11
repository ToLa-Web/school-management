import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:tamdansers/Screen/Edit-Profile/student_edit_profile.dart';
import 'package:tamdansers/contants/app_text_style.dart';

class SchoolNewsEventsScreen extends StatefulWidget {
  const SchoolNewsEventsScreen({super.key});

  @override
  State<SchoolNewsEventsScreen> createState() => _SchoolNewsEventsScreenState();
}

class _SchoolNewsEventsScreenState extends State<SchoolNewsEventsScreen> {
  int _pageIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final Color primaryTeal = const Color(0xFF007A7C);

  // List of screens to navigate between
  late final List<Widget> _screens = [
    _buildNewsHomeContent(), // Index 0: News and Events
    Center(child: Text("Calendar", style: AppTextStyle.sectionTitle20)),
    Center(child: Text("Inbox", style: AppTextStyle.sectionTitle20)),
    const StudentEditProfileScreen(), // Index 3: Profile/Settings
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      // App bar only shows on the News Home tab
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
                'News & Events',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.black),
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
          Icon(Icons.newspaper, size: 30, color: Colors.white),
          Icon(Icons.calendar_month, size: 30, color: Colors.white),
          Icon(Icons.mail_outline, size: 30, color: Colors.white),
          Icon(Icons.person_outline, size: 30, color: Colors.white),
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

  // --- Sub-Screen: Main News Feed ---
  Widget _buildNewsHomeContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Featured News Section
          _buildSectionHeader('Latest News', () {}),
          SizedBox(
            height: 280,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              children: [
                _buildNewsCard(
                  imageUrl:
                      'https://images.unsplash.com/photo-1577891776191-c692241639c0?w=500',
                  tag: 'School',
                  date: '20 Oct 2023',
                  title: 'Boat Festival & School Holiday',
                  desc:
                      'The school will be closed for the upcoming Boat Festival...',
                ),
                _buildNewsCard(
                  imageUrl:
                      'https://images.unsplash.com/photo-1509062522246-3755977927d7?w=500',
                  tag: 'Competition',
                  date: '18 Oct 2023',
                  title: 'National Mathematics Competition Results',
                  desc:
                      'Congratulations to the students who won in the competition...',
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Upcoming Events Section
          _buildSectionHeader('Upcoming Events', () {}),
          _buildEventItem(
            month: 'Oct',
            day: '25',
            title: 'Parent-Teacher Meeting',
            time: '08:00 AM - 10:30 AM',
            location: 'School Hall (Building A)',
            color: Colors.blue.shade50,
          ),
          _buildEventItem(
            month: 'Oct',
            day: '28',
            title: 'Museum Study Tour',
            time: '07:30 AM - 04:30 PM',
            location: 'National Museum of Phnom Penh',
            color: Colors.green.shade50,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // --- UI Components ---

  Widget _buildSectionHeader(String title, VoidCallback onSeeAll) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: onSeeAll,
            child: const Text(
              'View All',
              style: TextStyle(color: Color(0xFF007A7C)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard({
    required String imageUrl,
    required String tag,
    required String date,
    required String title,
    required String desc,
  }) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              imageUrl,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2F1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          color: Color(0xFF007A7C),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      date,
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  desc,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventItem({
    required String month,
    required String day,
    required String title,
    required String time,
    required String location,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  month,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
                Text(
                  day,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text(
                      time,
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      location,
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
    );
  }
}
