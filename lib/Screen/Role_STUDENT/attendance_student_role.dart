
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:tamdansers/Screen/Edit-Profile/student_edit_profile.dart';
import 'package:tamdansers/contants/app_text_style.dart';

class AttendanceDashboard extends StatefulWidget {
  const AttendanceDashboard({super.key});

  @override
  State<AttendanceDashboard> createState() => _AttendanceDashboardState();
}

class _AttendanceDashboardState extends State<AttendanceDashboard> {
  int _pageIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final Color tealTheme = const Color(0xFF0097A7);

  // Define the screens for each tab
  late final List<Widget> _screens = [
    _buildAttendanceHome(), // Tab 0: Your Attendance Content
    Center(
      child: Text("បណ្ណាល័យ (Library)", style: AppTextStyle.sectionTitle20),
    ),
    Center(child: Text("សារ (Messages)", style: AppTextStyle.sectionTitle20)),
    const StudentEditProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      // Only show the AppBar if we are on the Attendance Home tab
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
                'វត្តមានរបស់ខ្ញុំ',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            )
          : null,
      body: IndexedStack(index: _pageIndex, children: _screens),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _pageIndex,
        height: 60.0,
        items: const <Widget>[
          Icon(Icons.grid_view_rounded, size: 30, color: Colors.white),
          Icon(Icons.menu_book, size: 30, color: Colors.white),
          Icon(Icons.chat_bubble, size: 30, color: Colors.white),
          Icon(Icons.settings, size: 30, color: Colors.white),
        ],
        color: const Color(0xFF007A7A),
        buttonBackgroundColor: const Color(0xFF007A7A),
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

  // This method contains the UI content you previously had in the Body
  Widget _buildAttendanceHome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildSummaryCard(tealTheme),
          const SizedBox(height: 20),
          _buildCalendarSection(tealTheme),
          const SizedBox(height: 20),
          _buildSubjectList(tealTheme),
        ],
      ),
    );
  }

  // --- Helper UI Components ---
  // (Keep these methods inside the State class)

  Widget _buildSummaryCard(Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'សង្ខេបប្រចាំឆ្នាំ',
                style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'សរុបការមក\nសិក្សា',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ],
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: 0.95,
                  strokeWidth: 8,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '95%',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    'ឡើង ២% ',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarSection(Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'ប្រវត្តិវត្តមាន',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'មើលទាំងអស់',
              style: TextStyle(color: color, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.chevron_left),
                  Text(
                    'មេសា 2024',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.chevron_right),
                ],
              ),
              const SizedBox(height: 15),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: 31,
                itemBuilder: (context, index) {
                  bool isSelected = (index + 1) == 2;
                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? color : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),
               Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Legend(color: Colors.green, label: 'វត្តមាន'),
                  SizedBox(width: 15),
                  _Legend(color: Colors.red, label: 'អវត្តមាន'),
                  SizedBox(width: 15),
                  _Legend(color: Colors.orange, label: 'យឺត'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectList(Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'លម្អិតវត្តមានតាមមុខវិជ្ជា',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _SubjectItem(
          title: 'ភាសាខ្មែរ (Khmer)',
          status: 'វត្តមាន',
          statusColor: Colors.green,
          icon: Icons.book,
          color: color,
        ),
        const SizedBox(height: 10),
        _SubjectItem(
          title: 'រូបវិទ្យា (Physics)',
          status: 'អវត្តមាន',
          statusColor: Colors.red,
          icon: Icons.science,
          color: color,
        ),
      ],
    );
  }
}
class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

class _SubjectItem extends StatelessWidget {
  final String title, status;
  final Color statusColor, color;
  final IconData icon;

  const _SubjectItem({
    required this.title,
    required this.status,
    required this.statusColor,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // ... your existing build code ...
    return Container(); // Placeholder
  }
}

// Keep the _Legend and _SubjectItem classes outside at the bottom as you had them before
