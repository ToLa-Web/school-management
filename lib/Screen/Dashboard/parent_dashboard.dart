import 'package:flutter/material.dart';
import 'package:tamdansers/Role_PARENT/attendance_son_role.dart';
import 'package:tamdansers/Role_PARENT/comment_and_signature_son_role.dart';
import 'package:tamdansers/Role_PARENT/events_news_son_role.dart';
import 'package:tamdansers/Role_PARENT/homework_son_role.dart';
import 'package:tamdansers/Screen/Edit-Profile/parent_edit_profile.dart';

import '../../Controller/controller_parent.dart/categorycard.dart';

void main() => runApp(
  const MaterialApp(debugShowCheckedModeBanner: false, home: ParentDashboard()),
);

class ParentDashboard extends StatelessWidget {
  const ParentDashboard({super.key});
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
              _buildParentHeader(),
              const SizedBox(height: 20),
              _buildStudentProfileCard(context),
              const SizedBox(height: 20),
              _buildAttendanceStatusCard(),
              const SizedBox(height: 25),
              _buildParentGridMenu(context),
              const SizedBox(height: 30),

              // --- REPLACED COURSE SECTION WITH HOMEWORK (IMAGE 9c1955) ---
              _buildSectionHeader("កិច្ចការបន្ទាប់", actionText: "មើលទាំងអស់"),
              const SizedBox(height: 15),
              SingleChildScrollView(
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
              ),

              const SizedBox(height: 30),

              // --- UPCOMING EXAMS (IMAGE 9b43fa) ---
              _buildSectionHeader("ការប្រឡងខាងមុខ", actionText: "មើលទាំងអស់"),
              const SizedBox(height: 15),
              SingleChildScrollView(
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
                    _buildExamCard(
                      "គណិតវិទ្យាកម្រិតខ្ពស់",
                      "នៅសល់ ២ ថ្ងៃ",
                      "ចន្ទ, ១២ តុលា",
                      "assets/images/images.jpg",
                    ),
                  ],
                ),
              ),

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
      ),
      bottomNavigationBar: _buildParentBottomNav(),
    );
  }

  // --- NEW COMPONENT: HOMEWORK CARD (From Image 9c1955) ---
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

  // --- NEW COMPONENT: EXAM CARD (From Image 9b43fa) ---
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
                    // color: Colors.white.withOpacity(0.9),
                    color: Colors.white.withValues(alpha: 0.5),
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
                            ? Colors.orange.withValues(alpha: 0.1)
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

  // --- HEADER & HELPERS ---
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

  Widget _buildParentHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.grid_view_rounded,
            color: Color(0xFF007A7A),
            size: 24,
          ),
        ),
        const Text(
          "ផ្ទាំងគ្រប់គ្រងអាណាព្យាបាល",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Icon(Icons.notifications_none, color: Colors.black),
      ],
    );
  }

  Widget _buildStudentProfileCard(context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              // Navigate to your ParentEditProfileScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ParentEditProfileScreen(),
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
                  "ថ្នាក់ទី ១០-B • អត្តលេខ: #8829",
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

  Widget _buildParentGridMenu(context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      childAspectRatio: 1.1,
      children: [

        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ParentHomeworkScreen(),
              ),
            );
          },
          child: CategoryCard(
            icon: Icons.schedule,
            label: "កាលវិភាគ",
            color: Colors.redAccent,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ParentAttendanceMonitor(),
              ),
            );
          },
          child: CategoryCard(
            icon: Icons.check_circle_outline,
            label: "តាមដានវត្តមាន",
            color: Colors.green,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ParentSignatureScreen(),
              ),
            );
          },
          child: CategoryCard(
            icon: Icons.edit_note,
            label: "មតិយោបល់",
            // sub: "ត្រូវការពិនិត្យ",
            color: Colors.purple,
            // hasAlert: true,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SchoolNewsEventsScreen(),
              ),
            );
          },
          child: CategoryCard(
            icon: Icons.bar_chart,
            label: "ព្រឹត្តិការណ៍ និងព័ត៌មាន",
            color: Colors.orange,
          ),
        ),
      ],
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

  Widget _buildParentBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF007A7A),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view_rounded),
          label: 'ទំព័រដើម',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.star_outline), label: 'កិច្ច'),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined),
          label: 'ប្រតិទិន',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.mail_outline),
          label: 'ប្រអប់សំបុត្រ',
        ),
      ],
    );
  }
}

// ignore: unused_element
class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sub;
  final Color color;
  final bool hasAlert;
  const _MenuCard({
    required this.icon,
    required this.label,
    required this.sub,
    required this.color,
    // ignore: unused_element_parameter
    this.hasAlert = false,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 9)),
        ],
      ),
    );
  }
}
