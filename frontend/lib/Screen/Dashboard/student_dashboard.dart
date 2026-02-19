
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:flutter/material.dart';
// // --- CONTROLLER & SERVICE IMPORTS ---
// import 'package:tamdansers/Controller/activity_list_widget.dart';
// import 'package:tamdansers/Controller/course_card_widget.dart';
// import 'package:tamdansers/Screen/Edit-Profile/student_edit_profile.dart';
// import 'package:tamdansers/Screen/Role_STUDENT/attendance_student_role.dart';
// import 'package:tamdansers/Screen/Role_STUDENT/course_student.role.dart';
// import 'package:tamdansers/Screen/Role_STUDENT/homework_student_role.dart';
// import 'package:tamdansers/Screen/Role_STUDENT/notification_student_role.dart';
// import 'package:tamdansers/Screen/Role_STUDENT/permision_student_role.dart';
// import 'package:tamdansers/Screen/Role_STUDENT/schedule_student_role.dart';
// import 'package:tamdansers/Screen/Role_STUDENT/score_student_role.dart';
// import 'package:tamdansers/contants/app_text_style.dart';
// import 'package:tamdansers/services/api_service.dart';

// void main() => runApp(
//   const MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: StudentDashboard(),
//   ),
// );

// class StudentDashboard extends StatefulWidget {
//   const StudentDashboard({super.key});

//   @override
//   State<StudentDashboard> createState() => _StudentDashboardState();
// }

// class _StudentDashboardState extends State<StudentDashboard> {
//   int _pageIndex = 0;
//   final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

//   // The screens used by the Bottom Navigation Bar
//   final List<Widget> _screens = [
//     const StudentHomeContent(), // Index 0
//     Center(
//       child: Text("Library", style: AppTextStyle.sectionTitle20),
//     ), // Index 1
//     Center(
//       child: Text("Messages", style: AppTextStyle.sectionTitle20),
//     ), // Index 2
//     const StudentEditProfileScreen(), // Index 3
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       // IndexedStack keeps the state of pages alive while switching
//       body: IndexedStack(index: _pageIndex, children: _screens),
//       bottomNavigationBar: CurvedNavigationBar(
//         key: _bottomNavigationKey,
//         index: _pageIndex,
//         height: 65.0,
//         items: const <Widget>[
//           Icon(Icons.grid_view_rounded, size: 28, color: Colors.white),
//           Icon(Icons.menu_book_rounded, size: 28, color: Colors.white),
//           Icon(
//             Icons.chat_bubble_outline_rounded,
//             size: 28,
//             color: Colors.white,
//           ),
//           Icon(Icons.person_outline_rounded, size: 28, color: Colors.white),
//         ],
//         color: const Color(0xFF007A7A),
//         buttonBackgroundColor: const Color(0xFF007A7A),
//         backgroundColor: Colors.transparent,
//         animationCurve: Curves.easeInOutCubic,
//         animationDuration: const Duration(milliseconds: 400),
//         onTap: (index) => setState(() => _pageIndex = index),
//       ),
//     );
//   }
// }

// // =============================================================================
// // STUDENT HOME CONTENT (The Actual Home Screen Logic)
// // =============================================================================
// class StudentHomeContent extends StatefulWidget {
//   const StudentHomeContent({super.key});

//   @override
//   State<StudentHomeContent> createState() => _StudentHomeContentState();
// }

// class _StudentHomeContentState extends State<StudentHomeContent> {
//   String _userName = '';
//   String _userEmail = '';

//   // ANIMATION CONTROLLERS (Moved here where the PageView lives)
//   late PageController _pageController;
//   double _currentPage = 0.0;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();

//     // Initialize the slider controller
//     _pageController = PageController(viewportFraction: 0.85);

//     // Listener to track scroll position for the scaling animation
//     _pageController.addListener(() {
//       if (_pageController.hasClients) {
//         setState(() {
//           _currentPage = _pageController.page ?? 0.0;
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _pageController.dispose(); // Prevent memory leaks
//     super.dispose();
//   }

//   Future<void> _loadUserData() async {
//     final apiService = ApiService();
//     final name = await apiService.getUserName();
//     final email = await apiService.getUserEmail();
//     if (mounted) {
//       setState(() {
//         _userName = name ?? 'Student';
//         _userEmail = email ?? '';
//       });
//     }
//   }

//   void _navigateToDetail(BuildContext context, String title, bool isTask) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) =>
//             DetailedViewScreen(title: title, isTaskView: isTask),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         padding: const EdgeInsets.symmetric(horizontal: 22),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 25),
//             _buildHeader(context),
//             const SizedBox(height: 35),
//             _buildSectionTitle("Learning Options"),
//             const SizedBox(height: 18),
//             _buildGridMenu(context),
//             const SizedBox(height: 35),
//             _buildSectionTitle("Current Progress", actionText: "View All"),
//             const SizedBox(height: 18),
//             const CourseProgressCard(
//               title: "Advanced Mathematics II",
//               subtitle: "28 lessons • 112 exercises",
//               progress: 0.75,
//               percentage: "75%",
//               imagePath:
//                   'https://images.unsplash.com/photo-1635070041078-e363dbe005cb?w=500',
//             ),
//             const SizedBox(height: 35),
//             _buildSectionTitle("School Events", actionText: "See All"),
//             const SizedBox(height: 18),
//             _buildActivitySlider(), // Call the animated slider
//             const SizedBox(height: 35),
//             _buildSectionTitle("Recent Activity", actionText: "View All"),
//             const SizedBox(height: 18),
//             const ActivityList(),
//             const SizedBox(height: 35),
//             _buildSectionTitle("Upcoming Tasks", actionText: "View All"),
//             const SizedBox(height: 18),
//             _buildNextTasksList(),
//             const SizedBox(height: 120),
//           ],
//         ),
//       ),
//     );
//   }

//   // --- WIDGET BUILDERS ---

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
//             radius: 28,
//             backgroundImage: NetworkImage(
//               'https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?w=740',
//             ),
//           ),
//         ),
//         const SizedBox(width: 15),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Welcome back,",
//               style: AppTextStyle.body.copyWith(
//                 color: Colors.grey[500],
//                 fontSize: 13,
//               ),
//             ),
//             Text(
//               _userName,
//               style: AppTextStyle.fontsize18.copyWith(
//                 fontWeight: FontWeight.w900,
//               ),
//             ),
//           ],
//         ),
//         const Spacer(),
//         _buildNotificationBadge(context),
//       ],
//     );
//   }

//   Widget _buildActivitySlider() {
//     final List<Map<String, dynamic>> events = [
//       {
//         "title": "Annual School Sports Day",
//         "date": "14 Oct 2026",
//         "imageUrl":
//             'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSriJvLnlsd17xcaVi9e8e-dcBoe_CgXcmqfA&s',
//         "isLive": true,
//       },
//       {
//         "title": "Science & Tech Exhibition",
//         "date": "20 Oct 2026",
//         "imageUrl":
//             'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTS-8XwPtLjsUaMcwdEfkHuQjWZFslzBauCDg&s',
//         "isLive": false,
//       },
//       {
//         "title": "Music & Arts Festival",
//         "date": "05 Nov 2026",
//         "imageUrl":
//             'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSBKK6rsru9MzCflpsYthWZyFufNGDQ1CDbrw&s',
//         "isLive": false,
//       },
//     ];

//     return CarouselSlider.builder(
//       itemCount: events.length,
//       itemBuilder: (context, index, realIndex) {
//         return ActivitySliderCard(
//           title: events[index]["title"],
//           date: events[index]["date"],
//           imageUrl: events[index]["imageUrl"],
//           isLive: events[index]["isLive"],
//         );
//       },
//       options: CarouselOptions(
//         height: 300,
//         viewportFraction: 0.85, // Shows parts of side cards
//         enlargeCenterPage: true, // This enables the scaling animation
//         enlargeStrategy: CenterPageEnlargeStrategy.scale,
//         enlargeFactor: 0.15, // Roughly equivalent to your 0.85 scale (1 - 0.15)
//         enableInfiniteScroll: true,
//         autoPlay: true,
//         autoPlayInterval: const Duration(seconds: 4),
//         autoPlayAnimationDuration: const Duration(milliseconds: 800),
//         autoPlayCurve: Curves.fastOutSlowIn,
//       ),
//     );
//   }

//   Widget _buildNotificationBadge(BuildContext context) {
//     return GestureDetector(
//       onTap: () => Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const NotificationScreen()),
//       ),
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(18),
//         ),
//         child: const Stack(
//           children: [
//             Icon(
//               Icons.notifications_none_rounded,
//               color: Colors.black87,
//               size: 24,
//             ),
//             Positioned(
//               right: 2,
//               top: 2,
//               child: CircleAvatar(radius: 4, backgroundColor: Colors.red),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionTitle(
//     String title, {
//     String? actionText,
//     VoidCallback? onActionTap,
//   }) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           title,
//           style: AppTextStyle.sectionTitle20.copyWith(
//             fontWeight: FontWeight.w800,
//             fontSize: 19,
//             color: const Color(0xFF1E293B),
//           ),
//         ),
//         if (actionText != null)
//           TextButton(
//             onPressed: onActionTap ?? () {},
//             child: Text(
//               actionText,
//               style: const TextStyle(
//                 color: Color(0xFF007A7A),
//                 fontWeight: FontWeight.bold,
//                 fontSize: 13,
//               ),
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
//       mainAxisSpacing: 18,
//       crossAxisSpacing: 18,
//       childAspectRatio: 0.9,
//       children: [
//         _menuIcon(
//           context,
//           Icons.calendar_month_rounded,
//           "Attendance",
//           Colors.orange,
//           const AttendanceDashboard(),
//         ),
//         _menuIcon(
//           context,
//           Icons.auto_graph_rounded,
//           "Monthly",
//           Colors.teal,
//           const StudentScoreScreen(),
//         ),
//         _menuIcon(
//           context,
//           Icons.assignment_ind_rounded,
//           "Permission",
//           Colors.blue,
//           const StudentPermissionScreen(),
//         ),
//         _menuIcon(
//           context,
//           Icons.history_edu_rounded,
//           "Homework",
//           Colors.green,
//           const StudentHomeworkScreen(),
//         ),
//         _menuIcon(
//           context,
//           Icons.timer_rounded,
//           "Schedule",
//           Colors.redAccent,
//           const StudentScheduleScreen(),
//         ),
//         _menuIcon(
//           context,
//           Icons.menu_book_rounded,
//           "Course",
//           Colors.indigo,
//           const ClassCourseStudentScreen(),
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

//   Widget _buildNextTasksList() {
//     return SizedBox(
//       height: 165,
//       child: ListView(
//         scrollDirection: Axis.horizontal,
//         physics: const BouncingScrollPhysics(),
//         children: const [
//           NextTaskCard(
//             subject: "History",
//             title: "The French Revolution:\nNarrative Essay",
//             dueDate: "Due Tomorrow",
//             color: Colors.orange,
//           ),
//           SizedBox(width: 15),
//           NextTaskCard(
//             subject: "Chemistry",
//             title: "Acid-Base\nLab Report",
//             dueDate: "Due Tomorrow",
//             color: Color(0xFF007A7A),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // =============================================================================
// // SUPPORTING UI WIDGETS
// // =============================================================================

// class ActivitySliderCard extends StatelessWidget {
//   final String title, date, imageUrl;
//   final bool isLive;

//   const ActivitySliderCard({
//     super.key,
//     required this.title,
//     required this.date,
//     required this.imageUrl,
//     this.isLive = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(28),
//         image: DecorationImage(
//           image: NetworkImage(imageUrl),
//           fit: BoxFit.cover,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 20,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(28),
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
//           ),
//         ),
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             if (isLive)
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 6,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.redAccent,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     CircleAvatar(radius: 3, backgroundColor: Colors.white),
//                     SizedBox(width: 6),
//                     Text(
//                       "LIVE",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 10,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     const Icon(
//                       Icons.calendar_month_rounded,
//                       color: Colors.white70,
//                       size: 14,
//                     ),
//                     const SizedBox(width: 6),
//                     Text(
//                       date,
//                       style: const TextStyle(
//                         color: Colors.white70,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
//       width: 230,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24),
//         border: Border(left: BorderSide(color: color, width: 6)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 20,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Text(
//               subject,
//               style: TextStyle(
//                 color: color,
//                 fontWeight: FontWeight.w900,
//                 fontSize: 11,
//                 letterSpacing: 0.5,
//               ),
//             ),
//           ),
//           Text(
//             title,
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 15,
//               color: Color(0xFF1E293B),
//               height: 1.3,
//             ),
//           ),
//           Row(
//             children: [
//               Icon(Icons.alarm_rounded, size: 16, color: Colors.grey[400]),
//               const SizedBox(width: 6),
//               Text(
//                 dueDate,
//                 style: TextStyle(
//                   color: Colors.grey[500],
//                   fontSize: 12,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
// class AllProgressScreen extends StatelessWidget {
//   const AllProgressScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final List<Map<String, dynamic>> courses = [
//       {"title": "Advanced Mathematics II", "sub": "28 lessons", "prog": 0.75},
//       {"title": "Quantum Physics", "sub": "18 lessons", "prog": 0.45},
//       {"title": "World History", "sub": "22 lessons", "prog": 0.90},
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Current Progress"),
//         foregroundColor: Colors.black,
//         backgroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(20),
//         itemCount: courses.length,
//         itemBuilder: (context, index) {
//           final course = courses[index];
//           return Padding(
//             padding: const EdgeInsets.only(bottom: 20),
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => CourseDetailScreen(
//                       title: course["title"] as String,
//                       progress: course["prog"] as double,
//                     ), // Closed CourseDetailScreen
//                   ), // Closed MaterialPageRoute
//                 ); // Closed Navigator.push
//               },
//               child: CourseProgressCard(
//                 title: course["title"] as String,
//                 subtitle: course["sub"] as String,
//                 progress: course["prog"] as double,
//                 percentage: "${((course["prog"] as double) * 100).toInt()}%",
//                 imagePath: 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=500',
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
// class SchoolEventsListScreen extends StatelessWidget {
//   const SchoolEventsListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final List<Map<String, dynamic>> events = [
//       {"title": "Annual Sports Day", "date": "14 Oct 2026", "img": "https://images.unsplash.com/photo-1502920514313-52181387295e?w=500", "desc": "Join us for a day of athletic excellence and teamwork!"},
//       {"title": "Tech Exhibition", "date": "20 Oct 2026", "img": "https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?w=500", "desc": "Showcasing the latest student innovations in robotics and AI."},
//       {"title": "Art Gala", "date": "05 Nov 2026", "img": "https://images.unsplash.com/photo-1460661419201-fd4cecdf8a8b?w=500", "desc": "A night of fine arts and creativity from our student body."},
//     ];

//     return Scaffold(
//       appBar: AppBar(title: const Text("Upcoming Events"), foregroundColor: Colors.black, backgroundColor: Colors.white, elevation: 0),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(20),
//         itemCount: events.length,
//         itemBuilder: (context, index) => GestureDetector(
//           onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetailScreen(event: events[index]))),
//           child: Card(
//             margin: const EdgeInsets.only(bottom: 20),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//             child: Column(
//               children: [
//                 ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), child: Image.network(events[index]["img"], height: 160, width: double.infinity, fit: BoxFit.cover)),
//                 ListTile(title: Text(events[index]["title"], style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text(events[index]["date"]), trailing: const Icon(Icons.arrow_forward_ios, size: 16)),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// class EventDetailScreen extends StatelessWidget {
//   final Map<String, dynamic> event;
//   const EventDetailScreen({super.key, required this.event});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(event["title"]), foregroundColor: Colors.black, backgroundColor: Colors.white, elevation: 0),
//       body: Column(
//         children: [
//           Image.network(event["img"], height: 250, width: double.infinity, fit: BoxFit.cover),
//           Padding(
//             padding: const EdgeInsets.all(25),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(children: [const Icon(Icons.calendar_today, size: 18), const SizedBox(width: 10), Text(event["date"], style: const TextStyle(fontWeight: FontWeight.bold))]),
//                 const SizedBox(height: 20),
//                 Text(event["desc"] ?? "No description available.", style: const TextStyle(fontSize: 16, height: 1.5)),
//                 const SizedBox(height: 30),
//                 SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF007A7A), padding: const EdgeInsets.symmetric(vertical: 15)), child: const Text("Register for Event", style: TextStyle(color: Colors.white)))),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
// class CourseDetailScreen extends StatelessWidget {
//   final String title;
//   final double progress;
  
//   const CourseDetailScreen({
//     super.key, 
//     required this.title, 
//     required this.progress,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text(title), 
//         backgroundColor: Colors.white, 
//         foregroundColor: Colors.black, 
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(25),
//         child: Column(
//           children: [
//             Container(
//               height: 180, 
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20), 
//                 image: const DecorationImage(
//                   image: NetworkImage("https://images.unsplash.com/photo-1635070041078-e363dbe005cb?w=800"), 
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 30),
//             Text(
//               "Completion: ${(progress * 100).toInt()}%", 
//               style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 15),
//             LinearProgressIndicator(
//               value: progress, 
//               minHeight: 12, 
//               borderRadius: BorderRadius.circular(10), 
//               color: const Color(0xFF007A7A),
//               backgroundColor: Colors.grey[200],
//             ),
//             const SizedBox(height: 40),
//             _buildLessonTile("Chapter 1: Foundations", true),
//             _buildLessonTile("Chapter 2: Intermediate Concepts", true),
//             _buildLessonTile("Chapter 3: Final Assessment", false),
//           ],
//         ),
//       ),
//     );
//   }

//   // Helper method to keep code clean and avoid bracket errors
//   Widget _buildLessonTile(String title, bool isCompleted) {
//     return ListTile(
//       leading: Icon(
//         isCompleted ? Icons.check_circle : Icons.radio_button_off, 
//         color: isCompleted ? Colors.green : Colors.grey,
//       ),
//       title: Text(title),
//     );
//   }
// }
// class CategoryCard extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final Color color;
//   const CategoryCard({
//     super.key,
//     required this.icon,
//     required this.label,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 15,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [color.withOpacity(0.2), color.withOpacity(0.05)],
//               ),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(icon, color: color, size: 28),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             label,
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w700,
//               color: Color(0xFF334155),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class DetailedViewScreen extends StatelessWidget {
//   final String title;
//   final bool isTaskView;
//   const DetailedViewScreen({
//     super.key,
//     required this.title,
//     required this.isTaskView,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(title), centerTitle: true),
//       body: Center(child: Text("Detailed view for $title")),
//     );
//   }
// }
// //When click on view all or on advandced mathematic of current progress it will show detail and go to list of this .and when click see all of school events it will show list of school events and show detail and have picture .and give me all code

import 'package:carousel_slider/carousel_slider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

// --- CONTROLLER & SERVICE IMPORTS ---
import 'package:tamdansers/Controller/activity_list_widget.dart';
import 'package:tamdansers/Controller/course_card_widget.dart';
import 'package:tamdansers/Screen/Edit-Profile/student_edit_profile.dart';
import 'package:tamdansers/Screen/Role_STUDENT/attendance_student_role.dart';
import 'package:tamdansers/Screen/Role_STUDENT/course_student.role.dart';
import 'package:tamdansers/Screen/Role_STUDENT/homework_student_role.dart';
import 'package:tamdansers/Screen/Role_STUDENT/notification_student_role.dart';
import 'package:tamdansers/Screen/Role_STUDENT/permision_student_role.dart';
import 'package:tamdansers/Screen/Role_STUDENT/schedule_student_role.dart';
import 'package:tamdansers/Screen/Role_STUDENT/score_student_role.dart';
import 'package:tamdansers/contants/app_text_style.dart';
import 'package:tamdansers/services/api_service.dart';

void main() => runApp(
  const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: StudentDashboard(),
  ),
);

// =============================================================================
// MAIN DASHBOARD
// =============================================================================
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
    Center(child: Text("Library", style: AppTextStyle.sectionTitle20)),
    Center(child: Text("Messages", style: AppTextStyle.sectionTitle20)),
    const StudentEditProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: IndexedStack(index: _pageIndex, children: _screens),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _pageIndex,
        height: 65.0,
        items: const <Widget>[
          Icon(Icons.grid_view_rounded, size: 28, color: Colors.white),
          Icon(Icons.menu_book_rounded, size: 28, color: Colors.white),
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: 28,
            color: Colors.white,
          ),
          Icon(Icons.person_outline_rounded, size: 28, color: Colors.white),
        ],
        color: const Color(0xFF007A7A),
        buttonBackgroundColor: const Color(0xFF007A7A),
        backgroundColor: Colors.transparent,
        onTap: (index) => setState(() => _pageIndex = index),
      ),
    );
  }
}

// =============================================================================
// STUDENT HOME CONTENT
// =============================================================================
class StudentHomeContent extends StatefulWidget {
  const StudentHomeContent({super.key});

  @override
  State<StudentHomeContent> createState() => _StudentHomeContentState();
}

class _StudentHomeContentState extends State<StudentHomeContent> {
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final apiService = ApiService();
    final name = await apiService.getUserName();
    if (mounted) setState(() => _userName = name ?? 'Student');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            _buildHeader(context),
            const SizedBox(height: 35),
            _buildSectionTitle("Learning Options"),
            const SizedBox(height: 18),
            _buildGridMenu(context),
            const SizedBox(height: 35),

            // PROGRESS SECTION
            _buildSectionTitle(
              "Current Progress",
              actionText: "View All",
              onActionTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AllProgressScreen(),
                ),
              ),
            ),
            const SizedBox(height: 18),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CourseDetailScreen(
                    title: "Advanced Mathematics II",
                    progress: 0.75,
                  ),
                ),
              ),
              child: const CourseProgressCard(
                title: "Advanced Mathematics II",
                subtitle: "28 lessons • 112 exercises",
                progress: 0.75,
                percentage: "75%",
                imagePath:
                    'https://images.unsplash.com/photo-1635070041078-e363dbe005cb?w=500',
              ),
            ),

            const SizedBox(height: 35),
            // EVENTS SECTION
            _buildSectionTitle(
              "School Events",
              actionText: "See All",
              onActionTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SchoolEventsListScreen(),
                ),
              ),
            ),
            const SizedBox(height: 18),
            _buildActivitySlider(),

            const SizedBox(height: 35),
            _buildSectionTitle("Recent Activity", actionText: "View All"),
            const SizedBox(height: 18),
            const ActivityList(),
            const SizedBox(height: 120),
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
            radius: 28,
            backgroundImage: NetworkImage(
              'https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?w=740',
            ),
          ),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome back,",
              style: AppTextStyle.body.copyWith(
                color: Colors.grey[500],
                fontSize: 13,
              ),
            ),
            Text(
              _userName,
              style: AppTextStyle.fontsize18.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NotificationScreen()),
          ),
          icon: const Icon(Icons.notifications_none_rounded, size: 28),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(
    String title, {
    String? actionText,
    VoidCallback? onActionTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyle.sectionTitle20.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        if (actionText != null)
          TextButton(
            onPressed: onActionTap,
            child: Text(
              actionText,
              style: const TextStyle(
                color: Color(0xFF007A7A),
                fontWeight: FontWeight.bold,
              ),
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
      mainAxisSpacing: 18,
      crossAxisSpacing: 18,
      children: [
        _menuIcon(
          context,
          Icons.calendar_month_rounded,
          "Attendance",
          Colors.orange,
          const AttendanceDashboard(),
        ),
        _menuIcon(
          context,
          Icons.auto_graph_rounded,
          "Monthly",
          Colors.teal,
          const StudentScoreScreen(),
        ),
        _menuIcon(
          context,
          Icons.assignment_ind_rounded,
          "Permission",
          Colors.blue,
          const StudentPermissionScreen(),
        ),
        _menuIcon(
          context,
          Icons.history_edu_rounded,
          "Homework",
          Colors.green,
          const StudentHomeworkScreen(),
        ),
        _menuIcon(
          context,
          Icons.timer_rounded,
          "Schedule",
          Colors.redAccent,
          const StudentScheduleScreen(),
        ),
        _menuIcon(
          context,
          Icons.menu_book_rounded,
          "Course",
          Colors.indigo,
          const ClassCourseStudentScreen(),
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

  Widget _buildActivitySlider() {
    final List<Map<String, dynamic>> events = [
      {
        "title": "Annual Sports Day",
        "date": "14 Oct 2026",
        "img":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTS-8XwPtLjsUaMcwdEfkHuQjWZFslzBauCDg&s",
      },
      {
        "title": "Tech Exhibition",
        "date": "20 Oct 2026",
        "img":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSBKK6rsru9MzCflpsYthWZyFufNGDQ1CDbrw&s",
      },
      {
        "title": "Tech Exhibition",
        "date": "20 Oct 2026",
        "img":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSriJvLnlsd17xcaVi9e8e-dcBoe_CgXcmqfA&s",
      },
    ];
    return CarouselSlider.builder(
      itemCount: events.length,
      itemBuilder: (context, index, realIndex) => GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailScreen(event: events[index]),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: NetworkImage(events[index]["img"]),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(0.7), Colors.transparent],
              ),
            ),
            child: Text(
              events[index]["title"],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      options: CarouselOptions(
        height: 200,
        enlargeCenterPage: true,
        autoPlay: true,
        viewportFraction: 0.85,
      ),
    );
  }
}

// =============================================================================
// PROGRESS SCREENS
// =============================================================================
class AllProgressScreen extends StatelessWidget {
  const AllProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> courses = [
      {"title": "Advanced Mathematics II", "sub": "28 lessons", "prog": 0.75},
      {"title": "Quantum Physics", "sub": "18 lessons", "prog": 0.45},
      {"title": "World History", "sub": "22 lessons", "prog": 0.90},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Course Progress"),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseDetailScreen(
                    title: course["title"] as String,
                    progress: course["prog"] as double,
                  ),
                ),
              ),
              child: CourseProgressCard(
                title: course["title"] as String,
                subtitle: course["sub"] as String,
                progress: course["prog"] as double,
                percentage: "${((course["prog"] as double) * 100).toInt()}%",
                imagePath:
                    'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=500',
              ),
            ),
          );
        },
      ),
    );
  }
}

class CourseDetailScreen extends StatelessWidget {
  final String title;
  final double progress;

  const CourseDetailScreen({
    super.key,
    required this.title,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: NetworkImage(
                    "https://images.unsplash.com/photo-1635070041078-e363dbe005cb?w=800",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              "Completion: ${(progress * 100).toInt()}%",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFF007A7A),
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(height: 40),
            _buildLessonTile("Chapter 1: Foundations", true),
            _buildLessonTile("Chapter 2: Intermediate Concepts", true),
            _buildLessonTile("Chapter 3: Final Assessment", false),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonTile(String title, bool isCompleted) {
    return ListTile(
      leading: Icon(
        isCompleted ? Icons.check_circle : Icons.radio_button_off,
        color: isCompleted ? Colors.green : Colors.grey,
      ),
      title: Text(title),
    );
  }
}

// =============================================================================
// EVENT SCREENS
// =============================================================================
class SchoolEventsListScreen extends StatelessWidget {
  const SchoolEventsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> events = [
      {
        "title": "Annual Sports Day",
        "date": "14 Oct 2026",
        "img":
            "https://images.unsplash.com/photo-1502920514313-52181387295e?w=500",
        "desc": "Join us for a day of athletic excellence and teamwork!",
      },
      {
        "title": "Tech Exhibition",
        "date": "20 Oct 2026",
        "img":
            "https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?w=500",
        "desc": "Showcasing the latest student innovations in robotics and AI.",
      },
      {
        "title": "Art Gala",
        "date": "05 Nov 2026",
        "img":
            "https://images.unsplash.com/photo-1460661419201-fd4cecdf8a8b?w=500",
        "desc": "A night of fine arts and creativity from our student body.",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Upcoming Events"),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: events.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailScreen(event: events[index]),
            ),
          ),
          child: Card(
            margin: const EdgeInsets.only(bottom: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: Image.network(
                    events[index]["img"],
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                ListTile(
                  title: Text(
                    events[index]["title"],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(events[index]["date"]),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EventDetailScreen extends StatelessWidget {
  final Map<String, dynamic> event;
  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event["title"]),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Image.network(
            event["img"],
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 18),
                    const SizedBox(width: 10),
                    Text(
                      event["date"],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  event["desc"] ?? "No description available.",
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007A7A),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      "Register for Event",
                      style: TextStyle(color: Colors.white),
                    ),
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

// =============================================================================
// CATEGORY CARD WIDGET
// =============================================================================
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
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.teal.shade700, blurRadius: 6, offset: const Offset(0, 6))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// Ensure DetailedViewScreen is defined if you use it in other logic
class DetailedViewScreen extends StatelessWidget {
  final String title;
  final bool isTaskView;
  const DetailedViewScreen({
    super.key,
    required this.title,
    required this.isTaskView,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text("Detailed view for $title")),
    );
  }
}
