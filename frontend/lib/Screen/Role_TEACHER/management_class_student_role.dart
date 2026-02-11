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

// --- 1. MAIN NAVIGATION WRAPPER ---
class TeacherManagementClassScreen extends StatefulWidget {
  const TeacherManagementClassScreen({super.key});

  @override
  State<TeacherManagementClassScreen> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherManagementClassScreen> {
  int _pageIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  // Screens for the Bottom Navigation Bar
  final List<Widget> _screens = [
    // const TeacherHomeContent(), // Classroom Management with Search/Filter
    // const Center(child: Text("Course Screen")),
    // const Center(child: Text("Add Student Screen")),
    // const Center(child: Text("Settings/Profile Screen")),
    const TeacherHomeContent(), // Your Classroom Management UI
    const TeacherCourseScreen(), // Placeholder for Course Screen
    const AddStudentScreen(),
    const TeacherEditProfileScreen(), // Placeholder for Settings Screen
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

// --- 2. HOME CONTENT (With Search and Filter Logic) ---
class TeacherHomeContent extends StatefulWidget {
  const TeacherHomeContent({super.key});

  @override
  State<TeacherHomeContent> createState() => _TeacherHomeContentState();
}

class _TeacherHomeContentState extends State<TeacherHomeContent> {
  // Mock Data: This represents your database
  final List<Map<String, String>> _allClasses = [
    {"grade": "Grade 7A", "teacher": "Teap Thita", "students": "36 students"},
    {"grade": "Grade 8B", "teacher": "Sok Chea", "students": "30 students"},
    {"grade": "Grade 12", "teacher": "Dr. Smith", "students": "25 students"},
    {"grade": "Grade 10", "teacher": "Ly Hour", "students": "40 students"},
    {"grade": "Grade 7C", "teacher": "Vannak", "students": "32 students"},
  ];

  // State variables for filtering
  String _searchQuery = "";
  String _selectedGradeFilter = "All";

  @override
  Widget build(BuildContext context) {
    // FILTERING LOGIC
    // We filter the list every time the build method is called (whenever setState is triggered)
    final List<Map<String, String>> filteredClasses = _allClasses.where((
      classItem,
    ) {
      final String grade = classItem['grade']!.toLowerCase();
      final String teacher = classItem['teacher']!.toLowerCase();
      final String query = _searchQuery.toLowerCase();

      // Check if search matches grade or teacher name
      bool matchesSearch = grade.contains(query) || teacher.contains(query);

      // Check if matches the selected ChoiceChip
      bool matchesGrade =
          _selectedGradeFilter == "All" ||
          classItem['grade']!.contains(_selectedGradeFilter);

      return matchesSearch && matchesGrade;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Classroom Management',
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
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search by grade or teacher',
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
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the Create Class Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateClassScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A80F0),
                    foregroundColor: Colors.white,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(12),
                  ),
                  child: const Icon(Icons.add, size: 24),
                ),
              ],
            ),
          ),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children:
                  [
                    'All',
                    'Grade 12',
                    'Grade 11',
                    'Grade 10',
                    'Grade 9',
                    'Grade 8',
                    'Grade 7',
                  ].map((label) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(label),
                        selected: _selectedGradeFilter == label,
                        onSelected: (bool selected) {
                          setState(() {
                            _selectedGradeFilter = selected ? label : "All";
                          });
                        },
                        selectedColor: const Color(0xFF4A80F0),
                        labelStyle: TextStyle(
                          color: _selectedGradeFilter == label
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),

          // Classroom List
          Expanded(
            child: filteredClasses.isEmpty
                ? const Center(
                    child: Text("No classes found matching your search."),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredClasses.length,
                    itemBuilder: (context, index) {
                      final item = filteredClasses[index];
                      return ClassCard(
                        grade: item['grade']!,
                        teacher: item['teacher']!,
                        students: item['students']!,
                      );
                    },
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
      elevation: 2,
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
                fontSize: 18,
              ),
            ),
          ),
          ListTile(
            title: Text(
              "Teacher: $teacher",
              style: const TextStyle(
                color: Color(0xFF4A80F0),
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text("Homeroom Teacher"),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.people, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(students, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
