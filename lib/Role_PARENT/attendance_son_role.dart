// import 'package:flutter/material.dart';

// class ParentAttendanceMonitor extends StatelessWidget {
//   const ParentAttendanceMonitor({super.key});

//   @override
//   Widget build(BuildContext context) {
//     const Color primaryTeal = Color(0xFF007A7C);

//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FA),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'វត្តមានរបស់កូន', // Child's Attendance
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.notifications_none, color: Colors.black),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // 1. Student Profile Header
//             _buildStudentHeader(),

//             // 2. Attendance Overview (Circular Progress)
//             _buildAttendanceOverview(primaryTeal),

//             // 3. Calendar View
//             _buildAttendanceCalendar(primaryTeal),

//             // 4. Detailed Activity Log Section
//             Padding(
//               padding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     'កំណត់ចំណាំពីគ្រូ', // Teacher's Notes
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     'មើលទាំងអស់',
//                     style: TextStyle(color: primaryTeal, fontSize: 12),
//                   ),
//                 ],
//               ),
//             ),

//             _buildActivityNote(
//               date: '12 តុលា',
//               time: '08:15 AM',
//               status: 'មកយឺត', // Late
//               statusColor: Colors.orange,
//               note:
//                   'សិស្សមកដល់យឺតដោយសារគ្រួសារមានធុរៈចាំបាច់។ បានអនុញ្ញាតឱ្យចូលរៀនធម្មតា។',
//             ),
//             _buildActivityNote(
//               date: '07 តុលា',
//               time: 'Full Day',
//               status: 'អវត្តមាន', // Absent
//               statusColor: Colors.red,
//               note: 'អវត្តមានដោយមានច្បាប់ឈប់សម្រាកព្យាបាលជំងឺ (គ្រុនផ្តាសាយ)។',
//             ),
//             const SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }

//   // --- Helper Widgets ---

//   Widget _buildStudentHeader() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       child: Row(
//         children: [
//           const CircleAvatar(
//             radius: 35,
//             backgroundImage: NetworkImage(
//               'https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?w=740',
//             ),
//           ),
//           const SizedBox(width: 15),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'សុខ ចាន់ដារ៉ា',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 'ថ្នាក់ទី ៨A • អត្តលេខ: 12345',
//                 style: TextStyle(color: Colors.blueGrey.shade400, fontSize: 13),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAttendanceOverview(Color primaryColor) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
//         ],
//       ),
//       child: Column(
//         children: [
//           const Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'សង្ខេបវត្តមានសរុប',
//                 style: TextStyle(color: Colors.grey, fontSize: 13),
//               ),
//               Text(
//                 '+2%',
//                 style: TextStyle(
//                   color: Colors.green,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 12,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           Stack(
//             alignment: Alignment.center,
//             children: [
//               SizedBox(
//                 height: 150,
//                 width: 150,
//                 child: CircularProgressIndicator(
//                   value: 0.95,
//                   strokeWidth: 15,
//                   backgroundColor: Colors.grey.shade100,
//                   valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
//                 ),
//               ),
//               const Column(
//                 children: [
//                   Text(
//                     'PRESENT',
//                     style: TextStyle(color: Colors.grey, fontSize: 10),
//                   ),
//                   Text(
//                     '180 ថ្ងៃ',
//                     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 25),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildStat('វត្តមាន', '180', Colors.green),
//               _buildStat('អវត្តមាន', '5', Colors.red),
//               _buildStat('យឺត', '3', Colors.orange),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStat(String label, String value, Color color) {
//     return Column(
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             color: color,
//             fontSize: 12,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Text(
//           value,
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//       ],
//     );
//   }

//   Widget _buildAttendanceCalendar(Color primaryColor) {
//     return Container(
//       margin: const EdgeInsets.all(20),
//       padding: const EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Column(
//         children: [
//           const Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Icon(Icons.chevron_left, color: Colors.grey),
//               Text('តុលា 2023', style: TextStyle(fontWeight: FontWeight.bold)),
//               Icon(Icons.chevron_right, color: Colors.grey),
//             ],
//           ),
//           const SizedBox(height: 15),
//           const Text(
//             "ច័ន្ទ   អង្គារ   ពុធ   ព្រហ   សុក្រ",
//             style: TextStyle(color: Colors.grey, fontSize: 12),
//           ),
//           const SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildCalendarDay('5', Colors.white, primaryColor),
//               _buildCalendarDay('6', Colors.green, Colors.transparent),
//               _buildCalendarDay('7', Colors.red, Colors.transparent),
//               _buildCalendarDay('8', Colors.green, Colors.transparent),
//               _buildCalendarDay('11', Colors.orange, Colors.transparent),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCalendarDay(String day, Color dotColor, Color bg) {
//     return Column(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
//           child: Text(
//             day,
//             style: TextStyle(
//               color: bg == Colors.transparent ? Colors.black : Colors.white,
//             ),
//           ),
//         ),
//         if (dotColor != Colors.white)
//           Container(
//             height: 4,
//             width: 4,
//             decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
//           ),
//       ],
//     );
//   }

//   Widget _buildActivityNote({
//     required String date,
//     required String time,
//     required String status,
//     required Color statusColor,
//     required String note,
//   }) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Column(
//             children: [
//               Text(
//                 date.split(' ')[0],
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//               ),
//               Text(
//                 date.split(' ')[1],
//                 style: const TextStyle(color: Colors.grey, fontSize: 10),
//               ),
//             ],
//           ),
//           const SizedBox(width: 15),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 8,
//                         vertical: 2,
//                       ),
//                       decoration: BoxDecoration(
//                         color: statusColor.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                       child: Text(
//                         status,
//                         style: TextStyle(
//                           color: statusColor,
//                           fontSize: 10,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     Text(
//                       time,
//                       style: const TextStyle(color: Colors.grey, fontSize: 10),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   note,
//                   style: const TextStyle(
//                     fontSize: 12,
//                     color: Colors.blueGrey,
//                     height: 1.5,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:tamdansers/Screen/Edit-Profile/student_edit_profile.dart';
import 'package:tamdansers/contants/app_text_style.dart';

class ParentAttendanceMonitor extends StatefulWidget {
  const ParentAttendanceMonitor({super.key});

  @override
  State<ParentAttendanceMonitor> createState() =>
      _ParentAttendanceMonitorState();
}

class _ParentAttendanceMonitorState extends State<ParentAttendanceMonitor> {
  int _pageIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final Color tealTheme = const Color(0xFF0097A7);

  // Define the screens for each tab
  late final List<Widget> _screens = [
    _buildMonitorHome(), // Tab 0: Parent's view of child attendance
    Center(
      child: Text(
        "កិច្ចការផ្ទះ (Homework)",
        style: AppTextStyle.sectionTitle20,
      ),
    ),
    Center(
      child: Text("របាយការណ៍ (Reports)", style: AppTextStyle.sectionTitle20),
    ),
    const StudentEditProfileScreen(), // Settings/Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'តាមដានវត្តមានកូន', // Monitor Child Attendance
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: IndexedStack(index: _pageIndex, children: _screens),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _pageIndex,
        height: 60.0,
        items: const <Widget>[
          Icon(Icons.analytics_rounded, size: 30, color: Colors.white),
          Icon(Icons.assignment_turned_in, size: 30, color: Colors.white),
          Icon(Icons.pie_chart, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
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

  Widget _buildMonitorHome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Child Profile Header (Specific to Parent Monitor)
          _buildChildSummaryHeader(),
          const SizedBox(height: 20),
          _buildSummaryCard(tealTheme),
          const SizedBox(height: 20),
          _buildCalendarSection(tealTheme),
          const SizedBox(height: 20),
          _buildSubjectList(tealTheme),
        ],
      ),
    );
  }

  Widget _buildChildSummaryHeader() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(
            'https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?w=740',
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ឈ្មោះសិស្ស: Alex Johnson',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              'ថ្នាក់ទី 12A • ឆ្នាំសិក្សា 2024',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'សង្ខេបវត្តមានសរុប',
                style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'អត្រាមកសិក្សា',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 70,
                height: 70,
                child: CircularProgressIndicator(
                  value: 0.95,
                  strokeWidth: 7,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              const Text(
                '95%',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarSection(Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.chevron_left),
              Text('មេសា 2024', style: TextStyle(fontWeight: FontWeight.bold)),
              Icon(Icons.chevron_right),
            ],
          ),
          const SizedBox(height: 15),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
            ),
            itemCount: 30,
            itemBuilder: (context, index) {
              bool isPresent = (index + 1) % 5 != 0;
              return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isPresent
                      ? color.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: isPresent ? color : Colors.red,
                    fontSize: 12,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 15),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Legend(color: Colors.teal, label: 'វត្តមាន'),
              SizedBox(width: 15),
              _Legend(color: Colors.red, label: 'អវត្តមាន'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectList(Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ព័ត៌មានតាមមុខវិជ្ជា',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _SubjectItem(
          title: 'គណិតវិទ្យា',
          status: '៩៨%',
          statusColor: Colors.green,
          icon: Icons.calculate,
          color: color,
        ),
        const SizedBox(height: 10),
        _SubjectItem(
          title: 'រូបវិទ្យា',
          status: '៨៥%',
          statusColor: Colors.orange,
          icon: Icons.bolt,
          color: color,
        ),
      ],
    );
  }
}

// --- Helper Components ---

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

class _SubjectItem extends StatelessWidget {
  final String title, status;
  final Color statusColor, color;
  final IconData icon;

  const _SubjectItem({
    required this.title,
    required this.status,
    required this.statusColor,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            status,
            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
