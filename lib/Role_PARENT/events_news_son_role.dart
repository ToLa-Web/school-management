// import 'package:flutter/material.dart';

// class SchoolNewsEventsScreen extends StatelessWidget {
//   const SchoolNewsEventsScreen({super.key});

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
//           'ព័ត៌មាន និងព្រឹត្តិការណ៍', // News and Events
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search, color: Colors.black),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 1. Featured News Section
//             _buildSectionHeader('ព័ត៌មានថ្មីៗ', () {}), // Latest News
//             SizedBox(
//               height: 280,
//               child: ListView(
//                 scrollDirection: Axis.horizontal,
//                 padding: const EdgeInsets.symmetric(horizontal: 15),
//                 children: [
//                   _buildNewsCard(
//                     imageUrl: 'https://via.placeholder.com/300x200',
//                     tag: 'សាលារៀន', // School
//                     date: '២០ តុលា ២០២៣',
//                     title: 'ពិធីបុណ្យអុំទូក និងការឈប់សម្រាករបស់សិស្សានុសិស្ស',
//                     desc:
//                         'សាលានឹងត្រូវឈប់សម្រាកក្នុងឱកាសបុណ្យអុំទូកខាងមុខនេះ...',
//                   ),
//                   _buildNewsCard(
//                     imageUrl: 'https://via.placeholder.com/300x200',
//                     tag: 'ការប្រកួត', // Competition
//                     date: '១៨ តុលា ២០២៣',
//                     title: 'លទ្ធផលនៃការប្រកួតគណិតវិទ្យាថ្នាក់ជាតិ',
//                     desc: 'អបអរសាទរសិស្សានុសិស្សដែលទទួលបានជ័យលាភី...',
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 20),

//             // 2. Upcoming Events Section
//             _buildSectionHeader(
//               'ព្រឹត្តិការណ៍ជិតមកដល់',
//               () {},
//             ), // Upcoming Events
//             _buildEventItem(
//               month: 'តុលា',
//               day: '២៥',
//               title: 'ប្រជុំមាតាបិតា', // Parent Meeting
//               time: '០៨:០០ ព្រឹក - ១០:៣០ ព្រឹក',
//               location: 'សាលប្រជុំ (អាគារ A)',
//               color: Colors.blue.shade50,
//             ),
//             _buildEventItem(
//               month: 'តុលា',
//               day: '២៨',
//               title: 'ទស្សនកិច្ចសិក្សានៅសារមន្ទីរ', // Museum Study Tour
//               time: '០៧:៣០ ព្រឹក - ០៤:៣០ ល្ងាច',
//               location: 'សារមន្ទីរជាតិភ្នំពេញ',
//               color: Colors.green.shade50,
//             ),
//             _buildEventItem(
//               month: 'វិច្ឆិកា',
//               day: '០២',
//               title: 'ការពិនិត្យសុខភាពប្រចាំឆ្នាំ', // Annual Health Checkup
//               time: '០៨:០០ ព្រឹក - ១២:០០ ថ្ងៃត្រង់',
//               location: 'មណ្ឌលសុខភាពសាលា',
//               color: Colors.purple.shade50,
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//       bottomNavigationBar: _buildBottomNav(primaryTeal),
//     );
//   }

//   Widget _buildSectionHeader(String title, VoidCallback onSeeAll) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           TextButton(
//             onPressed: onSeeAll,
//             child: const Text(
//               'មើលទាំងអស់',
//               style: TextStyle(color: Color(0xFF007A7C)),
//             ), // See All
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNewsCard({
//     required String imageUrl,
//     required String tag,
//     required String date,
//     required String title,
//     required String desc,
//   }) {
//     return Container(
//       width: 280,
//       margin: const EdgeInsets.only(right: 15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//             child: Image.network(
//               imageUrl,
//               height: 140,
//               width: double.infinity,
//               fit: BoxFit.cover,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(15.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 8,
//                         vertical: 4,
//                       ),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFE0F2F1),
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                       child: Text(
//                         tag,
//                         style: const TextStyle(
//                           color: Color(0xFF007A7C),
//                           fontSize: 10,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Text(
//                       date,
//                       style: const TextStyle(color: Colors.grey, fontSize: 10),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14,
//                   ),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 5),
//                 Text(
//                   desc,
//                   style: const TextStyle(color: Colors.grey, fontSize: 11),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEventItem({
//     required String month,
//     required String day,
//     required String title,
//     required String time,
//     required String location,
//     required Color color,
//   }) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//       padding: const EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 60,
//             height: 60,
//             decoration: BoxDecoration(
//               color: color,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   month,
//                   style: const TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.blueGrey,
//                   ),
//                 ),
//                 Text(
//                   day,
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(width: 15),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 15,
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 Row(
//                   children: [
//                     const Icon(Icons.access_time, size: 14, color: Colors.grey),
//                     const SizedBox(width: 5),
//                     Text(
//                       time,
//                       style: const TextStyle(color: Colors.grey, fontSize: 11),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     const Icon(
//                       Icons.location_on_outlined,
//                       size: 14,
//                       color: Colors.grey,
//                     ),
//                     const SizedBox(width: 5),
//                     Text(
//                       location,
//                       style: const TextStyle(color: Colors.grey, fontSize: 11),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
//         ],
//       ),
//     );
//   }

//   Widget _buildBottomNav(Color activeColor) {
//     return BottomNavigationBar(
//       type: BottomNavigationBarType.fixed,
//       selectedItemColor: activeColor,
//       items: const [
//         BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'ទំព័រដើម'),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.star_outline),
//           label: 'ពិន្ទុ',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.calendar_month),
//           label: 'ប្រតិទិន',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.mail_outline),
//           label: 'ប្រអប់សំបុត្រ',
//         ),
//       ],
//     );
//   }
// }
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:tamdansers/Screen/Edit-Profile/student_edit_profile.dart';
import 'package:tamdansers/contants/app_text_style.dart';

class SchoolNewsEventsScreen extends StatefulWidget {
  const SchoolNewsEventsScreen({super.key});

  @override
  State<SchoolNewsEventsScreen> createState() => _SchoolNewsEventsScreenState();
}

class _SchoolNewsEventsScreenState extends State<SchoolNewsEventsScreen> {
  int _pageIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final Color primaryTeal = const Color(0xFF007A7C);

  // List of screens to navigate between
  late final List<Widget> _screens = [
    _buildNewsHomeContent(), // Index 0: News and Events
    Center(
      child: Text("ប្រតិទិន (Calendar)", style: AppTextStyle.sectionTitle20),
    ),
    Center(
      child: Text("ប្រអប់សំបុត្រ (Inbox)", style: AppTextStyle.sectionTitle20),
    ),
    const StudentEditProfileScreen(), // Index 3: Profile/Settings
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      // App bar only shows on the News Home tab
      appBar: _pageIndex == 0
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(
                'ព័ត៌មាន និងព្រឹត្តិការណ៍',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.black),
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
          Icon(Icons.newspaper, size: 30, color: Colors.white),
          Icon(Icons.calendar_month, size: 30, color: Colors.white),
          Icon(Icons.mail_outline, size: 30, color: Colors.white),
          Icon(Icons.person_outline, size: 30, color: Colors.white),
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

  // --- Sub-Screen: Main News Feed ---
  Widget _buildNewsHomeContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Featured News Section
          _buildSectionHeader('ព័ត៌មានថ្មីៗ', () {}),
          SizedBox(
            height: 280,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              children: [
                _buildNewsCard(
                  imageUrl:
                      'https://images.unsplash.com/photo-1577891776191-c692241639c0?w=500',
                  tag: 'សាលារៀន',
                  date: '២០ តុលា ២០២៣',
                  title: 'ពិធីបុណ្យអុំទូក និងការឈប់សម្រាករបស់សិស្សានុសិស្ស',
                  desc: 'សាលានឹងត្រូវឈប់សម្រាកក្នុងឱកាសបុណ្យអុំទូកខាងមុខនេះ...',
                ),
                _buildNewsCard(
                  imageUrl:
                      'https://images.unsplash.com/photo-1509062522246-3755977927d7?w=500',
                  tag: 'ការប្រកួត',
                  date: '១៨ តុលា ២០២៣',
                  title: 'លទ្ធផលនៃការប្រកួតគណិតវិទ្យាថ្នាក់ជាតិ',
                  desc: 'អបអរសាទរសិស្សានុសិស្សដែលទទួលបានជ័យលាភី...',
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Upcoming Events Section
          _buildSectionHeader('ព្រឹត្តិការណ៍ជិតមកដល់', () {}),
          _buildEventItem(
            month: 'តុលា',
            day: '២៥',
            title: 'ប្រជុំមាតាបិតា',
            time: '០៨:០០ ព្រឹក - ១០:៣០ ព្រឹក',
            location: 'សាលប្រជុំ (អាគារ A)',
            color: Colors.blue.shade50,
          ),
          _buildEventItem(
            month: 'តុលា',
            day: '២៨',
            title: 'ទស្សនកិច្ចសិក្សានៅសារមន្ទីរ',
            time: '០៧:៣០ ព្រឹក - ០៤:៣០ ល្ងាច',
            location: 'សារមន្ទីរជាតិភ្នំពេញ',
            color: Colors.green.shade50,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // --- UI Components ---

  Widget _buildSectionHeader(String title, VoidCallback onSeeAll) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: onSeeAll,
            child: const Text(
              'មើលទាំងអស់',
              style: TextStyle(color: Color(0xFF007A7C)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard({
    required String imageUrl,
    required String tag,
    required String date,
    required String title,
    required String desc,
  }) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              imageUrl,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2F1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          color: Color(0xFF007A7C),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      date,
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  desc,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventItem({
    required String month,
    required String day,
    required String title,
    required String time,
    required String location,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  month,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
                Text(
                  day,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text(
                      time,
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      location,
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
    );
  }
}
