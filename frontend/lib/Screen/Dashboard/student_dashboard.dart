// import 'package:flutter/material.dart';
// import 'package:curved_navigation_bar/curved_navigation_bar.dart'; // Ensure you have this in pubspec.yaml
// import 'package:tamdansers/Controller/activity_list_widget.dart';
// import 'package:tamdansers/Controller/controller.dart';
// import 'package:tamdansers/Controller/course_card_widget.dart';
// import 'package:tamdansers/Screen/Edit-Profile/student_edit_profile.dart';
// import 'package:tamdansers/Screen/Role_STUDENT/attendance_student_role.dart';
// import 'package:tamdansers/Screen/Role_STUDENT/homework_student_role.dart';
// import 'package:tamdansers/Screen/Role_STUDENT/permision_student_role.dart';
// import 'package:tamdansers/Screen/Role_STUDENT/schedule_student_role.dart';
// import 'package:tamdansers/Screen/Role_STUDENT/score_student_role.dart';

// void main() => runApp(const MaterialApp(home: StudentDashboard()));

// class StudentDashboard extends StatefulWidget {
//   const StudentDashboard({super.key});

//   @override
//   State<StudentDashboard> createState() => _StudentDashboardState();
// }

// class _StudentDashboardState extends State<StudentDashboard> {
//   int _pageIndex = 0;
//   final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

//   // Define the different screens for the Student role
//   late final List<Widget> _screens = [
//     const StudentHomeContent(), // Index 0 (Main Dashboard)
//     const Center(child: Text("បណ្ណាល័យ (Library)")), // Index 1
//     const Center(child: Text("សារ (Messages)")), // Index 2
//     const StudentEditProfileScreen(), // Index 3 (Profile/Settings)
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7F9),
//       // Use IndexedStack to keep screens alive when switching
//       body: IndexedStack(index: _pageIndex, children: _screens),
//       bottomNavigationBar: CurvedNavigationBar(
//         key: _bottomNavigationKey,
//         index: _pageIndex,
//         height: 60.0,
//         items: const <Widget>[
//           Icon(Icons.dashboard_rounded, size: 30, color: Colors.white),
//           Icon(Icons.book_rounded, size: 30, color: Colors.white),
//           Icon(Icons.chat_bubble_rounded, size: 30, color: Colors.white),
//           Icon(Icons.person_rounded, size: 30, color: Colors.white),
//         ],
//         color: const Color(0xFF007A7A),
//         buttonBackgroundColor: const Color(0xFF007A7A),
//         backgroundColor: const Color(0xFFF5F7F9),
//         animationCurve: Curves.easeInOut,
//         animationDuration: const Duration(milliseconds: 300),
//         onTap: (index) {
//           setState(() {
//             _pageIndex = index;
//           });
//         },
//       ),
//     );
//   }
// }

// /// Moving your existing UI logic into a separate Widget for the "Home" tab
// class StudentHomeContent extends StatelessWidget {
//   const StudentHomeContent({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 20),
//             _buildHeader(context),
//             const SizedBox(height: 30),
//             _buildSectionTitle("ជម្រើសសិក្សា"),
//             const SizedBox(height: 15),
//             _buildGridMenu(context),
//             const SizedBox(height: 30),
//             _buildSectionTitle("វគ្គសិក្សា", actionText: "មើលទាំងអស់"),
//             const SizedBox(height: 15),
//             const CourseProgressCard(
//               title: "គណិតវិទ្យាកម្រិតខ្ពស់ II",
//               subtitle: "28 មេរៀន • 112 លំហាត់",
//               progress: 0.75,
//               percentage: "75%",
//               imagePath:
//                   'https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?semt=ais_hybrid&w=740&q=80',
//             ),
//             const SizedBox(height: 12),
//             const CourseProgressCard(
//               title: "ជីវវិទ្យាម៉ូលេគុល",
//               subtitle: "18 មេរៀន • 6 លំហាត់",
//               progress: 0.33,
//               percentage: "33%",
//               imagePath:
//                   'https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?semt=ais_hybrid&w=740&q=80',
//             ),
//             const SizedBox(height: 30),
//             _buildSectionTitle("សកម្មភាពថ្មីៗ"),
//             const SizedBox(height: 15),
//             const ActivityList(),
//             const SizedBox(height: 30),
//             _buildSectionTitle("កិច្ចការបន្ទាប់", actionText: "មើលទាំងអស់"),
//             const SizedBox(height: 15),
//             _buildNextTasksList(),
//             const SizedBox(height: 100), // Space for the curved nav bar
//           ],
//         ),
//       ),
//     );
//   }

//   // --- UI Helper Methods (Kept from your original code) ---

//   Widget _buildNextTasksList() {
//     return SizedBox(
//       height: 160,
//       child: ListView(
//         scrollDirection: Axis.horizontal,
//         children:  [
//           NextTaskCard(
//             subject: "ប្រវត្តិវិទ្យា",
//             title: "The French Revolution:\nNarrative Essay",
//             dueDate: "ឈប់កំណត់ថ្ងៃស្អែក",
//             color: Colors.orange,
//           ),
//           SizedBox(width: 15),
//           NextTaskCard(
//             subject: "គីមីវិទ្យា",
//             title: "Acid-Base\nReport",
//             dueDate: "ឈប់កំណត់ថ្ងៃស្អែក",
//             color: Color(0xFF007A7A),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeader(BuildContext context) {
//     return Row(
//       children: [
//         Stack(
//           children: [
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const StudentEditProfileScreen(),
//                   ),
//                 );
//               },
//               child: const CircleAvatar(
//                 radius: 25,
//                 backgroundImage: NetworkImage(
//                   'https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?semt=ais_hybrid&w=740&q=80',
//                 ),
//               ),
//             ),
//             const Positioned(
//               right: 0,
//               bottom: 0,
//               child: CircleAvatar(
//                 radius: 10,
//                 backgroundColor: Colors.white,
//                 child: CircleAvatar(radius: 7, backgroundColor: Colors.green),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(width: 15),
//         const Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Alex Rivera",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 4),
//             Row(
//               children: [
//                 Badge(
//                   label: Text("ថ្នាក់ទី 11-1"),
//                   backgroundColor: Colors.lightBlueAccent,
//                 ),
//                 SizedBox(width: 8),
//                 Text(
//                   "#អត្តលេខ: #29401",
//                   style: TextStyle(color: Colors.black, fontSize: 12),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         const Spacer(),
//         Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: const Icon(Icons.notifications_none, color: Colors.black),
//         ),
//       ],
//     );
//   }

//   Widget _buildSectionTitle(String title, {String? actionText}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Color(0xFF1A1A1A),
//           ),
//         ),
//         if (actionText != null)
//           Text(
//             actionText,
//             style: const TextStyle(
//               color: Color(0xFF007A7A),
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _buildGridMenu(BuildContext context) {
//     return GridView.count(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       crossAxisCount: 3,
//       mainAxisSpacing: 15,
//       crossAxisSpacing: 15,
//       children: [
//         _menuItem(
//           context,
//           Icons.calendar_today,
//           "វត្តមាន",
//           Colors.orange,
//           const AttendanceDashboard(),
//         ),
//         _menuItem(
//           context,
//           Icons.show_chart,
//           "ប្រចាំខែ",
//           Colors.teal,
//           const StudentScoreScreen(),
//         ),
//         _menuItem(
//           context,
//           Icons.people,
//           "សុំអនុញ្ញាត",
//           Colors.blue,
//           const StudentPermissionScreen(),
//         ),
//         _menuItem(
//           context,
//           Icons.edit_note,
//           "កិច្ចការផ្ទះ",
//           Colors.green,
//           const StudentHomeworkScreen(),
//         ),
//         _menuItem(
//           context,
//           Icons.schedule,
//           "កាលវិភាគ",
//           Colors.redAccent,
//           const StudentScheduleScreen(),
//         ),
//         CategoryCard(
//           icon: Icons.qr_code_scanner,
//           color: Colors.green,
//           label: "កូដ QR",
//           bgColor: Colors.white,
//           iconColor: Colors.blue,
//         ),
//       ],
//     );
//   }

//   Widget _menuItem(
//     BuildContext context,
//     IconData icon,
//     String label,
//     Color color,
//     Widget screen,
//   ) {
//     return GestureDetector(
//       onTap: () => Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => screen),
//       ),
//       child: CategoryCard(icon: icon, label: label, color: color),
//     );
//   }
// }

// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:tamdansers/Controller/activity_list_widget.dart';
// import 'package:tamdansers/Controller/controller.dart';
// import 'package:tamdansers/Controller/course_card_widget.dart';
// import 'package:tamdansers/Screen/Edit-Profile/student_edit_profile.dart';
// import 'package:tamdansers/Screen/Role_STUDENT/attendance_student_role.dart';
// import 'package:tamdansers/Screen/Role_STUDENT/homework_student_role.dart';
// import 'package:tamdansers/Screen/Role_STUDENT/permision_student_role.dart';
// import 'package:tamdansers/Screen/Role_STUDENT/schedule_student_role.dart';
// import 'package:tamdansers/Screen/Role_STUDENT/score_student_role.dart';

// void main() => runApp(const MaterialApp(home: StudentDashboard()));

// class StudentDashboard extends StatefulWidget {
//   const StudentDashboard({super.key});

//   @override
//   State<StudentDashboard> createState() => _StudentDashboardState();
// }

// class _StudentDashboardState extends State<StudentDashboard> {
//   int _pageIndex = 0;
//   final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

//   // Navigation screens
//   final List<Widget> _screens = [
//     const StudentHomeContent(), // Index 0
//     const Center(child: Text("បណ្ណាល័យ (Library)")), // Index 1
//     const Center(child: Text("សារ (Messages)")), // Index 2
//     const StudentEditProfileScreen(), // Index 3
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7F9),
//       body: IndexedStack(index: _pageIndex, children: _screens),
//       bottomNavigationBar: CurvedNavigationBar(
//         key: _bottomNavigationKey,
//         index: _pageIndex,
//         height: 60.0,
//         items: const <Widget>[
//           Icon(Icons.grid_view_rounded, size: 30, color: Colors.white),
//           Icon(Icons.menu_book, size: 30, color: Colors.white),
//           Icon(Icons.chat_bubble, size: 30, color: Colors.white),
//           Icon(Icons.settings, size: 30, color: Colors.white),
//         ],
//         color: const Color(0xFF007A7A),
//         buttonBackgroundColor: const Color(0xFF007A7A),
//         backgroundColor: const Color(0xFFF5F7F9),
//         animationCurve: Curves.easeInOut,
//         animationDuration: const Duration(milliseconds: 300),
//         onTap: (index) {
//           setState(() {
//             _pageIndex = index;
//           });
//         },
//       ),
//     );
//   }
// }

// // --- MAIN CONTENT WIDGET ---
// class StudentHomeContent extends StatelessWidget {
//   const StudentHomeContent({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 20),
//             _buildHeader(context),
//             const SizedBox(height: 30),
//             _buildSectionTitle("ជម្រើសសិក្សា"),
//             const SizedBox(height: 15),
//             _buildGridMenu(context),
//             const SizedBox(height: 30),
//             _buildSectionTitle("វគ្គសិក្សា", actionText: "មើលទាំងអស់"),
//             const SizedBox(height: 15),
//             const CourseProgressCard(
//               title: "គណិតវិទ្យាកម្រិតខ្ពស់ II",
//               subtitle: "28 មេរៀន • 112 លំហាត់",
//               progress: 0.75,
//               percentage: "75%",
//               imagePath:
//                   'https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?semt=ais_hybrid&w=740&q=80',
//             ),
//             const SizedBox(height: 30),
//             _buildSectionTitle("សកម្មភាពថ្មីៗ"),
//             const SizedBox(height: 15),
//             const ActivityList(),
//             const SizedBox(height: 30),
//             _buildSectionTitle("កិច្ចការបន្ទាប់", actionText: "មើលទាំងអស់"),
//             const SizedBox(height: 15),
//             _buildNextTasksList(), // HELPER METHOD CALLED HERE
//             const SizedBox(height: 100),
//           ],
//         ),
//       ),
//     );
//   }

//   // HELPER METHOD: Next Tasks Horizontal List
//   Widget _buildNextTasksList() {
//     return SizedBox(
//       height: 160,
//       child: ListView(
//         scrollDirection: Axis.horizontal,
//         children: [
//           // REMOVED const HERE TO FIX ERROR
//           NextTaskCard(
//             subject: "ប្រវត្តិវិទ្យា",
//             title: "The French Revolution:\nNarrative Essay",
//             dueDate: "ឈប់កំណត់ថ្ងៃស្អែក",
//             color: Colors.orange,
//           ),
//           const SizedBox(width: 15),
//           NextTaskCard(
//             subject: "គីមីវិទ្យា",
//             title: "Acid-Base\nReport",
//             dueDate: "ឈប់កំណត់ថ្ងៃស្អែក",
//             color: const Color(0xFF007A7A),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeader(BuildContext context) {
//     return Row(
//       children: [
//         GestureDetector(
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const StudentEditProfileScreen(),
//             ),
//           ),
//           child: const CircleAvatar(
//             radius: 25,
//             backgroundImage: NetworkImage(
//               'https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?semt=ais_hybrid&w=740&q=80',
//             ),
//           ),
//         ),
//         const SizedBox(width: 15),
//         const Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Alex Rivera",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             Text(
//               "ថ្នាក់ទី 11-1 • #29401",
//               style: TextStyle(color: Colors.grey, fontSize: 12),
//             ),
//           ],
//         ),
//         const Spacer(),
//         const Icon(Icons.notifications_none, size: 28),
//       ],
//     );
//   }

//   Widget _buildSectionTitle(String title, {String? actionText}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         if (actionText != null)
//           Text(
//             actionText,
//             style: const TextStyle(
//               color: Color(0xFF007A7A),
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _buildGridMenu(BuildContext context) {
//     return GridView.count(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       crossAxisCount: 3,
//       mainAxisSpacing: 15,
//       crossAxisSpacing: 15,
//       children: [
//         _menuIcon(
//           context,
//           Icons.calendar_today,
//           "វត្តមាន",
//           Colors.orange,
//           const AttendanceDashboard(),
//         ),
//         _menuIcon(
//           context,
//           Icons.show_chart,
//           "ប្រចាំខែ",
//           Colors.teal,
//           const StudentScoreScreen(),
//         ),
//         _menuIcon(
//           context,
//           Icons.people,
//           "សុំអនុញ្ញាត",
//           Colors.blue,
//           const StudentPermissionScreen(),
//         ),
//         _menuIcon(
//           context,
//           Icons.edit_note,
//           "កិច្ចការផ្ទះ",
//           Colors.green,
//           const StudentHomeworkScreen(),
//         ),
//         _menuIcon(
//           context,
//           Icons.schedule,
//           "កាលវិភាគ",
//           Colors.redAccent,
//           const StudentScheduleScreen(),
//         ),
//         const CategoryCard(
//           icon: Icons.qr_code_scanner,
//           label: "កូដ QR",
//           color: Colors.blue,
//         ),
//       ],
//     );
//   }

//   Widget _menuIcon(
//     BuildContext context,
//     IconData icon,
//     String label,
//     Color color,
//     Widget screen,
//   ) {
//     return GestureDetector(
//       onTap: () => Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => screen),
//       ),
//       child: CategoryCard(icon: icon, label: label, color: color),
//     );
//   }
// }

// // --- REUSABLE WIDGET: NEXT TASK CARD ---
// // PLACE THIS OUTSIDE OF ALL OTHER CLASSES
// class NextTaskCard extends StatelessWidget {
//   final String subject, title, dueDate;
//   final Color color;

//   const NextTaskCard({
//     super.key,
//     required this.subject,
//     required this.title,
//     required this.dueDate,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 220,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: .05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               Icon(Icons.circle, size: 10, color: color),
//               const SizedBox(width: 8),
//               Text(
//                 subject,
//                 style: TextStyle(
//                   color: color,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 13,
//                 ),
//               ),
//             ],
//           ),
//           Text(
//             title,
//             style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//           ),
//           Row(
//             children: [
//               Icon(Icons.access_time, size: 14, color: color),
//               const SizedBox(width: 5),
//               Text(dueDate, style: TextStyle(color: color, fontSize: 11)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:tamdansers/Controller/activity_list_widget.dart';
import 'package:tamdansers/Controller/course_card_widget.dart';
import 'package:tamdansers/Screen/Edit-Profile/student_edit_profile.dart';
import 'package:tamdansers/Screen/Role_STUDENT/attendance_student_role.dart';
import 'package:tamdansers/Screen/Role_STUDENT/homework_student_role.dart';
import 'package:tamdansers/Screen/Role_STUDENT/permision_student_role.dart';
import 'package:tamdansers/Screen/Role_STUDENT/schedule_student_role.dart';
import 'package:tamdansers/Screen/Role_STUDENT/score_student_role.dart';
// Ensure these paths match your actual project structure
import 'package:tamdansers/contants/app_text_style.dart';

void main() => runApp(const MaterialApp(home: StudentDashboard()));

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _pageIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final List<Widget> _screens = [
    const StudentHomeContent(),
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

// --- MAIN CONTENT WIDGET ---
class StudentHomeContent extends StatelessWidget {
  const StudentHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                  'https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?w=740',
            ),
            const SizedBox(height: 30),
            _buildSectionTitle("សកម្មភាពថ្មីៗ"),
            const SizedBox(height: 15),
            const ActivityList(),
            const SizedBox(height: 30),
            _buildSectionTitle("កិច្ចការបន្ទាប់", actionText: "មើលទាំងអស់"),
            const SizedBox(height: 15),
            _buildNextTasksList(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const StudentEditProfileScreen(),
            ),
          ),
          child: const CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(
              'https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?w=740',
            ),
          ),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Alex Rivera", style: AppTextStyle.fontsize18),
            Text(
              "ថ្នាក់ទី 11-1 • #29401",
              style: AppTextStyle.body.copyWith(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const Spacer(),
        _buildNotificationBadge(),
      ],
    );
  }

  Widget _buildNotificationBadge() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Icon(
        Icons.notifications_none,
        color: Colors.black,
        size: 26,
      ),
    );
  }

  Widget _buildSectionTitle(String title, {String? actionText}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyle.sectionTitle20),
        if (actionText != null)
          Text(
            actionText,
            style: AppTextStyle.body.copyWith(
              color: const Color(0xFF007A7A),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
      ],
    );
  }

  Widget _buildGridMenu(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      children: [
        _menuIcon(
          context,
          Icons.calendar_today,
          "វត្តមាន",
          Colors.orange,
          const AttendanceDashboard(),
        ),
        _menuIcon(
          context,
          Icons.show_chart,
          "ប្រចាំខែ",
          Colors.teal,
          const StudentScoreScreen(),
        ),
        _menuIcon(
          context,
          Icons.people,
          "សុំអនុញ្ញាត",
          Colors.blue,
          const StudentPermissionScreen(),
        ),
        _menuIcon(
          context,
          Icons.edit_note,
          "កិច្ចការផ្ទះ",
          Colors.green,
          const StudentHomeworkScreen(),
        ),
        _menuIcon(
          context,
          Icons.schedule,
          "កាលវិភាគ",
          Colors.redAccent,
          const StudentScheduleScreen(),
        ),
        const CategoryCard(
          icon: Icons.qr_code_scanner,
          label: "កូដ QR",
          color: Colors.blue,
        ),
      ],
    );
  }

  Widget _menuIcon(
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
}

// --- REUSABLE WIDGET: NEXT TASK CARD ---
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
            color: Colors.black.withValues(alpha: .05),
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
                style: AppTextStyle.body.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          Text(
            title,
            style: AppTextStyle.body.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Row(
            children: [
              Icon(Icons.access_time, size: 14, color: color),
              const SizedBox(width: 5),
              Text(
                dueDate,
                style: AppTextStyle.body.copyWith(color: color, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- CATEGORY CARD (Grid Items) ---
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
            style: AppTextStyle.body.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
