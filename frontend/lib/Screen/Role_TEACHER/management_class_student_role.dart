import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:tamdansers/Screen/Dashboard/teacher_dashboard.dart';
import 'package:tamdansers/Screen/Edit-Profile/teacher_edit_profile.dart';
import 'package:tamdansers/Screen/Role_TEACHER/add_student_role.dart';
import 'package:tamdansers/Screen/Role_TEACHER/create_class_role.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TeacherManagementClassScreen(),
    ),
  );
}

// --- 1. THE MAIN DASHBOARD SHELL ---
class TeacherManagementClassScreen extends StatefulWidget {
  const TeacherManagementClassScreen({super.key});

  @override
  State<TeacherManagementClassScreen> createState() => _TeacherDashboardState();
}
class _TeacherDashboardState extends State<TeacherManagementClassScreen> {
  int _pageIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  // Integrated your screens list
  final List<Widget> _screens = [
    const TeacherHomeContent(), // Your Classroom Management UI
    const TeacherCourseScreen(), // Placeholder for Course Screen
    const AddStudentScreen(),
    const TeacherEditProfileScreen(), // Placeholder for Settings Screen
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      // Use IndexedStack to preserve the scroll state of your lists when switching tabs
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

// --- 2. THE HOME CONTENT (Classroom Management) ---
class TeacherHomeContent extends StatelessWidget {
  const TeacherHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'គ្រប់គ្រងថ្នាក់រៀន',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Add Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'ស្វែងរក...',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to the Create Class Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateClassScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_circle_outline, size: 20),
                  label: const Text('បង្កើតថ្នាក់'),
                  style: ElevatedButton.styleFrom(
                    // FIXED: iconStyleFrom changed to styleFrom
                    backgroundColor: const Color(0xFF4A80F0),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                )
              ],
            ),
          ),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: ['ទាំងអស់', 'ថ្នាក់ទី 12', 'ថ្នាក់ទី 11', 'ថ្នាក់ទី 10',
                    'ថ្នាក់ទី 9',
                  'ថ្នាក់ទី 8',
                  'ថ្នាក់ទី 7',
                  'ថ្នាក់ទី 6',
                  'ថ្នាក់ទី 5',
                  ]
                  .map((label) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(label),
                        selected: label == 'ទាំងអស់',
                        onSelected: (bool selected) {},
                        selectedColor: const Color(0xFF4A80F0),
                        labelStyle: TextStyle(
                          color: label == 'ទាំងអស់'
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    );
                  })
                  .toList(),
            ),
          ),

          // Classroom List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                ClassCard(
                  grade: "ថ្នាក់ទី 7A",
                  teacher: "ទេព ធីតា",
                  students: "36 នាក់",
                ),
                ClassCard(
                  grade: "ថ្នាក់ទី 8B",
                  teacher: "សុខ ជា",
                  students: "30 នាក់",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- 3. REUSABLE CLASS CARD ---
class ClassCard extends StatelessWidget {
  final String grade, teacher, students;
  const ClassCard({
    super.key,
    required this.grade,
    required this.teacher,
    required this.students,
    
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            height: 100,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0277BD), Color(0xFF00B0FF)],
              ),
            ),
            padding: const EdgeInsets.all(16),
            alignment: Alignment.bottomLeft,
            child: Text(
              grade,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          ListTile(
            title: Text(
              "អ្នកគ្រូ $teacher",
              style: const TextStyle(
                color: Color(0xFF4A80F0),
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text("គ្រូបន្ទុកថ្នាក់"),
            trailing: Chip(
              label: Text(students),
              avatar: const Icon(Icons.people, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}
