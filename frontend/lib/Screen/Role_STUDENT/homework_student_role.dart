// import 'package:flutter/material.dart';
// import 'package:flutter_bounceable/flutter_bounceable.dart';
// import 'package:tamdansers/constants/app_image.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';

// class StudentHomeworkScreen extends StatefulWidget {
//   const StudentHomeworkScreen({super.key});

//   @override
//   State<StudentHomeworkScreen> createState() => _StudentHomeworkScreenState();
// }

// class _StudentHomeworkScreenState extends State<StudentHomeworkScreen> {
//   final Set<String> _completedIds = {};

//   final List<Map<String, dynamic>> _assignments = [
//     {
//       'id': 'khmer_1',
//       'subject': 'Khmer Language',
//       'task': 'UNIT 04 • EXERCISE',
//       'teacher': 'Mr. Sok Chea',
//       'due': DateTime.now().add(const Duration(hours: 30)),
//       'cover': AppImages.event1,
//       'urgent': true,
//       'color': const Color(0xFFFFB75E),
//       'icon': Icons.menu_book_rounded,
//     },
//     {
//       'id': 'math_2',
//       'subject': 'Mathematics',
//       'task': 'ALGEBRA • HOMEWORK 2',
//       'teacher': 'Ms. Nary',
//       'due': DateTime.now().add(const Duration(days: 4)),
//       'cover': AppImages.event2,
//       'urgent': false,
//       'color': const Color(0xFF4A90E2),
//       'icon': Icons.calculate_rounded,
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF3F6F8),
//       body: DefaultTabController(
//         length: 3,
//         child: NestedScrollView(
//           physics: const BouncingScrollPhysics(),
//           headerSliverBuilder: (context, innerBoxIsScrolled) => [
//             SliverAppBar(
//               expandedHeight: 120.0,
//               floating: true,
//               pinned: true,
//               elevation: 0,
//               backgroundColor: const Color(0xFFF3F6F8),
//               leading: IconButton(
//                 icon: const Icon(
//                   Icons.arrow_back_ios_new_rounded,
//                   color: Color(0xFF0D3B66),
//                   size: 20,
//                 ),
//                 onPressed: () => Navigator.pop(context),
//               ),
//               flexibleSpace: FlexibleSpaceBar(
//                 titlePadding: const EdgeInsets.symmetric(
//                   horizontal: 24,
//                   vertical: 16,
//                 ),
//                 title: Text(
//                   'My Assignments',
//                   style: GoogleFonts.outfit(
//                     color: const Color(0xFF0D3B66),
//                     fontWeight: FontWeight.bold,
//                     fontSize: 24,
//                   ),
//                 ),
//               ),
//             ),
//             SliverPersistentHeader(
//               pinned: true,
//               delegate: _ModernTabBarDelegate(
//                 TabBar(
//                   isScrollable: true,
//                   indicatorSize: TabBarIndicatorSize.tab,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 8,
//                   ),
//                   indicatorPadding: EdgeInsets.zero,
//                   indicator: BoxDecoration(
//                     color: const Color(0xFF0D3B66),
//                     borderRadius: BorderRadius.circular(25),
//                   ),
//                   labelColor: Colors.white,
//                   unselectedLabelColor: Colors.grey.shade500,
//                   labelStyle: GoogleFonts.inter(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14,
//                   ),
//                   unselectedLabelStyle: GoogleFonts.inter(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 14,
//                   ),
//                   dividerColor: Colors.transparent,
//                   tabs: const [
//                     Tab(text: "All Tasks"),
//                     Tab(text: "Pending"),
//                     Tab(text: "Submitted"),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//           body: TabBarView(
//             physics: const BouncingScrollPhysics(),
//             children: [
//               _buildList(_assignments),
//               _buildList(
//                 _assignments
//                     .where((e) => !_completedIds.contains(e['id']))
//                     .toList(),
//               ),
//               _buildList(
//                 _assignments
//                     .where((e) => _completedIds.contains(e['id']))
//                     .toList(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildList(List<Map<String, dynamic>> items) {
//     if (items.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withValues(alpha: 0.04),
//                     blurRadius: 20,
//                     offset: const Offset(0, 10),
//                   ),
//                 ],
//               ),
//               child: Icon(
//                 Icons.assignment_turned_in_rounded,
//                 size: 60,
//                 color: Colors.grey.shade300,
//               ),
//             ),
//             const SizedBox(height: 24),
//             Text(
//               "No assignments found",
//               style: GoogleFonts.outfit(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey.shade600,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               "You're all caught up!",
//               style: GoogleFonts.inter(
//                 color: Colors.grey.shade400,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
//       physics: const BouncingScrollPhysics(),
//       itemCount: items.length,
//       itemBuilder: (context, index) => _buildModernAssignmentCard(items[index]),
//     );
//   }

//   Widget _buildModernAssignmentCard(Map<String, dynamic> hw) {
//     final bool isSubmitted = _completedIds.contains(hw['id']);
//     final bool isUrgent = hw['urgent'] == true;
//     final dueDate = hw['due'] as DateTime;
//     final daysLeft = dueDate.difference(DateTime.now()).inDays;
//     final Color themeColor = hw['color'];

//     return Bounceable(
//       onTap: () => _showDetailBottomSheet(hw),
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 20),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(24),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withValues(alpha: 0.03),
//               blurRadius: 20,
//               offset: const Offset(0, 10),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius: const BorderRadius.vertical(
//                     top: Radius.circular(24),
//                   ),
//                   child: Image.asset(
//                     hw['cover'],
//                     height: 150,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 Positioned(
//                   top: 16,
//                   right: 16,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 14,
//                       vertical: 8,
//                     ),
//                     decoration: BoxDecoration(
//                       color: isSubmitted
//                           ? const Color(0xFF50E3C2).withValues(alpha: 0.9)
//                           : (isUrgent
//                                 ? const Color(0xFFFF6B6B).withValues(alpha: 0.9)
//                                 : Colors.black.withValues(alpha: 0.6)),
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withValues(alpha: 0.1),
//                           blurRadius: 10,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: Text(
//                       isSubmitted
//                           ? "SUBMITTED"
//                           : (isUrgent ? "URGENT" : "${daysLeft}d left"),
//                       style: GoogleFonts.inter(
//                         color: Colors.white,
//                         fontSize: 11,
//                         fontWeight: FontWeight.bold,
//                         letterSpacing: 0.5,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: -1,
//                   left: 0,
//                   right: 0,
//                   child: Container(
//                     height: 24,
//                     decoration: const BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.vertical(
//                         top: Radius.circular(24),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 0,
//                   left: 20,
//                   child: Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: themeColor,
//                       shape: BoxShape.circle,
//                       border: Border.all(color: Colors.white, width: 4),
//                       boxShadow: [
//                         BoxShadow(
//                           color: themeColor.withValues(alpha: 0.4),
//                           blurRadius: 10,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: Icon(hw['icon'], color: Colors.white, size: 24),
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     hw['subject'].toUpperCase(),
//                     style: GoogleFonts.inter(
//                       color: themeColor,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 12,
//                       letterSpacing: 1.2,
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     hw['task'],
//                     style: GoogleFonts.outfit(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: const Color(0xFF0D3B66),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFF3F6F8),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: const Icon(
//                           Icons.person_rounded,
//                           size: 16,
//                           color: Color(0xFF0D3B66),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Text(
//                         hw['teacher'],
//                         style: GoogleFonts.inter(
//                           color: Colors.grey.shade600,
//                           fontWeight: FontWeight.w500,
//                           fontSize: 14,
//                         ),
//                       ),
//                       const Spacer(),
//                       Icon(
//                         Icons.calendar_today_rounded,
//                         size: 16,
//                         color: isSubmitted
//                             ? const Color(0xFF50E3C2)
//                             : (isUrgent
//                                   ? const Color(0xFFFF6B6B)
//                                   : Colors.grey.shade500),
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         DateFormat("MMM d • h:mm a").format(dueDate),
//                         style: GoogleFonts.inter(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 13,
//                           color: isSubmitted
//                               ? const Color(0xFF50E3C2)
//                               : (isUrgent
//                                     ? const Color(0xFFFF6B6B)
//                                     : Colors.grey.shade600),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 24),
//                   Bounceable(
//                     onTap: isSubmitted
//                         ? null
//                         : () => _showDetailBottomSheet(hw),
//                     child: Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       decoration: BoxDecoration(
//                         color: isSubmitted
//                             ? const Color(0xFFF3F6F8)
//                             : const Color(0xFF0D3B66),
//                         borderRadius: BorderRadius.circular(16),
//                         boxShadow: isSubmitted
//                             ? []
//                             : [
//                                 BoxShadow(
//                                   color: const Color(
//                                     0xFF0D3B66,
//                                   ).withValues(alpha: 0.3),
//                                   blurRadius: 15,
//                                   offset: const Offset(0, 8),
//                                 ),
//                               ],
//                       ),
//                       child: Center(
//                         child: Text(
//                           isSubmitted
//                               ? "Review Submission"
//                               : "Submit Assignment",
//                           style: GoogleFonts.inter(
//                             color: isSubmitted
//                                 ? Colors.grey.shade600
//                                 : Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 15,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _markAsSubmitted(String id) {
//     setState(() => _completedIds.add(id));
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         backgroundColor: Colors.white,
//         elevation: 10,
//         content: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF50E3C2).withValues(alpha: 0.2),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.check_circle_rounded,
//                 color: Color(0xFF50E3C2),
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Text(
//                 "Assignment submitted successfully!",
//                 style: GoogleFonts.inter(
//                   color: const Color(0xFF0D3B66),
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         duration: const Duration(seconds: 4),
//         margin: const EdgeInsets.fromLTRB(24, 0, 24, 40),
//       ),
//     );
//   }

//   void _showDetailBottomSheet(Map<String, dynamic> hw) {
//     final bool isSubmitted = _completedIds.contains(hw['id']);
//     final Color themeColor = hw['color'];

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         height: MediaQuery.of(context).size.height * 0.85,
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
//         ),
//         child: Column(
//           children: [
//             const SizedBox(height: 16),
//             Container(
//               width: 50,
//               height: 5,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade300,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             Expanded(
//               child: ListView(
//                 padding: const EdgeInsets.all(24),
//                 physics: const BouncingScrollPhysics(),
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: themeColor.withValues(alpha: 0.15),
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         child: Icon(hw['icon'], color: themeColor, size: 28),
//                       ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               hw['subject'].toUpperCase(),
//                               style: GoogleFonts.inter(
//                                 color: themeColor,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 13,
//                                 letterSpacing: 1.2,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               hw['task'],
//                               style: GoogleFonts.outfit(
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.bold,
//                                 color: const Color(0xFF0D3B66),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 30),
//                   Text(
//                     "Instructions",
//                     style: GoogleFonts.outfit(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: const Color(0xFF0D3B66),
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   Text(
//                     "Please complete all exercises on pages 45-48. Show your work for full credit. Submit your assignment as a single PDF document.",
//                     style: GoogleFonts.inter(
//                       color: Colors.grey.shade600,
//                       height: 1.5,
//                       fontSize: 15,
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   if (!isSubmitted) ...[
//                     Text(
//                       "Upload Work",
//                       style: GoogleFonts.outfit(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: const Color(0xFF0D3B66),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Bounceable(
//                       onTap: () {
//                         Navigator.pop(context);
//                         _markAsSubmitted(hw['id']);
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(vertical: 30),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFF3F6F8),
//                           borderRadius: BorderRadius.circular(24),
//                           border: Border.all(
//                             color: Colors.grey.shade300,
//                             width: 2,
//                             style: BorderStyle.none,
//                           ),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(12),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 shape: BoxShape.circle,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withValues(alpha: 0.05),
//                                     blurRadius: 10,
//                                     offset: const Offset(0, 4),
//                                   ),
//                                 ],
//                               ),
//                               child: const Icon(
//                                 Icons.cloud_upload_rounded,
//                                 color: Color(0xFF0D3B66),
//                                 size: 28,
//                               ),
//                             ),
//                             const SizedBox(width: 16),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "Tap to select file",
//                                   style: GoogleFonts.inter(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                     color: const Color(0xFF0D3B66),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   "PDF, DOC, or image files",
//                                   style: GoogleFonts.inter(
//                                     color: Colors.grey.shade500,
//                                     fontSize: 13,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ] else ...[
//                     Container(
//                       padding: const EdgeInsets.all(24),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF50E3C2).withValues(alpha: 0.1),
//                         borderRadius: BorderRadius.circular(24),
//                         border: Border.all(
//                           color: const Color(0xFF50E3C2).withValues(alpha: 0.3),
//                         ),
//                       ),
//                       child: Column(
//                         children: [
//                           const Icon(
//                             Icons.check_circle_rounded,
//                             color: Color(0xFF50E3C2),
//                             size: 48,
//                           ),
//                           const SizedBox(height: 12),
//                           Text(
//                             "Successfully Submitted",
//                             style: GoogleFonts.outfit(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 18,
//                               color: const Color(0xFF0D3B66),
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             "Your assignment was submitted on time and is pending review.",
//                             textAlign: TextAlign.center,
//                             style: GoogleFonts.inter(
//                               color: Colors.grey.shade600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _ModernTabBarDelegate extends SliverPersistentHeaderDelegate {
//   final TabBar tabBar;

//   _ModernTabBarDelegate(this.tabBar);

//   @override
//   double get minExtent => 70;
//   @override
//   double get maxExtent => 70;

//   @override
//   Widget build(
//     BuildContext context,
//     double shrinkOffset,
//     bool overlapsContent,
//   ) {
//     return Container(
//       color: const Color(0xFFF3F6F8),
//       alignment: Alignment.center,
//       child: tabBar,
//     );
//   }

//   @override
//   bool shouldRebuild(covariant _ModernTabBarDelegate oldDelegate) => false;
// }
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:tamdansers/constants/app_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class StudentHomeworkScreen extends StatefulWidget {
  const StudentHomeworkScreen({super.key});

  @override
  State<StudentHomeworkScreen> createState() => _StudentHomeworkScreenState();
}

class _StudentHomeworkScreenState extends State<StudentHomeworkScreen> {
  final Set<String> _completedIds = {};

  final List<Map<String, dynamic>> _assignments = [
    {
      'id': 'khmer_1',
      'subject': 'Khmer Language',
      'task': 'UNIT 04 • EXERCISE',
      'teacher': 'Mr. Sok Chea',
      'due': DateTime.now().add(const Duration(hours: 30)),
      'cover': AppImages.event1,
      'urgent': true,
      'color': const Color(0xFFFFB75E),
      'icon': Icons.menu_book_rounded,
    },
    {
      'id': 'math_2',
      'subject': 'Mathematics',
      'task': 'ALGEBRA • HOMEWORK 2',
      'teacher': 'Ms. Nary',
      'due': DateTime.now().add(const Duration(days: 4)),
      'cover': AppImages.event2,
      'urgent': false,
      'color': const Color(0xFF4A90E2),
      'icon': Icons.calculate_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F8),
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          physics: const BouncingScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              expandedHeight: 120.0,
              floating: true,
              pinned: true,
              elevation: 0,
              backgroundColor: const Color(0xFFF3F6F8),
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Color(0xFF0D3B66),
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                title: Text(
                  'My Assignments',
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF0D3B66),
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _ModernTabBarDelegate(
                TabBar(
                  isScrollable: true,
                  indicatorSize: TabBarIndicatorSize.tab,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  indicatorPadding: EdgeInsets.zero,
                  indicator: BoxDecoration(
                    color: const Color(0xFF0D3B66),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey.shade500,
                  labelStyle: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  unselectedLabelStyle: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: "All Tasks"),
                    Tab(text: "Pending"),
                    Tab(text: "Submitted"),
                  ],
                ),
              ),
            ),
          ],
          body: TabBarView(
            physics: const BouncingScrollPhysics(),
            children: [
              _buildList(_assignments),
              _buildList(
                _assignments
                    .where((e) => !_completedIds.contains(e['id']))
                    .toList(),
              ),
              _buildList(
                _assignments
                    .where((e) => _completedIds.contains(e['id']))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList(List<Map<String, dynamic>> items) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                Icons.assignment_turned_in_rounded,
                size: 60,
                color: Colors.grey.shade300,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "No assignments found",
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "You're all caught up!",
              style: GoogleFonts.inter(
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 80),
      physics: const BouncingScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildModernAssignmentCard(items[index]),
    );
  }

  Widget _buildModernAssignmentCard(Map<String, dynamic> hw) {
    final bool isSubmitted = _completedIds.contains(hw['id']);
    final bool isUrgent = hw['urgent'] == true;
    final dueDate = hw['due'] as DateTime;
    final daysLeft = dueDate.difference(DateTime.now()).inDays;
    final Color themeColor = hw['color'];

    return Bounceable(
      onTap: () => _showDetailBottomSheet(hw),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: Image.asset(
                    hw['cover'],
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSubmitted
                          ? const Color(0xFF50E3C2).withValues(alpha: 0.9)
                          : (isUrgent
                                ? const Color(0xFFFF6B6B).withValues(alpha: 0.9)
                                : Colors.black.withValues(alpha: 0.65)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isSubmitted
                          ? "SUBMITTED"
                          : (isUrgent ? "URGENT" : "${daysLeft}d left"),
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 20,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: themeColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3.5),
                      boxShadow: [
                        BoxShadow(
                          color: themeColor.withValues(alpha: 0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(hw['icon'], color: Colors.white, size: 22),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hw['subject'].toUpperCase(),
                    style: GoogleFonts.inter(
                      color: themeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 11.5,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hw['task'],
                    style: GoogleFonts.outfit(
                      fontSize: 18.5,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D3B66),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F6F8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          size: 15,
                          color: Color(0xFF0D3B66),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        hw['teacher'],
                        style: GoogleFonts.inter(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                          fontSize: 13.5,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 15,
                        color: isSubmitted
                            ? const Color(0xFF50E3C2)
                            : (isUrgent
                                  ? const Color(0xFFFF6B6B)
                                  : Colors.grey.shade600),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat("MMM d • h:mm a").format(dueDate),
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: isSubmitted
                              ? const Color(0xFF50E3C2)
                              : (isUrgent
                                    ? const Color(0xFFFF6B6B)
                                    : Colors.grey.shade700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Bounceable(
                    onTap: isSubmitted
                        ? null
                        : () => _showDetailBottomSheet(hw),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: isSubmitted
                            ? const Color(0xFFF3F6F8)
                            : const Color(0xFF0D3B66),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: isSubmitted
                            ? []
                            : [
                                BoxShadow(
                                  color: const Color(
                                    0xFF0D3B66,
                                  ).withValues(alpha: 0.28),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                      ),
                      child: Center(
                        child: Text(
                          isSubmitted
                              ? "Review Submission"
                              : "Submit Assignment",
                          style: GoogleFonts.inter(
                            color: isSubmitted
                                ? Colors.grey.shade700
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _markAsSubmitted(String id) {
    setState(() => _completedIds.add(id));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        elevation: 8,
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: const Color(0xFF50E3C2).withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF50E3C2),
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                "Assignment submitted successfully!",
                style: GoogleFonts.inter(
                  color: const Color(0xFF0D3B66),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3, milliseconds: 800),
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      ),
    );
  }

  void _showDetailBottomSheet(Map<String, dynamic> hw) {
    final bool isSubmitted = _completedIds.contains(hw['id']);
    final Color themeColor = hw['color'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SafeArea(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.90,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: themeColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              hw['icon'],
                              color: themeColor,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  hw['subject'].toUpperCase(),
                                  style: GoogleFonts.inter(
                                    color: themeColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.5,
                                    letterSpacing: 1.1,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  hw['task'],
                                  style: GoogleFonts.outfit(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF0D3B66),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Instructions",
                        style: GoogleFonts.outfit(
                          fontSize: 16.5,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0D3B66),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Please complete all exercises on pages 45-48. Show your work for full credit. Submit your assignment as a single PDF document.",
                        style: GoogleFonts.inter(
                          color: Colors.grey.shade700,
                          height: 1.45,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (!isSubmitted) ...[
                        Text(
                          "Upload Work",
                          style: GoogleFonts.outfit(
                            fontSize: 16.5,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0D3B66),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Bounceable(
                          onTap: () {
                            Navigator.pop(context);
                            _markAsSubmitted(hw['id']);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F6F8),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1.2,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.05),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.cloud_upload_rounded,
                                    color: Color(0xFF0D3B66),
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Tap to select file",
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.5,
                                        color: const Color(0xFF0D3B66),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "PDF, DOC, image files",
                                      style: GoogleFonts.inter(
                                        color: Colors.grey.shade500,
                                        fontSize: 12.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ] else ...[
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF50E3C2).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: const Color(0xFF50E3C2).withValues(alpha: 0.25),
                            ),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.check_circle_rounded,
                                color: Color(0xFF50E3C2),
                                size: 44,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Successfully Submitted",
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: const Color(0xFF0D3B66),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Your assignment was submitted on time and is pending review.",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  color: Colors.grey.shade700,
                                  fontSize: 13.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModernTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _ModernTabBarDelegate(this.tabBar);

  @override
  double get minExtent => 68;

  @override
  double get maxExtent => 68;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: const Color(0xFFF3F6F8),
      alignment: Alignment.center,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _ModernTabBarDelegate oldDelegate) => false;
}
