// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:tamdansers/Screen/Dashboard/student_dashboard.dart';
// import 'package:tamdansers/Screen/Edit-Profile/student_edit_profile.dart';
// import 'package:tamdansers/contants/app_text_style.dart';

// class ParentHomeworkScreen extends StatelessWidget {
//   const ParentHomeworkScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     const Color primaryTeal = Color(0xFF007A7C);

//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FA),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: CircleAvatar(
//             backgroundColor: Colors.white,
//             child: Icon(Icons.menu, color: primaryTeal.withValues(alpha: 0.8)),
//           ),
//         ),
//         title: const Text(
//           'មជ្ឈមណ្ឌលកិច្ចការផ្ទះ', // Homework Center
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 16.0),
//             child: Stack(
//               alignment: Alignment.topRight,
//               children: [
//                 const CircleAvatar(
//                   backgroundColor: Colors.white,
//                   child: Icon(Icons.notifications_none, color: Colors.black),
//                 ),
//                 Positioned(
//                   top: 10,
//                   right: 10,
//                   child: Container(
//                     width: 8,
//                     height: 8,
//                     decoration: const BoxDecoration(
//                       color: Colors.red,
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 1. Student Identity Header
//             Row(
//               children: [
//                 const CircleAvatar(
//                   radius: 35,
//                   backgroundImage: NetworkImage(
//                     'https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?semt=ais_hybrid&w=740&q=80',
//                   ),
//                 ),
//                 const SizedBox(width: 15),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'កិច្ចការរបស់ Alex',
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       'ថ្នាក់ទី ៤ • សាលាបឋមសិក្សា Oakwood',
//                       style: TextStyle(color: Colors.blueGrey.shade400),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 25),

//             // 2. Weekly Progress Card
//             _buildProgressCard(primaryTeal),
//             const SizedBox(height: 25),

//             // 3. Search and Filters
//             _buildSearchBar(),
//             const SizedBox(height: 15),
//             _buildStatusFilters(primaryTeal),

//             // 4. Homework List
//             const Padding(
//               padding: EdgeInsets.symmetric(vertical: 20),
//               child: Text(
//                 'កិច្ចការបន្ទាប់',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ),
//             _buildHomeworkCard(
//               subject: 'គណិតវិទ្យា',
//               title: 'សមីការដឺក្រេទីពីរ',
//               desc: 'បំពេញសន្លឹកកិច្ចការនៅទំព័រ ៤២។ បង្ហាញជំហានដោះស្រាយ...',
//               teacher: 'កញ្ញា Sarah Jenkins',
//               status: 'ហួសកំណត់', // Overdue
//               statusColor: Colors.red,
//             ),
//             _buildHomeworkCard(
//               subject: 'អក្សរសាស្ត្រអង់គ្លេស',
//               title: 'របាយការណ៍សៀវភៅ: The Hobbit',
//               desc: 'សរសេរសេចក្ដីផ្ដើម និងការវិភាគតួអង្គ Bilbo Baggins។',
//               teacher: 'លោកស្រី Alice Wong',
//               status: 'ឈប់សម្រាកនៅថ្ងៃស្អែក', // Due Tomorrow
//               statusColor: Colors.orange,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {},
//         backgroundColor: primaryTeal,
//         child: const Icon(Icons.add, color: Colors.white, size: 30),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       bottomNavigationBar: _buildBottomNav(primaryTeal),
//     );
//   }
// class _StudentDashboardState extends State<StudentDashboard> {
//   int _pageIndex = 0;
//   final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

//   final List<Widget> _screens = [
//     const StudentHomeContent(),
//     Center(
//       child: Text("បណ្ណាល័យ (Library)", style: AppTextStyle.sectionTitle20),
//     ),
//     Center(child: Text("សារ (Messages)", style: AppTextStyle.sectionTitle20)),
//     const StudentEditProfileScreen(),
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

//   Widget _buildProgressCard(Color primaryColor) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(25),
//         boxShadow: [
//           BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 15),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'វឌ្ឍនភាពប្រចាំសប្ដាហ៍',
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//               Text(
//                 '70%',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.blue,
//                 ),
//               ),
//             ],
//           ),
//           const Text(
//             '៧ នៃ ១០ កិច្ចការបានបញ្ចប់',
//             style: TextStyle(color: Colors.grey, fontSize: 13),
//           ),
//           const SizedBox(height: 15),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: LinearProgressIndicator(
//               value: 0.7,
//               minHeight: 12,
//               backgroundColor: Colors.grey.shade100,
//               valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
//             ),
//           ),
//           const SizedBox(height: 15),
//           const Text(
//             'ជិតរួចរាល់ហើយ ALEX! ✨',
//             style: TextStyle(
//               color: Colors.orange,
//               fontWeight: FontWeight.bold,
//               fontSize: 12,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchBar() {
//     return TextField(
//       decoration: InputDecoration(
//         hintText: 'ស្វែងរកកិច្ចការ',
//         prefixIcon: const Icon(Icons.search),
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(30),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusFilters(Color primaryColor) {
//     final filters = ['ទាំងអស់', 'កំពុងរង់ចាំ', 'បានបញ្ចប់', 'ហួសកំណត់'];
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: filters.map((f) {
//           bool isActive = f == 'ទាំងអស់';
//           return Container(
//             margin: const EdgeInsets.only(right: 10),
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             decoration: BoxDecoration(
//               color: isActive ? primaryColor : Colors.white,
//               borderRadius: BorderRadius.circular(25),
//             ),
//             child: Text(
//               f,
//               style: TextStyle(
//                 color: isActive ? Colors.white : Colors.grey,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }

//   Widget _buildHomeworkCard({
//     required String subject,
//     required String title,
//     required String desc,
//     required String teacher,
//     required String status,
//     required Color statusColor,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         border: Border(left: BorderSide(color: statusColor, width: 5)),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Icon(Icons.calculate, color: statusColor, size: 20),
//                     const SizedBox(width: 8),
//                     Text(
//                       subject,
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 8,
//                     vertical: 4,
//                   ),
//                   decoration: BoxDecoration(
//                     color: statusColor.withValues(alpha: 0.1),
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   child: Text(
//                     status,
//                     style: TextStyle(
//                       color: statusColor,
//                       fontSize: 10,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             Text(
//               title,
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             Text(
//               desc,
//               style: const TextStyle(color: Colors.grey, fontSize: 13),
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//             const Divider(height: 25),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     const CircleAvatar(
//                       radius: 12,
//                       backgroundImage: NetworkImage(
//                         'https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?semt=ais_hybrid&w=740&q=80',
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       teacher,
//                       style: const TextStyle(color: Colors.grey, fontSize: 12),
//                     ),
//                   ],
//                 ),
//                 const Text(
//                   'លម្អិត >',
//                   style: TextStyle(
//                     color: Color(0xFF007A7C),
//                     fontWeight: FontWeight.bold,
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBottomNav(Color activeColor) {
//     return BottomAppBar(
//       shape: const CircularNotchedRectangle(),
//       notchMargin: 8,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           IconButton(icon: const Icon(Icons.home_outlined), onPressed: () {}),
//           IconButton(
//             icon: Icon(Icons.assignment, color: activeColor),
//             onPressed: () {},
//           ),
//           const SizedBox(width: 40),
//           IconButton(
//             icon: const Icon(Icons.calendar_today_outlined),
//             onPressed: () {},
//           ),
//           IconButton(
//             icon: const Icon(Icons.chat_bubble_outline),
//             onPressed: () {},
//           ),
//         ],
//       ),
//     );
//   }
// }
// class _Legend extends StatelessWidget {
//   final Color color;
//   final String label;
//   const _Legend({required this.color, required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           width: 8,
//           height: 8,
//           decoration: BoxDecoration(color: color, shape: BoxShape.circle),
//         ),
//         const SizedBox(width: 4),
//         Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
//       ],
//     );
//   }
// }

// class _SubjectItem extends StatelessWidget {
//   final String title, status;
//   final Color statusColor, color;
//   final IconData icon;

//   const _SubjectItem({
//     required this.title,
//     required this.status,
//     required this.statusColor,
//     required this.icon,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // ... your existing build code ...
//     return Container(); // Placeholder
//   }
// }import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:tamdansers/Screen/Edit-Profile/student_edit_profile.dart';
import 'package:tamdansers/contants/app_text_style.dart';

class ParentHomeworkScreen extends StatefulWidget {
  const ParentHomeworkScreen({super.key});

  @override
  State<ParentHomeworkScreen> createState() => _ParentHomeworkScreenState();
}

class _ParentHomeworkScreenState extends State<ParentHomeworkScreen> {
  int _pageIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final Color primaryTeal = const Color(0xFF007A7C);

  // Define the screens for each tab
  late final List<Widget> _screens = [
    _buildHomeworkHome(), // Tab 0: Homework Center
    Center(
      child: Text("បណ្ណាល័យ (Library)", style: AppTextStyle.sectionTitle20),
    ),
    Center(child: Text("សារ (Messages)", style: AppTextStyle.sectionTitle20)),
    const StudentEditProfileScreen(), // Tab 3: Settings/Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _pageIndex == 0
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: () {},
              ),
              title: const Text(
                'មជ្ឈមណ្ឌលកិច្ចការផ្ទះ',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications_none,
                    color: Colors.black,
                  ),
                  onPressed: () {},
                ),
              ],
            )
          : null,
      body: IndexedStack(index: _pageIndex, children: _screens),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _pageIndex,
        height: 60.0,
        items: const <Widget>[
          Icon(Icons.assignment_rounded, size: 30, color: Colors.white),
          Icon(Icons.menu_book, size: 30, color: Colors.white),
          Icon(Icons.chat_bubble, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
        ],
        color: primaryTeal,
        buttonBackgroundColor: primaryTeal,
        backgroundColor: const Color(0xFFF8F9FA),
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

  // --- Main Homework Content ---
  Widget _buildHomeworkHome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStudentHeader(),
          const SizedBox(height: 25),
          _buildProgressCard(primaryTeal),
          const SizedBox(height: 25),
          _buildSearchBar(),
          const SizedBox(height: 15),
          _buildStatusFilters(primaryTeal),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'កិច្ចការបន្ទាប់',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          _buildHomeworkCard(
            subject: 'គណិតវិទ្យា',
            title: 'សមីការដឺក្រេទីពីរ',
            desc: 'បំពេញសន្លឹកកិច្ចការនៅទំព័រ ៤២។ បង្ហាញជំហានដោះស្រាយ...',
            teacher: 'កញ្ញា Sarah Jenkins',
            status: 'ហួសកំណត់',
            statusColor: Colors.red,
            icon: Icons.calculate,
          ),
          _buildHomeworkCard(
            subject: 'អក្សរសាស្ត្រអង់គ្លេស',
            title: 'របាយការណ៍សៀវភៅ: The Hobbit',
            desc: 'សរសេរសេចក្ដីផ្ដើម និងការវិភាគតួអង្គ Bilbo Baggins។',
            teacher: 'លោកស្រី Alice Wong',
            status: 'ឈប់សម្រាកនៅថ្ងៃស្អែក',
            statusColor: Colors.orange,
            icon: Icons.menu_book,
          ),
        ],
      ),
    );
  }

  // --- UI Helper Components ---

  Widget _buildStudentHeader() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 35,
          backgroundImage: NetworkImage(
            'https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?w=740',
          ),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'កិច្ចការរបស់ Alex',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              'ថ្នាក់ទី ៤ • សាលាបឋមសិក្សា Oakwood',
              style: TextStyle(color: Colors.blueGrey.shade400),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressCard(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'វឌ្ឍនភាពប្រចាំសប្ដាហ៍',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                '70%',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          const Text(
            '៧ នៃ ១០ កិច្ចការបានបញ្ចប់',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 15),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 0.7,
              minHeight: 12,
              backgroundColor: Colors.grey.shade100,
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'ស្វែងរកកិច្ចការ',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildStatusFilters(Color primaryColor) {
    final filters = ['ទាំងអស់', 'កំពុងរង់ចាំ', 'បានបញ្ចប់', 'ហួសកំណត់'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((f) {
          bool isActive = f == 'ទាំងអស់';
          return Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isActive ? primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Text(
              f,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHomeworkCard({
    required String subject,
    required String title,
    required String desc,
    required String teacher,
    required String status,
    required Color statusColor,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border(left: BorderSide(color: statusColor, width: 5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, color: statusColor, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      subject,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              desc,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Divider(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  teacher,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const Text(
                  'លម្អិត >',
                  style: TextStyle(
                    color: Color(0xFF007A7C),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
