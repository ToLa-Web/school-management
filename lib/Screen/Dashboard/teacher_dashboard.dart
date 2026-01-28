import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
// Ensure these imports match your project structure
import 'package:tamdansers/Screen/Edit-Profile/teacher_edit_profile.dart';
import 'package:tamdansers/Screen/Role_TEACHER/add_student_role.dart';
import 'package:tamdansers/Screen/Role_TEACHER/check_attendance_student_rolee.dart';
import 'package:tamdansers/Screen/Role_TEACHER/input_score_student_role.dart';
import 'package:tamdansers/Screen/Role_TEACHER/link_parent_role.dart';
import 'package:tamdansers/Screen/Role_TEACHER/management_class_student_role.dart';
import 'package:tamdansers/Screen/Role_TEACHER/result_student_role.dart';
import 'package:tamdansers/Screen/Role_TEACHER/schedule_student_role.dart';

void main() => runApp(
  const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TeacherDashboard(),
  ),
);

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  int _pageIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final List<Widget> _screens = [
    const TeacherHomeContent(),
    const TeacherCourseScreen(),
    const Center(child: Text("សារ (Messages)")),
    const TeacherSettingsScreen(),
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
}

// --- 2. HOME SCREEN CONTENT (INDEX 0) ---
class TeacherHomeContent extends StatelessWidget {
  const TeacherHomeContent({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildTeacherHeader(context),
            const SizedBox(height: 25),
            _buildOverviewCard(),
            const SizedBox(height: 30),
            _buildSectionTitle("ឧបករណ៍គ្រប់គ្រង", actionText: "មើលទាំងអស់"),
            const SizedBox(height: 15),
            _buildTeacherGridMenu(context),
            const SizedBox(height: 30),
            _buildAnnouncementTile(),
            const SizedBox(height: 25),
            _buildSectionTitle("សកម្មភាពរហ័ស", actionText: "គ្រប់គ្រង"),
            const SizedBox(height: 15),
            _buildQuickActions(),
            const SizedBox(height: 25),
            _buildWarningBanner(),
            const SizedBox(height: 30),
            _buildSectionTitle(
              "ថ្នាក់រៀនថ្ងៃនេះ",
              actionText: "កាលវិភាគពេញលេញ",
            ),
            const SizedBox(height: 15),
            _buildTodaySchedule(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildTeacherHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TeacherEditProfileScreen(),
            ),
          ),
          child: const CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage('assets/images/grade1.jpg'),
          ),
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "អត្តលេខគ្រូបង្រៀន",
              style: TextStyle(
                color: Color(0xFF007A7A),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "លោក Alexander Smith",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const Spacer(),
        _buildNotificationBadge(),
      ],
    );
  }

  Widget _buildNotificationBadge() {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(Icons.notifications_none, color: Colors.black),
        ),
        const Positioned(
          right: 12,
          top: 10,
          child: CircleAvatar(radius: 4, backgroundColor: Colors.red),
        ),
      ],
    );
  }

  Widget _buildOverviewCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF007A7A),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ទិដ្ឋភាពទូទៅនៃការសិក្សា",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "ឆមាសទី ២ • ឆ្នាំសិក្សា ២០២៣-២៤",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
              _buildStatusBadge("សកម្ម"),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem("ថ្នាក់រៀន", "០៨"),
              _buildStatItem("សិស្សសរុប", "២៤១"),
              _buildStatItem("ម៉ោងបង្រៀន", "៣២ម៉"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 10),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherGridMenu(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      children: [
        _buildGridItem(
          context,
          Icons.school,
          "គ្រប់គ្រងថ្នាក់",
          Colors.blue,
          const TeacherManagementClassScreen(),
        ),
        _buildGridItem(
          context,
          Icons.person_2,
          "គ្រប់គ្រងវត្តមាន",
          Colors.green,
          const AttendanceScreen(),
        ),
        _buildGridItem(
          context,
          Icons.class_,
          "វគ្គសិក្សា",
          Colors.purple,
          const TeacherCourseScreen(),
        ),
        _buildGridItem(
          context,
          Icons.people_alt,
          "បន្ថែមសិស្ស",
          Colors.orange,
          const AddStudentScreen(),
        ),
        _buildGridItem(
          context,
          Icons.checklist,
          "បញ្ចូលពិន្ទុ",
          Colors.red,
          const ScoreInputScreen(),
        ),
        _buildGridItem(
          context,
          Icons.star,
          "លទ្ធផលសកម្មភាព",
          Colors.indigo,
          const StudentResultScreen(),
        ),
        _buildGridItem(
          context,
          Icons.calendar_month,
          "កាលវិភាគបង្រៀន",
          Colors.cyan,
          const TeacherScheduleScreen(),
        ),
        const CategoryCard(
          icon: Icons.qr_code_2,
          label: "កូដ QR",
          color: Colors.deepOrange,
        ),
        _buildGridItem(
          context,
          Icons.person_add,
          "ភ្ជាប់អាណាព្យាបាល",
          Colors.teal,
          const ParentManagementScreen(),
        ),
      ],
    );
  }

  Widget _buildGridItem(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    Widget destination,
  ) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destination),
      ),
      child: CategoryCard(icon: icon, label: label, color: color),
    );
  }

  Widget _buildAnnouncementTile() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          _buildIconContainer(Icons.campaign, Colors.cyan),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ការប្រកាសថ្មី",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  "ផ្ញើសារទៅកាន់មាតាបិតាទាំងអស់",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.add_circle, color: Color(0xFF007A7A), size: 30),
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

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionItem(Icons.check_circle_outline, "កត់វត្តមាន", Colors.teal),
        _buildActionItem(
          Icons.description_outlined,
          "ដាក់ពិន្ទុ",
          Colors.blueGrey,
        ),
        _buildActionItem(Icons.campaign_outlined, "ការបោះឆ្នោត", Colors.cyan),
      ],
    );
  }

  Widget _buildActionItem(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .02),
                blurRadius: 10,
              ),
            ],
          ),
          child: Icon(icon, color: color, size: 30),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildWarningBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF4D7),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFFBE4A0)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFD4A017),
            size: 30,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "អវត្តមានដែលមិនទាន់បានកត់",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Text(
                  "ម៉ោងទី២៖ គីមីវិទ្យាកម្រិតខ្ពស់...",
                  style: TextStyle(fontSize: 11, color: Colors.black54),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              "កែសម្រួល",
              style: TextStyle(
                color: Color(0xFFD4A017),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodaySchedule() {
    return Column(
      children: [
        _buildScheduleTile(
          "ថ្នាក់ទី ១០ - ជីវវិទ្យា",
          "បន្ទប់ ៣០២ • ២៨ នាក់",
          "09:00",
          Colors.green,
          isDone: true,
        ),
        const SizedBox(height: 12),
        _buildScheduleTile(
          "ថ្នាក់ទី ១២ - គីមីវិទ្យា",
          "សិស្សសរុប ២២ នាក់",
          "11:30",
          Colors.teal,
          isCurrent: true,
        ),
      ],
    );
  }

  Widget _buildScheduleTile(
    String title,
    String sub,
    String time,
    Color color, {
    bool isDone = false,
    bool isCurrent = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isCurrent
            ? Border(left: BorderSide(color: color, width: 5))
            : null,
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                isCurrent ? "បច្ចុប្បន្ន" : "ម៉ោង",
                style: TextStyle(
                  fontSize: 10,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(time, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  sub,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Icon(
            isDone ? Icons.check_circle : Icons.more_vert,
            color: isDone ? Colors.green : Colors.grey,
          ),
        ],
      ),
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

// --- 3. COMMON WIDGETS ---
class CategoryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const CategoryCard({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: .1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class TeacherSettingsScreen extends StatelessWidget {
  const TeacherSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildProfileHeader(),
            const SizedBox(height: 30),

            // Primary Settings Group
            _buildSettingsGroup([
              _settingsTile(
                icon: Icons.person_outline,
                title: "ព័ត៌មានគណនី",
                iconColor: Colors.blue,
                onTap: () {
                  /* Navigate to Profile Info */
                },
              ),
              _settingsTile(
                icon: Icons.notifications_none,
                title: "ការកំណត់ការជូនដំណឹង",
                iconColor: Colors.orange,
                onTap: () {
                  /* Navigate to Notifications */
                },
              ),
              _settingsTile(
                icon: Icons.language,
                title: "ភាសា",
                iconColor: Colors.indigo,
                trailing: "ខ្មែរ/English",
                onTap: () {
                  /* Open Language Selector */
                },
              ),
              _settingsTile(
                icon: Icons.lock_outline,
                title: "សុវត្ថិភាព និងលេខសម្ងាត់",
                iconColor: Colors.green,
                onTap: () {
                  /* Navigate to Security */
                },
              ),
            ]),

            const SizedBox(height: 20),

            // Secondary Settings Group (Support/About)
            _buildSettingsGroup([
              _settingsTile(
                icon: Icons.help_outline,
                title: "ជំនួយ និងការគាំទ្រ",
                iconColor: Colors.blueGrey,
                onTap: () {
                  /* Navigate to Help */
                },
              ),
              _settingsTile(
                icon: Icons.info_outline,
                title: "អំពីកម្មវិធី",
                iconColor: Colors.blueGrey,
                onTap: () {
                  /* Navigate to About */
                },
              ),
            ]),

            const SizedBox(height: 30),
            _buildLogoutButton(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- UI Components ---

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'ការកំណត់',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                'https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?semt=ais_hybrid&w=740&q=80',
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: CircleAvatar(
                radius: 15,
                backgroundColor: Colors.teal,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.edit, size: 15, color: Colors.white),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          "លោក Alexander Smith",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const Text(
          "គ្រូបង្រៀនថ្នាក់ទី ១២A",
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildSettingsGroup(List<Widget> tiles) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: tiles),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    required Color iconColor,
    String? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: .1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null)
            Text(
              trailing,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        child: TextButton.icon(
          onPressed: () {
            // Add your logout logic here
          },
          icon: const Icon(Icons.logout, color: Colors.red),
          label: const Text(
            "ចាកចេញ",
            style: TextStyle(
              color: Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: TextButton.styleFrom(
            backgroundColor: Colors.red.withValues(alpha: .08),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),
    );
  }
}

// --- 4. COURSE SCREEN (INDEX 1) ---
class TeacherCourseScreen extends StatelessWidget {
  const TeacherCourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF007A7A),
        child: const Icon(Icons.add, color: Colors.black),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildCourseHeader(),
            _buildCourseSearchBar(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildCourseCard(
                    "គណិតវិទ្យាថ្នាក់ទី១០",
                    "មធ្យមសិក្សា",
                    "៤២ នាក់",
                    0.75,
                    "៧៥%",
                  ),
                  _buildCourseCard(
                    "រូបវិទ្យាថ្នាក់ទី១២",
                    "មធ្យមសិក្សា",
                    "៣៨ នាក់",
                    0.45,
                    "៤៥%",
                  ),
                  _buildCourseCard(
                    "ភាសាខ្មែរថ្នាក់ទី៥",
                    "បឋមសិក្សា",
                    "៣០ នាក់",
                    0.90,
                    "៩០%",
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseHeader() {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.arrow_back_ios_new, size: 20),
          Text(
            "វគ្គសិក្សារបស់ខ្ញុំ",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF007A7A),
            ),
          ),
          Icon(Icons.tune, size: 20),
        ],
      ),
    );
  }

  Widget _buildCourseSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        decoration: InputDecoration(
          hintText: "ស្វែងរកវគ្គសិក្សា...",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildCourseCard(
    String title,
    String level,
    String students,
    double progress,
    String percent,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EEF9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  level,
                  style: const TextStyle(
                    color: Color(0xFF007A7A),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                students,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            color: const Color(0xFF007A7A),
          ),
          const SizedBox(height: 10),
          Text(
            "វឌ្ឍនភាព: $percent",
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSmallAction(Icons.description, "ឯកសារ"),
              _buildSmallAction(Icons.assignment, "កិច្ចការ"),
              _buildSmallAction(Icons.person_search, "សិស្ស"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallAction(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF1A3673), size: 20),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}
