import 'package:flutter/material.dart';
import 'package:tamdansers/Controller/activity_list_widget.dart';
import 'package:tamdansers/Controller/controller.dart';
import 'package:tamdansers/Controller/course_card_widget.dart';
import 'package:tamdansers/Screen/Edit-Profile/student_edit_profile.dart';
import 'package:tamdansers/Screen/Role_STUDENT/attendance_student_role.dart';
import 'package:tamdansers/Screen/Role_STUDENT/homework_student_role.dart';
import 'package:tamdansers/Screen/Role_STUDENT/permision_student_role.dart';
import 'package:tamdansers/Screen/Role_STUDENT/schedule_student_role.dart';
import 'package:tamdansers/Screen/Role_STUDENT/score_student_role.dart';

void main() => runApp(const MaterialApp(home: StudentDashboard()));

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildHeader(context),
              const SizedBox(height: 30),
              _buildSectionTitle("ជម្រើសសិក្សា"),
              const SizedBox(height: 15),
              _buildGridMenu(context),
              const SizedBox(height: 30),
              _buildSectionTitle("វគ្គសិក្សា", actionText: "មើលទាំងអស់"),
              const SizedBox(height: 15),
              const CourseProgressCard(
                title: "គណិតវិទ្យាកម្រិតខ្ពស់ II",
                subtitle: "28 មេរៀន • 112 លំហាត់",
                progress: 0.75,
                percentage: "75%",
                imagePath:
                    'https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?semt=ais_hybrid&w=740&q=80',
              ),
              const SizedBox(height: 12),
              const CourseProgressCard(
                title: "ជីវវិទ្យាម៉ូលេគុល",
                subtitle: "18 មេរៀន • 6 លំហាត់",
                progress: 0.33,
                percentage: "33%",
                imagePath:
                    'https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?semt=ais_hybrid&w=740&q=80',
              ),
              const SizedBox(height: 30),
              _buildSectionTitle("សកម្មភាពថ្មីៗ"),
              const SizedBox(height: 15),
              const ActivityList(),

              // --- ADDED SECTION START ---
              const SizedBox(height: 30),
              _buildSectionTitle("កិច្ចការបន្ទាប់", actionText: "មើលទាំងអស់"),
              const SizedBox(height: 15),
              _buildNextTasksList(),

              // --- ADDED SECTION END ---
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // New Helper for Horizontal List
  Widget _buildNextTasksList() {
    return SizedBox(
      height: 160,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          NextTaskCard(
            subject: "ប្រវត្តិវិទ្យា",
            title: "The French Revolution:\nNarrative Essay",
            dueDate: "ឈប់កំណត់ថ្ងៃស្អែក",
            color: Colors.orange,
          ),
          SizedBox(width: 15),
          NextTaskCard(
            subject: "គីមីវិទ្យា",
            title: "Acid-Base\nReport",
            dueDate: "ឈប់កំណត់ថ្ងៃស្អែក",
            color: Color(0xFF007A7A),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(context) {
    return Row(
      children: [
        Stack(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StudentEditProfileScreen(),
                  ),
                );
              },
              child: const CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(
                  'https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?semt=ais_hybrid&w=740&q=80',
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: CircleAvatar(
                radius: 10,
                backgroundColor: Colors.white,
                child: CircleAvatar(radius: 7, backgroundColor: Colors.green),
              ),
            ),
          ],
        ),
        const SizedBox(width: 15),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Alex Rivera",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Badge(
                  label: Text("ថ្នាក់ទី 11-1"),
                  backgroundColor: Colors.lightBlueAccent,
                ),
                SizedBox(width: 8),
                Text(
                  "#អត្តលេខ: #29401",
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(Icons.notifications_none, color: Colors.black),
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
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        if (actionText != null)
          Text(
            actionText,
            style: const TextStyle(
              color: Color(0xFF007A7A),
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }

  Widget _buildGridMenu(context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AttendanceDashboard(),
              ),
            );
          },
          child: CategoryCard(
            icon: Icons.calendar_today,
            label: "វត្តមាន",
            color: Colors.orange,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const StudentScoreScreen(),
              ),
            );
          },
          child: CategoryCard(
            icon: Icons.show_chart,
            label: "ប្រចាំខែ",
            color: Colors.teal,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const StudentPermissionScreen(),
              ),
            );
          },
          child: CategoryCard(
            icon: Icons.people,
            label: "សុំអនុញ្ញាត",
            color: Colors.blue,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const StudentHomeworkScreen(),
              ),
            );
          },
          child: CategoryCard(
            icon: Icons.edit_note,
            label: "កិច្ចការផ្ទះ",
            color: Colors.green,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const StudentScheduleScreen(),
              ),
            );
          },
          child: CategoryCard(
            icon: Icons.schedule,
            label: "កាលវិភាគ",
            color: Colors.redAccent,
          ),
        ),
        CategoryCard(
          icon: Icons.qr_code_scanner,
          color: Colors.green,
          label: "កូដ QR",
          bgColor: Colors.white,
          iconColor: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF007A7A),
      unselectedItemColor: Colors.black,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'ទំព័រដើម'),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'បណ្ណាល័យ'),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: 'សារ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'ព័ត៌មានផ្ទាល់ខ្លួន',
        ),
      ],
    );
  }
}

// --- New NextTaskCard Widget ---
class NextTaskCard extends StatelessWidget {
  final String subject, title, dueDate;
  final Color color;

  const NextTaskCard({
    super.key,
    required this.subject,
    required this.title,
    required this.dueDate,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.circle, size: 10, color: color),
              const SizedBox(width: 8),
              Text(
                subject,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          Row(
            children: [
              Icon(Icons.access_time, size: 16, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  dueDate,
                  style: TextStyle(color: color, fontSize: 12),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
            ],
          ),
        ],
      ),
    );
  }
}
