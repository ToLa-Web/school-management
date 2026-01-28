import 'package:curved_navigation_bar/curved_navigation_bar.dart'; // Ensure this is in pubspec.yaml
import 'package:flutter/material.dart';
import 'package:tamdansers/Role_PARENT/attendance_son_role.dart';
import 'package:tamdansers/Role_PARENT/comment_and_signature_son_role.dart';
import 'package:tamdansers/Role_PARENT/events_news_son_role.dart';
import 'package:tamdansers/Role_PARENT/homework_son_role.dart';
import 'package:tamdansers/Role_PARENT/result_monthly_son_role.dart';
import 'package:tamdansers/Screen/Edit-Profile/parent_edit_profile.dart';

import '../../Controller/controller_parent.dart/categorycard.dart';

void main() => runApp(
  const MaterialApp(debugShowCheckedModeBanner: false, home: ParentDashboard()),
);

// --- MAIN WRAPPER WITH NAVIGATION ---
class ParentDashboard extends StatefulWidget {
  const ParentDashboard({super.key});

  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> {
  int _pageIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  // Define your screens here
  final List<Widget> _screens = [
    const ParentHomeContent(), // Index 0: Your original dashboard
    const Center(child: Text("ប្រតិទិន (Calendar)")), // Index 1
    const Center(child: Text("សារ (Messages)")), // Index 2
    const ParentEditProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      body: IndexedStack(index: _pageIndex, children: _screens),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _pageIndex,
        height: 60.0,
        items: const <Widget>[
          Icon(Icons.grid_view_rounded, size: 30, color: Colors.white),
          Icon(Icons.calendar_month_outlined, size: 30, color: Colors.white),
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
}

// --- DASHBOARD CONTENT (Moved from original ParentDashboard) ---
class ParentHomeContent extends StatelessWidget {
  const ParentHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildParentHeader(),
            const SizedBox(height: 20),
            _buildStudentProfileCard(context),
            const SizedBox(height: 20),
            _buildAttendanceStatusCard(),
            const SizedBox(height: 25),
            _buildParentGridMenu(context),
            const SizedBox(height: 25),
            _buildSectionTitle("សកម្មភាពរហ័ស", actionText: "គ្រប់គ្រង"),
            const SizedBox(height: 25),
            _buildQuickActions(context),
            const SizedBox(height: 30),
            _buildSectionHeader("កិច្ចការបន្ទាប់", actionText: "មើលទាំងអស់"),
            const SizedBox(height: 15),
            _buildHomeworkList(),
            const SizedBox(height: 30),
            _buildSectionHeader("ការប្រឡងខាងមុខ", actionText: "មើលទាំងអស់"),
            const SizedBox(height: 15),
            _buildExamList(),
            const SizedBox(height: 30),
            _buildSectionHeader("មតិយោបល់គ្រូបង្រៀន", hasNew: true),
            const SizedBox(height: 15),
            _buildTeacherFeedbackCard(),
            const SizedBox(height: 25),
            _buildMessageTeacherCard(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // --- UI HELPER METHODS (Keep these as they were in your code) ---

  Widget _buildHomeworkList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildHomeworkCard(
            subject: "ប្រវត្តិវិទ្យា",
            title: "The French Revolution:\nNarrative Essay",
            deadline: "ឈប់កំណត់ថ្ងៃស្អែក",
            dotColor: Colors.orange,
          ),
          const SizedBox(width: 15),
          _buildHomeworkCard(
            subject: "គីមីវិទ្យា",
            title: "Acid-Base\nReport",
            deadline: "ឈប់កំណត់ថ្ងៃស្អែក",
            dotColor: const Color(0xFF007A7A),
            isIconCalendar: true,
          ),
        ],
      ),
    );
  }

  Widget _buildExamList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildExamCard(
            "គណិតវិទ្យាកម្រិតខ្ពស់",
            "នៅសល់ ២ ថ្ងៃ",
            "ចន្ទ, ១២ តុលា",
            "assets/images/MATH.jpg",
          ),
          const SizedBox(width: 15),
          _buildExamCard(
            "វិទ្យាសាស្ត្រទូទៅ",
            "សប្តាហ៍ក្រោយ",
            "សុក្រ, ១៦ តុលា",
            "assets/images/2011.jpg",
          ),
        ],
      ),
    );
  }

  Widget _buildHomeworkCard({
    required String subject,
    required String title,
    required String deadline,
    required Color dotColor,
    bool isIconCalendar = false,
  }) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 4, backgroundColor: dotColor),
              const SizedBox(width: 8),
              Text(
                subject,
                style: TextStyle(
                  color: dotColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Icon(
                isIconCalendar
                    ? Icons.calendar_today_outlined
                    : Icons.access_time,
                size: 16,
                color: dotColor,
              ),
              const SizedBox(width: 8),
              Text(
                deadline,
                style: TextStyle(
                  color: dotColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExamCard(
    String title,
    String timeLeft,
    String date,
    String assetImage,
  ) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
                child: Image.asset(
                  assetImage,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    date,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: timeLeft.contains("ថ្ងៃ")
                            ? Colors.orange.withOpacity(0.1)
                            : const Color(0xFFE0F2F2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        timeLeft,
                        style: TextStyle(
                          color: timeLeft.contains("ថ្ងៃ")
                              ? Colors.orange
                              : const Color(0xFF007A7A),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: Colors.grey,
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

  Widget _buildSectionHeader(
    String title, {
    bool hasNew = false,
    String actionText = "ប្រវត្តិ",
  }) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        if (hasNew) ...[
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              "ថ្មី",
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
        ],
        const Spacer(),
        Text(
          actionText,
          style: const TextStyle(
            color: Color(0xFF007A7A),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, {String? actionText}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        if (actionText != null)
          Text(
            actionText,
            style: const TextStyle(
              color: Color(0xFF007A7A),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }
}

Widget _buildParentHeader() {
  return const Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Icon(Icons.grid_view_rounded, color: Color(0xFF007A7A), size: 28),
      Text(
        "ផ្ទាំងគ្រប់គ្រងអាណាព្យាបាល",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      Icon(Icons.notifications_none, color: Colors.black, size: 28),
    ],
  );
}

Widget _buildStudentProfileCard(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ParentEditProfileScreen(),
            ),
          ),
          child: const CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(
              'https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?semt=ais_hybrid&w=740&q=80',
            ),
          ),
        ),
        const SizedBox(width: 15),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Alex Johnson",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "ថ្នាក់ទី ១០-B • #8829",
                style: TextStyle(color: Color(0xFF007A7A), fontSize: 12),
              ),
            ],
          ),
        ),
        const Icon(Icons.swap_horiz_rounded, color: Color(0xFF007A7A)),
      ],
    ),
  );
}

Widget _buildAttendanceStatusCard() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: const Color(0xFF006666),
      borderRadius: BorderRadius.circular(20),
    ),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "បានមកដល់ថ្ងៃនេះ",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "ស្កេនចូលម៉ោង 08:30 ព្រឹក (ទាន់ពេល)",
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
      ],
    ),
  );
}

Widget _buildParentGridMenu(BuildContext context) {
  return GridView.count(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    crossAxisCount: 2,
    mainAxisSpacing: 15,
    crossAxisSpacing: 15,
    childAspectRatio: 1.1,
    children: [
      _gridItem(
        context,
        Icons.home_work_rounded,
        "កិច្ចការផ្ទះ",
        Colors.redAccent,
        const ParentHomeworkScreen(),
      ),
      _gridItem(
        context,
        Icons.check_circle_outline,
        "តាមដានវត្តមាន",
        Colors.green,
        const ParentAttendanceMonitor(),
      ),
      _gridItem(
        context,
        Icons.edit_note,
        "មតិយោបល់",
        Colors.purple,
        const ParentSignatureScreen(),
      ),
      _gridItem(
        context,
        Icons.bar_chart,
        "ព្រឹត្តិការណ៍",
        Colors.orange,
        const SchoolNewsEventsScreen(),
      ),
    ],
  );
}

Widget _gridItem(
  BuildContext context,
  IconData icon,
  String label,
  Color color,
  Widget screen,
) {
  return GestureDetector(
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    ),
    child: CategoryCard(icon: icon, label: label, color: color),
  );
}

Widget _buildTeacherFeedbackCard() {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: const Border(
        left: BorderSide(color: Color(0xFF007A7A), width: 6),
      ),
    ),
    child: const Text(
      "\"Alex បានបង្ហាញពីភាពជាអ្នកដឹកនាំដ៏ឆ្នើមក្នុងអំឡុងពេលពិភាក្សាក្នុងថ្នាក់ថ្ងៃនេះ...\"",
    ),
  );
}

Widget _buildMessageTeacherCard() {
  return Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: const Color(0xFF006666),
      borderRadius: BorderRadius.circular(20),
    ),
    child: const Row(
      children: [
        Icon(Icons.chat_bubble_outline, color: Colors.white),
        SizedBox(width: 15),
        Text(
          "ផ្ញើសារទៅគ្រូ",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        Spacer(),
        Icon(Icons.chevron_right, color: Colors.white),
      ],
    ),
  );
}

Widget _buildIconContainer(IconData icon, Color color) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .1),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Icon(icon, color: color),
  );
}

// Widget _buildQuickActions() {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       _buildActionItem(Icons.check_circle_outline, "កត់វត្តមាន", Colors.teal),
//       _buildActionItem(
//         Icons.description_outlined,
//         "ដាក់ពិន្ទុ",
//         Colors.blueGrey,
//       ),
//       _buildActionItem(Icons.campaign_outlined, "ការបោះឆ្នោត", Colors.cyan),
//     ],
//   );
// }

// Widget _buildActionItem(IconData icon, String label, Color color) {
//   return Column(
//     children: [
//       Container(
//         width: 100,
//         height: 100,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withValues(alpha: .02),
//               blurRadius: 10,
//             ),
//           ],
//         ),
//         child: Icon(icon, color: color, size: 30),
//       ),
//       const SizedBox(height: 8),
//       Text(
//         label,
//         style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//       ),
//     ],
//   );
// }
Widget _buildQuickActions(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      _buildActionItem(
        context,
        Icons.check_circle_outline,
        "កត់វត្តមាន",
        Colors.teal,
        const ParentAttendanceMonitor(), // Link to Attendance Screen
      ),
      _buildActionItem(
        context,
        Icons.auto_graph,
        "លទ្ធផល",
        Colors.blueGrey,
        const StudentReportScreen(), // Link to Homework Screen
      ),
      _buildActionItem(
        context,
        Icons.campaign_outlined,
        "ព័ត៌មាន",
        Colors.cyan,
        const SchoolNewsEventsScreen(), // Link to News Screen
      ),
    ],
  );
}

Widget _buildActionItem(
  BuildContext context,
  IconData icon,
  String label,
  Color color,
  Widget destination,
) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destination),
      );
    },
    child: Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: color, size: 35),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    ),
  );
}
