
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:flutter/material.dart';
// import 'dart:ui';

// import 'package:tamdansers/contants/app_colors.dart';

// // Mocking AppColors for compatibility

// void main() {
//   runApp(
//     const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: StudentHomeworkScreen(),
//     ),
//   );
// }

// class StudentHomeworkScreen extends StatefulWidget {
//   const StudentHomeworkScreen({super.key});

//   @override
//   State<StudentHomeworkScreen> createState() => _StudentHomeworkScreenState();
// }

// class _StudentHomeworkScreenState extends State<StudentHomeworkScreen> {
//   int _pageIndex = 1;
//   final Color primaryTeal = const Color(0xFF007A7C);
//   final Color accentCoral = const Color(0xFFFF6B6B);
//   final Color bgSoft = const Color(0xFFF8FAFC);

//   final List<Map<String, dynamic>> _allAssignments = [
//     {
//       'id': 'khmer_1',
//       'title': 'Khmer Language',
//       'homeworkNumber': 'UNIT 04 • EXERCISE',
//       'teacher': 'Mr. Sok Chea',
//       'deadline': 'Tomorrow, 5:00 PM',
//       'imageUrl':
//           'https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?auto=format&fit=crop&q=80&w=500',
//       'isUrgent': true,
//     },
//     {
//       'id': 'math_2',
//       'title': 'Mathematics',
//       'homeworkNumber': 'ALGEBRA • HW 2',
//       'teacher': 'Ms. Nary',
//       'deadline': 'Friday, 8:00 AM',
//       'imageUrl':
//           'https://images.unsplash.com/photo-1635070041078-e363dbe005cb?auto=format&fit=crop&q=80&w=500',
//       'isUrgent': false,
//     },
//   ];

//   List<String> submittedAssignments = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: bgSoft,
//       extendBody: true,
//       body: _pageIndex == 1
//           ? _buildHomeworkMainContent()
//           : Center(child: Text("Page $_pageIndex")),
//       bottomNavigationBar: CurvedNavigationBar(
//         index: _pageIndex,
//         height: 65.0,
//         items: const <Widget>[
//           Icon(Icons.dashboard_outlined, size: 28, color: Colors.white),
//           Icon(Icons.assignment_outlined, size: 28, color: Colors.white),
//           Icon(Icons.book_outlined, size: 28, color: Colors.white),
//           Icon(Icons.person_outline, size: 28, color: Colors.white),
//         ],
//         color: primaryTeal,
//         buttonBackgroundColor: primaryTeal,
//         backgroundColor: Colors.transparent,
//         animationCurve: Curves.easeInOutCubic,
//         animationDuration: const Duration(milliseconds: 400),
//         onTap: (index) => setState(() => _pageIndex = index),
//       ),
//     );
//   }

//   Widget _buildHomeworkMainContent() {
//     return DefaultTabController(
//       length: 3,
//       child: NestedScrollView(
//         headerSliverBuilder: (context, innerBoxIsScrolled) => [
//           SliverAppBar(
//             expandedHeight: 100,
//             floating: true,
//             pinned: true,
//             elevation: 0,
//             backgroundColor: bgSoft,
//             flexibleSpace: const FlexibleSpaceBar(
//               titlePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//               centerTitle: false,
//               title: Text(
//                 'My Tasks',
//                 style: TextStyle(
//                   color: Color(0xFF1E293B),
//                   fontWeight: FontWeight.w900,
//                   fontSize: 22,
//                   letterSpacing: -0.5,
//                 ),
//               ),
//             ),
//           ),
//           SliverPersistentHeader(
//             pinned: true,
//             delegate: _SliverAppBarDelegate(
//               TabBar(
//                 isScrollable: true,
//                 indicator: BoxDecoration(
//                   borderRadius: BorderRadius.circular(15),
//                   color: primaryTeal,
//                 ),
//                 indicatorSize: TabBarIndicatorSize.tab,
//                 labelColor: Colors.white,
//                 unselectedLabelColor: AppColors.secondaryText,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 8,
//                 ),
//                 labelPadding: const EdgeInsets.symmetric(horizontal: 6),
//                 dividerColor: Colors.transparent,
//                 tabs: [
//                   _buildModernTab("All Tasks"),
//                   _buildModernTab("Pending"),
//                   _buildModernTab("Completed"),
//                 ],
//               ),
//             ),
//           ),
//         ],
//         body: TabBarView(
//           children: [
//             _buildAssignmentList(_allAssignments),
//             _buildAssignmentList(
//               _allAssignments
//                   .where((a) => !submittedAssignments.contains(a['id']))
//                   .toList(),
//             ),
//             _buildAssignmentList(
//               _allAssignments
//                   .where((a) => submittedAssignments.contains(a['id']))
//                   .toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildModernTab(String label) {
//     return Tab(
//       child: Container(
//         constraints: const BoxConstraints(minWidth: 90),
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(15),
//           color: Colors.white.withOpacity(0.5),
//         ),
//         child: Align(
//           alignment: Alignment.center,
//           child: Text(
//             label,
//             style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildAssignmentList(List<Map<String, dynamic>> assignments) {
//     if (assignments.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.assignment_turned_in_outlined,
//               size: 60,
//               color: Colors.grey[300],
//             ),
//             const SizedBox(height: 16),
//             const Text("No tasks found", style: TextStyle(color: Colors.grey)),
//           ],
//         ),
//       );
//     }
//     return ListView.builder(
//       padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
//       itemCount: assignments.length,
//       itemBuilder: (context, index) => _buildModernCard(assignments[index]),
//     );
//   }

//   Widget _buildModernCard(Map<String, dynamic> data) {
//     bool isDone = submittedAssignments.contains(data['id']);

//     return Container(
//       margin: const EdgeInsets.only(bottom: 20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(30),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 20,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Stack(
//             children: [
//               ClipRRect(
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(30),
//                 ),
//                 child: Image.network(
//                   data['imageUrl'],
//                   height: 160,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               Positioned(
//                 top: 15,
//                 right: 15,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: BackdropFilter(
//                     filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 6,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(20),
//                         border: Border.all(
//                           color: Colors.white.withOpacity(0.3),
//                         ),
//                       ),
//                       child: Text(
//                         isDone
//                             ? "✓ COMPLETED"
//                             : (data['isUrgent'] ? "🔥 URGENT" : "STABLE"),
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 10,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   data['homeworkNumber'],
//                   style: TextStyle(
//                     color: primaryTeal,
//                     letterSpacing: 1.2,
//                     fontSize: 11,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   data['title'],
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF0F172A),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 12,
//                       backgroundColor: bgSoft,
//                       child: Icon(Icons.person, size: 14, color: primaryTeal),
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       data['teacher'],
//                       style: const TextStyle(
//                         color: Color(0xFF64748B),
//                         fontSize: 13,
//                       ),
//                     ),
//                     const Spacer(),
//                     Icon(
//                       Icons.alarm,
//                       size: 16,
//                       color: isDone ? Colors.green : accentCoral,
//                     ),
//                     const SizedBox(width: 4),
//                     Text(
//                       data['deadline'],
//                       style: TextStyle(
//                         color: isDone ? Colors.green : accentCoral,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 InkWell(
//                   onTap: isDone
//                       ? null
//                       : () => _showSubmitBottomSheet(data['title'], data['id']),
//                   child: Container(
//                     height: 50,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       gradient: isDone
//                           ? null
//                           : LinearGradient(
//                               colors: [primaryTeal, const Color(0xFF00A3A5)],
//                             ),
//                       color: isDone ? bgSoft : null,
//                       borderRadius: BorderRadius.circular(18),
//                     ),
//                     child: Center(
//                       child: Text(
//                         isDone ? "Review Submission" : "Submit Assignment",
//                         style: TextStyle(
//                           color: isDone ? AppColors.slate800 : Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showSubmitBottomSheet(String title, String id) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (context) => Container(
//         height: MediaQuery.of(context).size.height * 0.4,
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
//         ),
//         padding: const EdgeInsets.all(30),
//         child: Column(
//           children: [
//             Container(
//               width: 40,
//               height: 5,
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             const SizedBox(height: 25),
//             const Text(
//               "Upload Homework",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               "Select your PDF file for $title",
//               style: const TextStyle(color: AppColors.slate500),
//             ),
//             const SizedBox(height: 25),
//             GestureDetector(
//               onTap: () {
//                 Navigator.pop(context);
//                 setState(() => submittedAssignments.add(id));
//                 _showSuccessDialog();
//               },
//               child: Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.symmetric(vertical: 20),
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     color: primaryTeal.withOpacity(0.2),
//                     width: 1.5,
//                   ),
//                   borderRadius: BorderRadius.circular(20),
//                   color: primaryTeal.withOpacity(0.04),
//                 ),
//                 child: Column(
//                   children: [
//                     Icon(
//                       Icons.cloud_upload_outlined,
//                       color: primaryTeal,
//                       size: 32,
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       "Tap to select file",
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showSuccessDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//         child: Padding(
//           padding: const EdgeInsets.all(30),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Icon(Icons.check_circle, color: Colors.green, size: 70),
//               const SizedBox(height: 20),
//               const Text(
//                 "Well Done!",
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 "Your assignment was submitted.",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(color: Colors.grey),
//               ),
//               const SizedBox(height: 25),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: primaryTeal,
//                   shape: const StadiumBorder(),
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 30,
//                     vertical: 12,
//                   ),
//                 ),
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text(
//                   "Awesome",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
//   _SliverAppBarDelegate(this._tabBar);
//   final TabBar _tabBar;
//   @override
//   double get minExtent => 60;
//   @override
//   double get maxExtent => 60;
//   @override
//   Widget build(
//     BuildContext context,
//     double shrinkOffset,
//     bool overlapsContent,
//   ) {
//     return Container(
//       color: const Color(0xFFF8FAFC),
//       alignment: Alignment.center,
//       child: _tabBar,
//     );
//   }

//   @override
//   bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
// }








// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:flutter/material.dart';
// import 'dart:ui';

// // Updated Modern Palette
// class ModernColors {
//   static const Color primaryTeal = Color(0xFF007A7C);
//   static const Color accentTeal = Color(0xFF7CB9B6); // For selected tab text
//   static const Color bgSoft = Color(0xFFF8FAFC);
//   static const Color slateText = Color(0xFF334155);
//   static const Color slateLight = Color(0xFF64748B);
//   static const Color coral = Color(0xFFFF6B6B);
// }

// void main() {
//   runApp(
//     const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: StudentHomeworkScreen(),
//     ),
//   );
// }

// class StudentHomeworkScreen extends StatefulWidget {
//   const StudentHomeworkScreen({super.key});

//   @override
//   State<StudentHomeworkScreen> createState() => _StudentHomeworkScreenState();
// }

// class _StudentHomeworkScreenState extends State<StudentHomeworkScreen> {
//   int _pageIndex = 1;
//   List<String> submittedAssignments = [];

//   final List<Map<String, dynamic>> _allAssignments = [
//     {
//       'id': 'khmer_1',
//       'title': 'Khmer Language',
//       'homeworkNumber': 'UNIT 04 • EXERCISE',
//       'teacher': 'Mr. Sok Chea',
//       'deadline': 'Tomorrow, 5:00 PM',
//       'imageUrl':
//           'https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?auto=format&fit=crop&q=80&w=500',
//       'isUrgent': true,
//     },
//     {
//       'id': 'math_2',
//       'title': 'Mathematics',
//       'homeworkNumber': 'ALGEBRA • HW 2',
//       'teacher': 'Ms. Nary',
//       'deadline': 'Friday, 8:00 AM',
//       'imageUrl':
//           'https://images.unsplash.com/photo-1635070041078-e363dbe005cb?auto=format&fit=crop&q=80&w=500',
//       'isUrgent': false,
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ModernColors.bgSoft,
//       extendBody: true,
//       body: _pageIndex == 1
//           ? _buildHomeworkMainContent()
//           : Center(child: Text("Page $_pageIndex")),
//       bottomNavigationBar: CurvedNavigationBar(
//         index: _pageIndex,
//         height: 65.0,
//         items: const <Widget>[
//           Icon(Icons.dashboard_outlined, size: 28, color: Colors.white),
//           Icon(Icons.assignment_outlined, size: 28, color: Colors.white),
//           Icon(Icons.book_outlined, size: 28, color: Colors.white),
//           Icon(Icons.person_outline, size: 28, color: Colors.white),
//         ],
//         color: ModernColors.primaryTeal,
//         buttonBackgroundColor: ModernColors.primaryTeal,
//         backgroundColor: Colors.transparent,
//         onTap: (index) => setState(() => _pageIndex = index),
//       ),
//     );
//   }

//   Widget _buildHomeworkMainContent() {
//     return DefaultTabController(
//       length: 3,
//       child: NestedScrollView(
//         headerSliverBuilder: (context, innerBoxIsScrolled) => [
//           const SliverAppBar(
//             expandedHeight: 80,
//             floating: true,
//             pinned: true,
//             elevation: 0,
//             backgroundColor: ModernColors.bgSoft,
//             flexibleSpace: FlexibleSpaceBar(
//               titlePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//               centerTitle: false,
//               title: Text(
//                 'My Tasks',
//                 style: TextStyle(
//                   color: ModernColors.slateText,
//                   fontWeight: FontWeight.w800,
//                   fontSize: 22,
//                 ),
//               ),
//             ),
//           ),
//           SliverPersistentHeader(
//             pinned: true,
//             delegate: _SliverAppBarDelegate(
//               TabBar(
//                 isScrollable: true,
//                 indicatorSize: TabBarIndicatorSize.tab,
//                 dividerColor: Colors.transparent,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 8,
//                 ),
//                 labelPadding: const EdgeInsets.symmetric(horizontal: 4),
//                 // Modern "Floating Pill" Indicator
//                 indicator: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   color: ModernColors.primaryTeal.withOpacity(0.15),
//                   border: Border.all(color: ModernColors.primaryTeal, width: 2),
//                 ),
//                 labelColor: ModernColors.primaryTeal,
//                 unselectedLabelColor: ModernColors.slateLight,
//                 tabs: [
//                   _buildModernTab("All Tasks"),
//                   _buildModernTab("Pending"),
//                   _buildModernTab("Completed"),
//                 ],
//               ),
//             ),
//           ),
//         ],
//         body: TabBarView(
//           children: [
//             _buildAssignmentList(_allAssignments),
//             _buildAssignmentList(
//               _allAssignments
//                   .where((a) => !submittedAssignments.contains(a['id']))
//                   .toList(),
//             ),
//             _buildAssignmentList(
//               _allAssignments
//                   .where((a) => submittedAssignments.contains(a['id']))
//                   .toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildModernTab(String label) {
//     return Tab(
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 24),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           color: Colors.white.withOpacity(
//             0.5,
//           ), // Clean background for unselected
//         ),
//         child: Center(
//           child: Text(
//             label,
//             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildAssignmentList(List<Map<String, dynamic>> assignments) {
//     return ListView.builder(
//       padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
//       itemCount: assignments.length,
//       itemBuilder: (context, index) => _buildModernCard(assignments[index]),
//     );
//   }

//   Widget _buildModernCard(Map<String, dynamic> data) {
//     bool isDone = submittedAssignments.contains(data['id']);
//     return Container(
//       margin: const EdgeInsets.only(bottom: 20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Stack(
//             children: [
//               ClipRRect(
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(24),
//                 ),
//                 child: Image.network(
//                   data['imageUrl'],
//                   height: 160,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               Positioned(
//                 top: 12,
//                 right: 12,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 10,
//                     vertical: 5,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.black26,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     isDone ? "DONE" : (data['isUrgent'] ? "URGENT" : "STABLE"),
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 10,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   data['homeworkNumber'],
//                   style: const TextStyle(
//                     color: ModernColors.primaryTeal,
//                     fontSize: 11,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 1.1,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   data['title'],
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: ModernColors.slateText,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   children: [
//                     const Icon(
//                       Icons.person_outline,
//                       size: 16,
//                       color: ModernColors.slateLight,
//                     ),
//                     const SizedBox(width: 4),
//                     Text(
//                       data['teacher'],
//                       style: const TextStyle(
//                         color: ModernColors.slateLight,
//                         fontSize: 13,
//                       ),
//                     ),
//                     const Spacer(),
//                     Icon(
//                       Icons.alarm,
//                       size: 16,
//                       color: isDone ? Colors.green : ModernColors.coral,
//                     ),
//                     const SizedBox(width: 4),
//                     Text(
//                       data['deadline'],
//                       style: TextStyle(
//                         color: isDone ? Colors.green : ModernColors.coral,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 SizedBox(
//                   width: double.infinity,
//                   height: 48,
//                   child: ElevatedButton(
//                     onPressed: isDone
//                         ? null
//                         : () =>
//                               _showSubmitBottomSheet(data['title'], data['id']),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: ModernColors.primaryTeal,
//                       foregroundColor: Colors.white,
//                       disabledBackgroundColor: ModernColors.bgSoft,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(14),
//                       ),
//                       elevation: 0,
//                     ),
//                     child: Text(
//                       isDone ? "Review Submission" : "Submit Assignment",
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showSubmitBottomSheet(String title, String id) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//       ),
//       builder: (context) => Container(
//         padding: const EdgeInsets.all(30),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               "Upload Homework",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             InkWell(
//               onTap: () {
//                 Navigator.pop(context);
//                 setState(() => submittedAssignments.add(id));
//                 _showSuccessDialog();
//               },
//               child: Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     color: ModernColors.primaryTeal.withOpacity(0.3),
//                   ),
//                   borderRadius: BorderRadius.circular(15),
//                   color: ModernColors.primaryTeal.withOpacity(0.05),
//                 ),
//                 child: const Column(
//                   children: [
//                     Icon(
//                       Icons.cloud_upload,
//                       color: ModernColors.primaryTeal,
//                       size: 40,
//                     ),
//                     Text("Select PDF File"),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showSuccessDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         backgroundColor: const Color(
//           0xFFF1F0F5,
//         ), // Light lavender/gray matching image
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: const BoxDecoration(
//                   color: Color(0xFF5CB85C),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(Icons.check, color: Colors.white, size: 44),
//               ),
//               const SizedBox(height: 24),
//               const Text(
//                 "Submitted Successfully!",
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF2D2D2D),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               const Text(
//                 "Your PDF has been sent\nsuccessfully.",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 16, color: Color(0xFF5A5A5A)),
//               ),
//               const SizedBox(height: 32),
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text(
//                   "Done",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF007A7C),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
//   _SliverAppBarDelegate(this._tabBar);
//   final TabBar _tabBar;
//   @override
//   double get minExtent => 64;
//   @override
//   double get maxExtent => 64;
//   @override
//   Widget build(
//     BuildContext context,
//     double shrinkOffset,
//     bool overlapsContent,
//   ) {
//     return Container(color: ModernColors.bgSoft, child: _tabBar);
//   }

//   @override
//   bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
// }
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF006D77),
          primary: const Color(0xFF006D77),
          surface: const Color(0xFFFAFCFD),
          surfaceTint: Colors.transparent,
        ),
        scaffoldBackgroundColor: const Color(0xFFFAFCFD),
        cardTheme: CardThemeData(
          // ← add "Data"
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          color: Colors.white,
        ),
      ),
      home: const StudentHomeworkScreen(),
    );
  }
}

class StudentHomeworkScreen extends StatefulWidget {
  const StudentHomeworkScreen({super.key});

  @override
  State<StudentHomeworkScreen> createState() => _StudentHomeworkScreenState();
}

class _StudentHomeworkScreenState extends State<StudentHomeworkScreen> {
  int _currentPage = 1;
  final Set<String> _completedIds = {};

  final List<Map<String, dynamic>> _assignments = [
    {
      'id': 'khmer_1',
      'subject': 'Khmer Language',
      'task': 'UNIT 04 • EXERCISE',
      'teacher': 'Mr. Sok Chea',
      'due': DateTime.now().add(const Duration(hours: 30)),
      'cover':
          'https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?auto=format&fit=crop&q=80&w=800',
      'urgent': true,
    },
    {
      'id': 'math_2',
      'subject': 'Mathematics',
      'task': 'ALGEBRA • HOMEWORK 2',
      'teacher': 'Ms. Nary',
      'due': DateTime.now().add(const Duration(days: 4)),
      'cover':
          'https://images.unsplash.com/photo-1635070041078-e363dbe005cb?auto=format&fit=crop&q=80&w=800',
      'urgent': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _currentPage == 1
          ? _buildMainContent()
          : const Center(child: Text("Other screen")),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _currentPage == 1
          ? FloatingActionButton.extended(
              heroTag: 'fab_submit',
              onPressed: () {},
              label: const Text("Quick Upload"),
              icon: const Icon(Icons.upload_file_rounded),
            )
          : null,
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentPage,
        height: 74,
        color: Theme.of(context).colorScheme.primary,
        buttonBackgroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOutCubicEmphasized,
        animationDuration: const Duration(milliseconds: 500),
        items: const <Widget>[
          Icon(Icons.dashboard_rounded, size: 28, color: Colors.white),
          Icon(Icons.assignment_rounded, size: 28, color: Colors.white),
          Icon(Icons.book_rounded, size: 28, color: Colors.white),
          Icon(Icons.person_rounded, size: 28, color: Colors.white),
        ],
        onTap: (index) => setState(() => _currentPage = index),
      ),
    );
  }

  Widget _buildMainContent() {
    return DefaultTabController(
      length: 3,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 110,
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              centerTitle: false,
              title: Text(
                "My Assignments",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _ModernTabBarDelegate(
              TabBar(
                isScrollable: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 12,
                ),
                indicatorPadding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 4,
                ),
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 4.5,
                  ),
                  insets: const EdgeInsets.symmetric(horizontal: 16),
                ),
                labelColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor: Theme.of(
                  context,
                ).colorScheme.onSurfaceVariant,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
                tabs: const [
                  Tab(text: "All"),
                  Tab(text: "Pending"),
                  Tab(text: "Submitted"),
                ],
              ),
            ),
          ),
        ],
        body: TabBarView(
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
    );
  }

  Widget _buildList(List<Map<String, dynamic>> items) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 88,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              "No assignments here",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildModernAssignmentCard(items[index]),
    );
  }

  Widget _buildModernAssignmentCard(Map<String, dynamic> hw) {
    final bool isSubmitted = _completedIds.contains(hw['id']);
    final bool isUrgent = hw['urgent'] == true;
    final dueDate = hw['due'] as DateTime;
    final daysLeft = dueDate.difference(DateTime.now()).inDays;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showDetailBottomSheet(hw),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Image.network(
                  hw['cover'],
                  height: 148,
                  width: double.infinity,
                  fit: BoxFit.cover,
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
                          ? Colors.green.withOpacity(0.9)
                          : (isUrgent
                                ? Colors.redAccent.withOpacity(0.9)
                                : Colors.black54),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      isSubmitted
                          ? "SUBMITTED"
                          : (isUrgent ? "URGENT" : "${daysLeft}d left"),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hw['subject'].toUpperCase(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    hw['task'],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      height: 1.25,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline_rounded,
                        size: 16,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        hw['teacher'],
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 16,
                        color: isSubmitted
                            ? Colors.green
                            : (daysLeft <= 2 ? Colors.redAccent : null),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat("MMM d • h:mm a").format(dueDate),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isSubmitted
                              ? Colors.green
                              : (daysLeft <= 2 ? Colors.redAccent : null),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 52,
                    width: double.infinity,
                    child: FilledButton.tonal(
                      onPressed: isSubmitted
                          ? null
                          : () => _markAsSubmitted(hw['id']),
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        isSubmitted ? "View Submission" : "Submit Assignment",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
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
        backgroundColor: Colors.green,
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text(
              "Assignment submitted successfully!",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 80),
      ),
    );
  }

  void _showDetailBottomSheet(Map<String, dynamic> hw) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.68,
        minChildSize: 0.5,
        maxChildSize: 0.96,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                hw['subject'],
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                hw['task'],
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              // You can add more details here (description, attachments, etc.)
              const SizedBox(height: 40),
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
      color: Theme.of(context).scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _ModernTabBarDelegate oldDelegate) => false;
}
