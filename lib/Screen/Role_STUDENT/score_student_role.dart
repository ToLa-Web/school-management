import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:tamdansers/Screen/Edit-Profile/student_edit_profile.dart';
import 'package:tamdansers/contants/app_text_style.dart';

class StudentScoreScreen extends StatefulWidget {
  const StudentScoreScreen({super.key});

  @override
  State<StudentScoreScreen> createState() => _StudentScoreScreenState();
}

class _StudentScoreScreenState extends State<StudentScoreScreen> {
  int pageIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  // List of screens for the Navigation Bar
  late final List<Widget> _screens = [
    _buildScoreContent(), // Tab 0: Your Score Content
    Center(
      child: Text("បណ្ណាល័យ (Library)", style: AppTextStyle.sectionTitle20),
    ),
    Center(child: Text("សារ (Messages)", style: AppTextStyle.sectionTitle20)),
    const StudentEditProfileScreen(), // Tab 3: Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      // App bar only shows when we are on the Score tab
      appBar: pageIndex == 0 ? _buildAppBar(context) : null,
      body: IndexedStack(index: pageIndex, children: _screens),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: pageIndex,
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
            pageIndex = index;
          });
        },
      ),
    );
  }

  // --- UI Sections ---

  Widget _buildScoreContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 10),
          _buildMonthSelector(),
          const SizedBox(height: 20),
          _buildSummaryCard(),
          const SizedBox(height: 25),
          _buildSubjectScoreList(),
          const SizedBox(height: 25),
          _buildPredictionActionCard(),
          const SizedBox(height: 25),
          _buildCalculatorSection(),
          const SizedBox(height: 100), // Space for FAB/Nav
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.black,
          size: 20,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text("លទ្ធផលប្រចាំខែ", style: AppTextStyle.sectionTitle20),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.share_outlined, color: Colors.black),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildMonthSelector() {
    final months = ["មករា", "កុម្ភៈ", "មីនា", "មេសា"];
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: months.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          bool isSelected = index == 2;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF007A7A) : Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                months[index],
                style: AppTextStyle.body.copyWith(
                  color: isSelected ? Colors.white : Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFF007A7A),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Text(
            "មធ្យមភាគប្រចាំខែ",
            style: AppTextStyle.body.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 5),
          Text(
            "94.50",
            style: AppTextStyle.sectionTitle20.copyWith(
              color: Colors.white,
              fontSize: 45,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          _statBadge("ចំណាត់ថ្នាក់លេខ: ០២"),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatDetail("ពិន្ទុសរុប", "472.5"),
              Container(height: 30, width: 1, color: Colors.white24),
              _buildStatDetail("និទ្ទេស", "A"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: AppTextStyle.body.copyWith(color: Colors.white, fontSize: 12),
      ),
    );
  }

  Widget _buildStatDetail(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyle.body.copyWith(
            color: Colors.white70,
            fontSize: 11,
          ),
        ),
        Text(
          value,
          style: AppTextStyle.body.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectScoreList() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.list_alt, size: 20, color: Color(0xFF007A7A)),
              const SizedBox(width: 8),
              Text(
                "ពិន្ទុតាមមុខវិជ្ជា",
                style: AppTextStyle.body.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _subjectTile(
            "គណិតវិទ្យា",
            "98/100",
            "មធ្យមភាគ: 95",
            Colors.orange,
            Icons.functions,
          ),
          _subjectTile(
            "រូបវិទ្យា",
            "92/100",
            "មធ្យមភាគ: 88",
            Colors.blue,
            Icons.science,
          ),
          _subjectTile(
            "អក្សរសាស្ត្រខ្មែរ",
            "89/100",
            "មធ្យមភាគ: 85",
            Colors.purple,
            Icons.translate,
          ),
        ],
      ),
    );
  }

  Widget _subjectTile(
    String name,
    String score,
    String avg,
    Color color,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              name,
              style: AppTextStyle.body.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                score,
                style: AppTextStyle.body.copyWith(
                  color: const Color(0xFF007A7A),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                avg,
                style: AppTextStyle.body.copyWith(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionActionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Text(
            "ព្យាករណ៍ពិន្ទុរបស់អ្នក",
            style: AppTextStyle.sectionTitle20.copyWith(fontSize: 18),
          ),
          Text(
            "គណនាពិន្ទុដែលអ្នករំពឹងទុកសម្រាប់ខែបន្ទាប់",
            style: AppTextStyle.body.copyWith(fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 15),
          ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007A7A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            ),
            icon: const Icon(Icons.calculate, color: Colors.white),
            label: Text(
              "គណនាពិន្ទុសរុប",
              style: AppTextStyle.body.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculatorSection() {
    return Container(
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
              Text(
                "កម្មវិធីគណនា (Calculator)",
                style: AppTextStyle.body.copyWith(fontWeight: FontWeight.bold),
              ),
              const Icon(Icons.info_outline, size: 18, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 20),
          _calcField("វត្តមាន (Attendance)", "10", "10"),
          _calcField("កិច្ចការផ្ទះ (Homework)", "25", "30"),
          _calcField("ការប្រឡង (Exams)", "55", "60"),
          const Divider(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "លទ្ធផលប៉ាន់ស្មាន:",
                style: AppTextStyle.body.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                "90 / 100 (A)",
                style: AppTextStyle.sectionTitle20.copyWith(
                  color: const Color(0xFF007A7A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _calcField(String label, String value, String max) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyle.body.copyWith(
              fontSize: 12,
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(value, style: AppTextStyle.body),
                Text(
                  "/ $max",
                  style: AppTextStyle.body.copyWith(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

