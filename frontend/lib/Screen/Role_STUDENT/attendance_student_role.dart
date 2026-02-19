// // import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart';
// // import 'package:table_calendar/table_calendar.dart';
// // import 'package:fl_chart/fl_chart.dart';

// // void main() {
// //   runApp(
// //     const MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       home: AttendanceDashboard(),
// //     ),
// //   );
// // }

// // class AttendanceDashboard extends StatefulWidget {
// //   const AttendanceDashboard({super.key});

// //   @override
// //   State<AttendanceDashboard> createState() => _AttendanceDashboardState();
// // }

// // class _AttendanceDashboardState extends State<AttendanceDashboard> {
// //   int _pageIndex = 0;
// //   final Color tealTheme = const Color(0xFF0D7C7A);
// //   final Color scaffoldBg = const Color(0xFFFBFDFF);

// //   // State for Calendar
// //   DateTime _focusedDay = DateTime(2024, 4, 1);
// //   DateTime? _selectedDay;
// //   final ScrollController _scrollController = ScrollController();

// //   final List<Map<String, dynamic>> subjectsData = [
// //     {
// //       "name": "Khmer",
// //       "progress": 0.98,
// //       "color": Colors.teal,
// //       "absent": 1,
// //       "present": 45,
// //       "late": 2,
// //       "permission": 1,
// //       "total": 49,
// //     },
// //     {
// //       "name": "Math",
// //       "progress": 0.85,
// //       "color": Colors.orange,
// //       "absent": 4,
// //       "present": 40,
// //       "late": 3,
// //       "permission": 0,
// //       "total": 47,
// //     },
// //     {
// //       "name": "Physics",
// //       "progress": 0.92,
// //       "color": Colors.blue,
// //       "absent": 2,
// //       "present": 42,
// //       "late": 1,
// //       "permission": 2,
// //       "total": 47,
// //     },
// //     {
// //       "name": "Chemistry",
// //       "progress": 0.78,
// //       "color": Colors.purple,
// //       "absent": 6,
// //       "present": 38,
// //       "late": 4,
// //       "permission": 1,
// //       "total": 49,
// //     },
// //     {
// //       "name": "Biology",
// //       "progress": 0.95,
// //       "color": Colors.green,
// //       "absent": 1,
// //       "present": 44,
// //       "late": 0,
// //       "permission": 3,
// //       "total": 48,
// //     },
// //     {
// //       "name": "History",
// //       "progress": 0.95,
// //       "color": Colors.brown,
// //       "absent": 1,
// //       "present": 40,
// //       "late": 1,
// //       "permission": 2,
// //       "total": 44,
// //     },
// //     {
// //       "name": "English",
// //       "progress": 0.88,
// //       "color": Colors.pink,
// //       "absent": 3,
// //       "present": 39,
// //       "late": 2,
// //       "permission": 1,
// //       "total": 45,
// //     },
// //   ];

// //   final Map<DateTime, String> _attendanceRecords = {
// //     DateTime(2024, 4, 1): 'Present',
// //     DateTime(2024, 4, 2): 'Late',
// //     DateTime(2024, 4, 3): 'Absent',
// //     DateTime(2024, 4, 4): 'Permission',
// //     DateTime(2024, 4, 8): 'Present',
// //     DateTime(2024, 4, 10): 'Late',
// //   };

// //   late final List<Widget> _screens = [
// //     _buildAttendanceHome(),
// //     const Center(child: Text("Library")),
// //     const Center(child: Text("Messages")),
// //     const Center(child: Text("Profile Settings")),
// //   ];

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: scaffoldBg,
// //       appBar: _pageIndex == 0
// //           ? AppBar(
// //               backgroundColor: scaffoldBg,
// //               elevation: 0,
// //               title: const Text(
// //                 'My Attendance',
// //                 style: TextStyle(
// //                   color: Colors.black,
// //                   fontWeight: FontWeight.w800,
// //                 ),
// //               ),
// //               centerTitle: true,
// //             )
// //           : null,
// //       body: IndexedStack(index: _pageIndex, children: _screens),
// //       bottomNavigationBar: CurvedNavigationBar(
// //         index: _pageIndex,
// //         height: 65.0,
// //         items: const [
// //           Icon(Icons.dashboard_rounded, size: 28, color: Colors.white),
// //           Icon(Icons.book_rounded, size: 28, color: Colors.white),
// //           Icon(
// //             Icons.chat_bubble_outline_rounded,
// //             size: 28,
// //             color: Colors.white,
// //           ),
// //           Icon(Icons.person_outline_rounded, size: 28, color: Colors.white),
// //         ],
// //         color: tealTheme,
// //         buttonBackgroundColor: tealTheme,
// //         backgroundColor: Colors.transparent,
// //         onTap: (index) => setState(() => _pageIndex = index),
// //       ),
// //     );
// //   }

// //   Widget _buildAttendanceHome() {
// //     return SingleChildScrollView(
// //       controller: _scrollController,
// //       physics: const BouncingScrollPhysics(),
// //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           _buildSummaryCard(tealTheme),
// //           const SizedBox(height: 25),
// //           _buildSectionHeader("Performance Graph", "Overview"
// //           onTrailingTap: () {
// //           Navigator.push(
// //           context,
// //           MaterialPageRoute(
// //           builder: (context) => AttendanceDetailPage(
// //           subjects: subjectsData,
// //           themeColor: tealTheme,
// //           ),
// //       ),
// //       );
// //       },),
// //           const SizedBox(height: 15),
// //           _buildBarChart(),
// //           const SizedBox(height: 30),
// //           _buildSectionHeader(
// //             "Academic Calendar",
// //             DateFormat('MMMM yyyy').format(_focusedDay),
// //             onTrailingTap: () => _selectCalendarDate(context),
// //           ),
// //           const SizedBox(height: 15),
// //           _buildInteractiveCalendar(),
// //           const SizedBox(height: 30),
// //           _buildSectionHeader(
// //             "Subject Progress",
// //             "See All",
// //             onTrailingTap: () {
// //               Navigator.push(
// //                 context,
// //                 MaterialPageRoute(
// //                   builder: (context) => SubjectListPage(
// //                     subjects: subjectsData,
// //                     themeColor: tealTheme,
// //                   ),
// //                 ),
// //               );
// //             },
// //           ),
// //           const SizedBox(height: 15),
// //           _buildHorizontalSubjectProgress(),
// //           const SizedBox(height: 20),
// //         ],
// //       ),
// //     );
// //   }

// //   // --- INTERACTIVE GRAPH WITH HOVER ---
// //   Widget _buildBarChart() {
// //     return Container(
// //       height: 250,
// //       padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(24),
// //         boxShadow: [
// //           BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
// //         ],
// //       ),
// //       child: BarChart(
// //         BarChartData(
// //           alignment: BarChartAlignment.spaceAround,
// //           maxY: 1.0,
// //           barTouchData: BarTouchData(
// //             touchTooltipData: BarTouchTooltipData(
// //               getTooltipColor: (group) => Colors.blueGrey.withOpacity(0.9),
// //               getTooltipItem: (group, groupIndex, rod, rodIndex) {
// //                 final sub = subjectsData[groupIndex];
// //                 return BarTooltipItem(
// //                   "${sub['name']}\n",
// //                   const TextStyle(
// //                     color: Colors.white,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                   children: [
// //                     TextSpan(
// //                       text: "Present: ${sub['present']}\n",
// //                       style: const TextStyle(
// //                         color: Colors.greenAccent,
// //                         fontSize: 12,
// //                       ),
// //                     ),
// //                     TextSpan(
// //                       text: "Late: ${sub['late']}\n",
// //                       style: const TextStyle(
// //                         color: Colors.orangeAccent,
// //                         fontSize: 12,
// //                       ),
// //                     ),
// //                     TextSpan(
// //                       text: "Permission: ${sub['permission']}\n",
// //                       style: const TextStyle(
// //                         color: Colors.lightBlueAccent,
// //                         fontSize: 12,
// //                       ),
// //                     ),
// //                     TextSpan(
// //                       text: "Absent: ${sub['absent']}",
// //                       style: const TextStyle(
// //                         color: Colors.redAccent,
// //                         fontSize: 12,
// //                       ),
// //                     ),
// //                   ],
// //                 );
// //               },
// //             ),
// //           ),
// //           titlesData: FlTitlesData(
// //             show: true,
// //             bottomTitles: AxisTitles(
// //               sideTitles: SideTitles(
// //                 showTitles: true,
// //                 getTitlesWidget: (value, meta) {
// //                   int idx = value.toInt();
// //                   if (idx >= subjectsData.length) return const SizedBox();
// //                   return Padding(
// //                     padding: const EdgeInsets.only(top: 8.0),
// //                     child: Text(
// //                       subjectsData[idx]["name"].substring(0, 3),
// //                       style: const TextStyle(
// //                         fontSize: 10,
// //                         color: Colors.grey,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                   );
// //                 },
// //               ),
// //             ),
// //             leftTitles: const AxisTitles(
// //               sideTitles: SideTitles(showTitles: false),
// //             ),
// //             topTitles: const AxisTitles(
// //               sideTitles: SideTitles(showTitles: false),
// //             ),
// //             rightTitles: const AxisTitles(
// //               sideTitles: SideTitles(showTitles: false),
// //             ),
// //           ),
// //           gridData: const FlGridData(show: false),
// //           borderData: FlBorderData(show: false),
// //           barGroups: subjectsData.asMap().entries.map((entry) {
// //             return BarChartGroupData(
// //               x: entry.key,
// //               barRods: [
// //                 BarChartRodData(
// //                   toY: entry.value["progress"],
// //                   color: entry.value["color"],
// //                   width: 16,
// //                   borderRadius: const BorderRadius.vertical(
// //                     top: Radius.circular(6),
// //                   ),
// //                   backDrawRodData: BackgroundBarChartRodData(
// //                     show: true,
// //                     toY: 1.0,
// //                     color: Colors.grey[100],
// //                   ),
// //                 ),
// //               ],
// //             );
// //           }).toList(),
// //         ),
// //       ),
// //     );
// //   }

// //   // --- CALENDAR WITH LEGEND AND DATE PICKER ---
// //   Future<void> _selectCalendarDate(BuildContext context) async {
// //     final DateTime? picked = await showDatePicker(
// //       context: context,
// //       initialDate: _focusedDay,
// //       firstDate: DateTime(2020),
// //       lastDate: DateTime(2030),
// //       initialDatePickerMode: DatePickerMode.year,
// //     );
// //     if (picked != null && picked != _focusedDay) {
// //       setState(() {
// //         _focusedDay = picked;
// //       });
// //     }
// //   }

// //   Widget _buildInteractiveCalendar() {
// //     return Container(
// //       padding: const EdgeInsets.all(12),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(24),
// //         boxShadow: [
// //           BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
// //         ],
// //       ),
// //       child: Column(
// //         children: [
// //           TableCalendar(
// //             firstDay: DateTime.utc(2020, 1, 1),
// //             lastDay: DateTime.utc(2030, 12, 31),
// //             focusedDay: _focusedDay,
// //             selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
// //             headerStyle: const HeaderStyle(
// //               formatButtonVisible: false,
// //               titleCentered: true,
// //             ),
// //             onDaySelected: (selectedDay, focusedDay) {
// //               setState(() {
// //                 _selectedDay = selectedDay;
// //                 _focusedDay = focusedDay;
// //               });
// //               _showAttendanceStatus(selectedDay);
// //             },
// //             calendarBuilders: CalendarBuilders(
// //               defaultBuilder: (context, day, focusedDay) {
// //                 final date = DateTime(day.year, day.month, day.day);
// //                 if (_attendanceRecords.containsKey(date)) {
// //                   String status = _attendanceRecords[date]!;
// //                   return Center(
// //                     child: Container(
// //                       width: 35,
// //                       height: 35,
// //                       decoration: BoxDecoration(
// //                         color: _getStatusColor(status).withOpacity(0.2),
// //                         shape: BoxShape.circle,
// //                         border: Border.all(
// //                           color: _getStatusColor(status),
// //                           width: 1,
// //                         ),
// //                       ),
// //                       child: Center(
// //                         child: Text(
// //                           '${day.day}',
// //                           style: TextStyle(
// //                             color: _getStatusColor(status),
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   );
// //                 }
// //                 return null;
// //               },
// //             ),
// //           ),
// //           const Divider(height: 30),
// //           _buildCalendarLegend(),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildCalendarLegend() {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.spaceAround,
// //       children: [
// //         _legendItem("Present", Colors.green),
// //         _legendItem("Late", Colors.orange),
// //         _legendItem("Permission", Colors.blue),
// //         _legendItem("Absent", Colors.red),
// //       ],
// //     );
// //   }

// //   Widget _legendItem(String label, Color color) {
// //     return Row(
// //       children: [
// //         Container(
// //           width: 8,
// //           height: 8,
// //           decoration: BoxDecoration(color: color, shape: BoxShape.circle),
// //         ),
// //         const SizedBox(width: 5),
// //         Text(
// //           label,
// //           style: const TextStyle(
// //             fontSize: 10,
// //             color: Colors.grey,
// //             fontWeight: FontWeight.bold,
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Color _getStatusColor(String status) {
// //     switch (status) {
// //       case 'Present':
// //         return Colors.green;
// //       case 'Absent':
// //         return Colors.red;
// //       case 'Late':
// //         return Colors.orange;
// //       case 'Permission':
// //         return Colors.blue;
// //       default:
// //         return Colors.grey;
// //     }
// //   }

// //   void _showAttendanceStatus(DateTime date) {
// //     final status =
// //         _attendanceRecords[DateTime(date.year, date.month, date.day)] ??
// //         "No Record";
// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// //         title: Text(DateFormat('EEEE, MMM d').format(date)),
// //         content: Text(
// //           "Status: $status",
// //           style: TextStyle(
// //             fontWeight: FontWeight.bold,
// //             color: _getStatusColor(status),
// //           ),
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: const Text("Close"),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // --- EXISTING HELPERS ---
// //   Widget _buildSummaryCard(Color color) {
// //     return Container(
// //       height: 150,
// //       decoration: BoxDecoration(
// //         borderRadius: BorderRadius.circular(32),
// //         gradient: LinearGradient(colors: [color, color.withBlue(140)]),
// //       ),
// //       child: Padding(
// //         padding: const EdgeInsets.all(24),
// //         child: Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //           children: [
// //             const Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Text(
// //                   "AVERAGE ATTENDANCE",
// //                   style: TextStyle(
// //                     color: Colors.white70,
// //                     fontSize: 11,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //                 SizedBox(height: 8),
// //                 Text(
// //                   "Keep it up,\nSophal!",
// //                   style: TextStyle(
// //                     color: Colors.white,
// //                     fontSize: 22,
// //                     fontWeight: FontWeight.w900,
// //                     height: 1.1,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             GestureDetector(
// //               onTap: () => _scrollController.animateTo(
// //                 180,
// //                 duration: const Duration(milliseconds: 600),
// //                 curve: Curves.easeInOut,
// //               ),
// //               child: Stack(
// //                 alignment: Alignment.center,
// //                 children: [
// //                   const SizedBox(
// //                     width: 70,
// //                     height: 70,
// //                     child: CircularProgressIndicator(
// //                       value: 0.95,
// //                       strokeWidth: 8,
// //                       backgroundColor: Colors.white12,
// //                       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
// //                     ),
// //                   ),
// //                   const Text(
// //                     "95%",
// //                     style: TextStyle(
// //                       color: Colors.white,
// //                       fontWeight: FontWeight.bold,
// //                       fontSize: 16,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildSectionHeader(
// //     String title,
// //     String trailing, {
// //     VoidCallback? onTrailingTap,
// //   }) {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //       children: [
// //         Text(
// //           title,
// //           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //         ),
// //         GestureDetector(
// //           onTap: onTrailingTap,
// //           child: Container(
// //             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //             decoration: BoxDecoration(
// //               color: tealTheme.withOpacity(0.1),
// //               borderRadius: BorderRadius.circular(10),
// //             ),
// //             child: Text(
// //               trailing,
// //               style: TextStyle(
// //                 color: tealTheme,
// //                 fontSize: 12,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildHorizontalSubjectProgress() {
// //     return SizedBox(
// //       height: 130,
// //       child: ListView.builder(
// //         scrollDirection: Axis.horizontal,
// //         itemCount: subjectsData.length,
// //         itemBuilder: (context, index) {
// //           final sub = subjectsData[index];
// //           return GestureDetector(
// //             onTap: () => showSubjectDetail(context, sub, tealTheme),
// //             child: Container(
// //               width: 140,
// //               margin: const EdgeInsets.only(right: 15),
// //               padding: const EdgeInsets.all(15),
// //               decoration: BoxDecoration(
// //                 color: Colors.white,
// //                 borderRadius: BorderRadius.circular(20),
// //                 border: Border.all(color: Colors.black12),
// //               ),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   Icon(Icons.book, color: sub["color"]),
// //                   const SizedBox(height: 8),
// //                   Text(
// //                     sub["name"],
// //                     style: const TextStyle(
// //                       fontWeight: FontWeight.bold,
// //                       fontSize: 13,
// //                     ),
// //                     overflow: TextOverflow.ellipsis,
// //                   ),
// //                   const SizedBox(height: 10),
// //                   LinearProgressIndicator(
// //                     value: sub["progress"],
// //                     color: sub["color"],
// //                     backgroundColor: sub["color"].withOpacity(0.1),
// //                     borderRadius: BorderRadius.circular(5),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }

// //   static void showSubjectDetail(
// //     BuildContext context,
// //     Map<String, dynamic> sub,
// //     Color themeColor,
// //   ) {
// //     showModalBottomSheet(
// //       context: context,
// //       shape: const RoundedRectangleBorder(
// //         borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
// //       ),
// //       builder: (context) => Padding(
// //         padding: const EdgeInsets.all(25),
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             Container(
// //               width: 40,
// //               height: 5,
// //               decoration: BoxDecoration(
// //                 color: Colors.grey[300],
// //                 borderRadius: BorderRadius.circular(10),
// //               ),
// //             ),
// //             const SizedBox(height: 20),
// //             Text(
// //               sub["name"],
// //               style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
// //             ),
// //             const Divider(),
// //             _buildDetailRow("Total Sessions", "${sub["total"]}"),
// //             _buildDetailRow(
// //               "Present",
// //               "${sub["present"]}",
// //               color: Colors.green,
// //             ),
// //             _buildDetailRow("Late", "${sub["late"]}", color: Colors.orange),
// //             _buildDetailRow(
// //               "Permission",
// //               "${sub["permission"]}",
// //               color: Colors.blue,
// //             ),
// //             _buildDetailRow("Absent", "${sub["absent"]}", color: Colors.red),
// //             const SizedBox(height: 20),
// //             SizedBox(
// //               width: double.infinity,
// //               height: 50,
// //               child: ElevatedButton(
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: themeColor,
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(15),
// //                   ),
// //                 ),
// //                 onPressed: () => Navigator.pop(context),
// //                 child: const Text(
// //                   "Back",
// //                   style: TextStyle(
// //                     color: Colors.white,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   static Widget _buildDetailRow(String label, String value, {Color? color}) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 8),
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //         children: [
// //           Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
// //           Text(
// //             value,
// //             style: TextStyle(
// //               fontSize: 16,
// //               fontWeight: FontWeight.bold,
// //               color: color,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // --- SUBJECT LIST PAGE ---
// // class SubjectListPage extends StatefulWidget {
// //   final List<Map<String, dynamic>> subjects;
// //   final Color themeColor;
// //   const SubjectListPage({
// //     super.key,
// //     required this.subjects,
// //     required this.themeColor,
// //   });
// //   @override
// //   State<SubjectListPage> createState() => _SubjectListPageState();
// // }

// // class _SubjectListPageState extends State<SubjectListPage> {
// //   late List<Map<String, dynamic>> filteredSubjects;
// //   @override
// //   void initState() {
// //     super.initState();
// //     filteredSubjects = widget.subjects;
// //   }

// //   void _filterList(String val) {
// //     setState(() {
// //       filteredSubjects = widget.subjects
// //           .where((s) => s["name"].toLowerCase().contains(val.toLowerCase()))
// //           .toList();
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xFFFBFDFF),
// //       appBar: AppBar(
// //         title: const Text(
// //           "Subject Progress",
// //           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
// //         ),
// //         backgroundColor: Colors.white,
// //         elevation: 0,
// //         leading: IconButton(
// //           icon: const Icon(
// //             Icons.arrow_back_ios_new_rounded,
// //             color: Colors.black,
// //           ),
// //           onPressed: () => Navigator.pop(context),
// //         ),
// //       ),
// //       body: Column(
// //         children: [
// //           Padding(
// //             padding: const EdgeInsets.all(20.0),
// //             child: TextField(
// //               onChanged: _filterList,
// //               decoration: InputDecoration(
// //                 hintText: "Search subject...",
// //                 prefixIcon: const Icon(Icons.search),
// //                 filled: true,
// //                 fillColor: Colors.white,
// //                 border: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(15),
// //                   borderSide: const BorderSide(color: Colors.black12),
// //                 ),
// //                 enabledBorder: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(15),
// //                   borderSide: const BorderSide(color: Colors.black12),
// //                 ),
// //               ),
// //             ),
// //           ),
// //           Expanded(
// //             child: ListView.builder(
// //               padding: const EdgeInsets.symmetric(horizontal: 20),
// //               itemCount: filteredSubjects.length,
// //               itemBuilder: (context, index) {
// //                 final sub = filteredSubjects[index];
// //                 return Card(
// //                   margin: const EdgeInsets.only(bottom: 12),
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(15),
// //                     side: const BorderSide(color: Colors.black12),
// //                   ),
// //                   child: ListTile(
// //                     leading: CircleAvatar(
// //                       backgroundColor: sub["color"].withOpacity(0.1),
// //                       child: Icon(Icons.book, color: sub["color"]),
// //                     ),
// //                     title: Text(
// //                       sub["name"],
// //                       style: const TextStyle(fontWeight: FontWeight.bold),
// //                     ),
// //                     trailing: Text(
// //                       "${(sub["progress"] * 100).toInt()}%",
// //                       style: TextStyle(
// //                         color: sub["color"],
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                     onTap: () => _AttendanceDashboardState.showSubjectDetail(
// //                       context,
// //                       sub,
// //                       widget.themeColor,
// //                     ),
// //                   ),
// //                 );
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// // class AttendanceDetailPage extends StatelessWidget {
// //   final List<Map<String, dynamic>> subjects;
// //   final Color themeColor;

// //   const AttendanceDetailPage({
// //     super.key,
// //     required this.subjects,
// //     required this.themeColor,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xFFFBFDFF),
// //       appBar: AppBar(
// //         title: const Text(
// //           "Attendance Analysis",
// //           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
// //         ),
// //         backgroundColor: Colors.white,
// //         elevation: 0,
// //         leading: IconButton(
// //           icon: const Icon(
// //             Icons.arrow_back_ios_new_rounded,
// //             color: Colors.black,
// //           ),
// //           onPressed: () => Navigator.pop(context),
// //         ),
// //       ),
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(20),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             const Text(
// //               "Performance by Subject",
// //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //             ),
// //             const SizedBox(height: 20),

// //             // Large Chart Container
// //             Container(
// //               height: 350,
// //               padding: const EdgeInsets.only(top: 20, right: 20, bottom: 10),
// //               decoration: BoxDecoration(
// //                 color: Colors.white,
// //                 borderRadius: BorderRadius.circular(20),
// //                 border: Border.all(color: Colors.black12),
// //               ),
// //               child: BarChart(
// //                 BarChartData(
// //                   alignment: BarChartAlignment.spaceAround,
// //                   maxY: 100,
// //                   barTouchData: BarTouchData(
// //                     enabled: true,
// //                     touchTooltipData: BarTouchTooltipData(
// //                       getTooltipColor: (group) => themeColor,
// //                       getTooltipItem: (group, groupIndex, rod, rodIndex) {
// //                         return BarTooltipItem(
// //                           "${subjects[groupIndex]['name']}\n${rod.toY.toInt()}%",
// //                           const TextStyle(
// //                             color: Colors.white,
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                         );
// //                       },
// //                     ),
// //                   ),
// //                   titlesData: FlTitlesData(
// //                     show: true,
// //                     leftTitles: AxisTitles(
// //                       sideTitles: SideTitles(
// //                         showTitles: true,
// //                         reservedSize: 40,
// //                         getTitlesWidget: (value, meta) => Text(
// //                           "${value.toInt()}%",
// //                           style: const TextStyle(
// //                             fontSize: 10,
// //                             color: Colors.grey,
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                     bottomTitles: AxisTitles(
// //                       sideTitles: SideTitles(
// //                         showTitles: true,
// //                         getTitlesWidget: (value, meta) {
// //                           int i = value.toInt();
// //                           if (i < 0 || i >= subjects.length)
// //                             return const Text("");
// //                           return SideTitleWidget(
// //                             axisSide: meta.axisSide,
// //                             child: Text(
// //                               subjects[i]['name'].substring(0, 3),
// //                               style: const TextStyle(fontSize: 11),
// //                             ),
// //                           );
// //                         },
// //                       ),
// //                     ),
// //                     rightTitles: const AxisTitles(
// //                       sideTitles: SideTitles(showTitles: false),
// //                     ),
// //                     topTitles: const AxisTitles(
// //                       sideTitles: SideTitles(showTitles: false),
// //                     ),
// //                   ),
// //                   gridData: FlGridData(
// //                     show: true,
// //                     drawVerticalLine: false,
// //                     getDrawingHorizontalLine: (value) => FlLine(
// //                       color: Colors.grey.withOpacity(0.1),
// //                       strokeWidth: 1,
// //                     ),
// //                   ),
// //                   borderData: FlBorderData(show: false),
// //                   barGroups: subjects.asMap().entries.map((e) {
// //                     return BarChartGroupData(
// //                       x: e.key,
// //                       barRods: [
// //                         BarChartRodData(
// //                           toY: e.value['progress'] * 100,
// //                           color: e.value['color'],
// //                           width: 20,
// //                           borderRadius: BorderRadius.circular(4),
// //                         ),
// //                       ],
// //                     );
// //                   }).toList(),
// //                 ),
// //               ),
// //             ),

// //             const SizedBox(height: 30),
// //             const Text(
// //               "Quick Stats",
// //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //             ),
// //             const SizedBox(height: 15),

// //             // Grid of Stats
// //             GridView.count(
// //               shrinkWrap: true,
// //               physics: const NeverScrollableScrollPhysics(),
// //               crossAxisCount: 2,
// //               mainAxisSpacing: 15,
// //               crossAxisSpacing: 15,
// //               childAspectRatio: 1.5,
// //               children: [
// //                 _buildStatCard("Most Present", "Khmer", Colors.green),
// //                 _buildStatCard("Needs Attention", "Chemistry", Colors.red),
// //                 _buildStatCard("Total Sessions", "328", Colors.blue),
// //                 _buildStatCard("Overall Rank", "4th / 45", Colors.orange),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildStatCard(String label, String value, Color color) {
// //     return Container(
// //       padding: const EdgeInsets.all(15),
// //       decoration: BoxDecoration(
// //         color: color.withOpacity(0.05),
// //         borderRadius: BorderRadius.circular(15),
// //         border: Border.all(color: color.withOpacity(0.2)),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           Text(
// //             label,
// //             style: TextStyle(fontSize: 12, color: color.withOpacity(0.8)),
// //           ),
// //           const SizedBox(height: 5),
// //           Text(
// //             value,
// //             style: TextStyle(
// //               fontSize: 18,
// //               fontWeight: FontWeight.bold,
// //               color: color,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:fl_chart/fl_chart.dart';

// void main() {
//   runApp(
//     const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: AttendanceDashboard(),
//     ),
//   );
// }

// class AttendanceDashboard extends StatefulWidget {
//   const AttendanceDashboard({super.key});

//   @override
//   State<AttendanceDashboard> createState() => _AttendanceDashboardState();
// }

// class _AttendanceDashboardState extends State<AttendanceDashboard> {
//   int _pageIndex = 0;
//   final Color tealTheme = const Color(0xFF0D7C7A);
//   final Color scaffoldBg = const Color(0xFFFBFDFF);

//   // State for Calendar
//   DateTime _focusedDay = DateTime(2024, 4, 1);
//   DateTime? _selectedDay;
//   final ScrollController _scrollController = ScrollController();

//   final List<Map<String, dynamic>> subjectsData = [
//     {
//       "name": "Khmer",
//       "progress": 0.98,
//       "color": Colors.teal,
//       "absent": 1,
//       "present": 45,
//       "late": 2,
//       "permission": 1,
//       "total": 49,
//     },
//     {
//       "name": "Math",
//       "progress": 0.85,
//       "color": Colors.orange,
//       "absent": 4,
//       "present": 40,
//       "late": 3,
//       "permission": 0,
//       "total": 47,
//     },
//     {
//       "name": "Physics",
//       "progress": 0.92,
//       "color": Colors.blue,
//       "absent": 2,
//       "present": 42,
//       "late": 1,
//       "permission": 2,
//       "total": 47,
//     },
//     {
//       "name": "Chemistry",
//       "progress": 0.78,
//       "color": Colors.purple,
//       "absent": 6,
//       "present": 38,
//       "late": 4,
//       "permission": 1,
//       "total": 49,
//     },
//     {
//       "name": "Biology",
//       "progress": 0.95,
//       "color": Colors.green,
//       "absent": 1,
//       "present": 44,
//       "late": 0,
//       "permission": 3,
//       "total": 48,
//     },
//     {
//       "name": "History",
//       "progress": 0.95,
//       "color": Colors.brown,
//       "absent": 1,
//       "present": 40,
//       "late": 1,
//       "permission": 2,
//       "total": 44,
//     },
//     {
//       "name": "English",
//       "progress": 0.88,
//       "color": Colors.pink,
//       "absent": 3,
//       "present": 39,
//       "late": 2,
//       "permission": 1,
//       "total": 45,
//     },
//   ];

//   final Map<DateTime, String> _attendanceRecords = {
//     DateTime(2024, 4, 1): 'Present',
//     DateTime(2024, 4, 2): 'Late',
//     DateTime(2024, 4, 3): 'Absent',
//     DateTime(2024, 4, 4): 'Permission',
//     DateTime(2024, 4, 8): 'Present',
//     DateTime(2024, 4, 10): 'Late',
//   };

//   late final List<Widget> _screens = [
//     _buildAttendanceHome(),
//     const Center(child: Text("Library")),
//     const Center(child: Text("Messages")),
//     const Center(child: Text("Profile Settings")),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: scaffoldBg,
//       appBar: _pageIndex == 0
//           ? AppBar(
//               backgroundColor: scaffoldBg,
//               elevation: 0,
//               title: const Text(
//                 'My Attendance',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.w800,
//                 ),
//               ),
//               centerTitle: true,
//             )
//           : null,
//       body: IndexedStack(index: _pageIndex, children: _screens),
//       bottomNavigationBar: CurvedNavigationBar(
//         index: _pageIndex,
//         height: 65.0,
//         items: const [
//           Icon(Icons.dashboard_rounded, size: 28, color: Colors.white),
//           Icon(Icons.book_rounded, size: 28, color: Colors.white),
//           Icon(
//             Icons.chat_bubble_outline_rounded,
//             size: 28,
//             color: Colors.white,
//           ),
//           Icon(Icons.person_outline_rounded, size: 28, color: Colors.white),
//         ],
//         color: tealTheme,
//         buttonBackgroundColor: tealTheme,
//         backgroundColor: Colors.transparent,
//         onTap: (index) => setState(() => _pageIndex = index),
//       ),
//     );
//   }

//   Widget _buildAttendanceHome() {
//     return SingleChildScrollView(
//       controller: _scrollController,
//       physics: const BouncingScrollPhysics(),
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSummaryCard(tealTheme),
//           const SizedBox(height: 25),
//           _buildSectionHeader(
//             "Performance Graph",
//             "Overview",
//             onTrailingTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => AttendanceDetailPage(
//                     subjects: subjectsData,
//                     themeColor: tealTheme,
//                   ),
//                 ),
//               );
//             },
//           ),
//           const SizedBox(height: 15),
//           _buildBarChart(),
//           const SizedBox(height: 30),
//           _buildSectionHeader(
//             "Academic Calendar",
//             DateFormat('MMMM yyyy').format(_focusedDay),
//             onTrailingTap: () => _selectCalendarDate(context),
//           ),
//           const SizedBox(height: 15),
//           _buildInteractiveCalendar(),
//           const SizedBox(height: 30),
//           _buildSectionHeader(
//             "Subject Progress",
//             "See All",
//             onTrailingTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => SubjectListPage(
//                     subjects: subjectsData,
//                     themeColor: tealTheme,
//                   ),
//                 ),
//               );
//             },
//           ),
//           const SizedBox(height: 15),
//           _buildHorizontalSubjectProgress(),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }

//   // --- INTERACTIVE GRAPH WITH HOVER ---
//   Widget _buildBarChart() {
//     return Container(
//       height: 250,
//       padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
//         ],
//       ),
//       child: BarChart(
//         BarChartData(
//           alignment: BarChartAlignment.spaceAround,
//           maxY: 1.0,
//           barTouchData: BarTouchData(
//             touchTooltipData: BarTouchTooltipData(
//               getTooltipColor: (group) => Colors.blueGrey.withOpacity(0.9),
//               getTooltipItem: (group, groupIndex, rod, rodIndex) {
//                 final sub = subjectsData[groupIndex];
//                 return BarTooltipItem(
//                   "${sub['name']}\n",
//                   const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   children: [
//                     TextSpan(
//                       text: "Present: ${sub['present']}\n",
//                       style: const TextStyle(
//                         color: Colors.greenAccent,
//                         fontSize: 12,
//                       ),
//                     ),
//                     TextSpan(
//                       text: "Late: ${sub['late']}\n",
//                       style: const TextStyle(
//                         color: Colors.orangeAccent,
//                         fontSize: 12,
//                       ),
//                     ),
//                     TextSpan(
//                       text: "Permission: ${sub['permission']}\n",
//                       style: const TextStyle(
//                         color: Colors.lightBlueAccent,
//                         fontSize: 12,
//                       ),
//                     ),
//                     TextSpan(
//                       text: "Absent: ${sub['absent']}",
//                       style: const TextStyle(
//                         color: Colors.redAccent,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//           titlesData: FlTitlesData(
//             show: true,
//             bottomTitles: AxisTitles(
//               sideTitles: SideTitles(
//                 showTitles: true,
//                 getTitlesWidget: (value, meta) {
//                   int idx = value.toInt();
//                   if (idx >= subjectsData.length) return const SizedBox();
//                   return Padding(
//                     padding: const EdgeInsets.only(top: 8.0),
//                     child: Text(
//                       subjectsData[idx]["name"].substring(0, 3),
//                       style: const TextStyle(
//                         fontSize: 10,
//                         color: Colors.grey,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             leftTitles: const AxisTitles(
//               sideTitles: SideTitles(showTitles: false),
//             ),
//             topTitles: const AxisTitles(
//               sideTitles: SideTitles(showTitles: false),
//             ),
//             rightTitles: const AxisTitles(
//               sideTitles: SideTitles(showTitles: false),
//             ),
//           ),
//           gridData: const FlGridData(show: false),
//           borderData: FlBorderData(show: false),
//           barGroups: subjectsData.asMap().entries.map((entry) {
//             return BarChartGroupData(
//               x: entry.key,
//               barRods: [
//                 BarChartRodData(
//                   toY: entry.value["progress"],
//                   color: entry.value["color"],
//                   width: 16,
//                   borderRadius: const BorderRadius.vertical(
//                     top: Radius.circular(6),
//                   ),
//                   backDrawRodData: BackgroundBarChartRodData(
//                     show: true,
//                     toY: 1.0,
//                     color: Colors.grey[100],
//                   ),
//                 ),
//               ],
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }

//   // --- CALENDAR WITH LEGEND AND DATE PICKER ---
//   Future<void> _selectCalendarDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _focusedDay,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2030),
//       initialDatePickerMode: DatePickerMode.year,
//     );
//     if (picked != null && picked != _focusedDay) {
//       setState(() {
//         _focusedDay = picked;
//       });
//     }
//   }

//   Widget _buildInteractiveCalendar() {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
//         ],
//       ),
//       child: Column(
//         children: [
//           TableCalendar(
//             firstDay: DateTime.utc(2020, 1, 1),
//             lastDay: DateTime.utc(2030, 12, 31),
//             focusedDay: _focusedDay,
//             selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//             headerStyle: const HeaderStyle(
//               formatButtonVisible: false,
//               titleCentered: true,
//             ),
//             onDaySelected: (selectedDay, focusedDay) {
//               setState(() {
//                 _selectedDay = selectedDay;
//                 _focusedDay = focusedDay;
//               });
//               _showAttendanceStatus(selectedDay);
//             },
//             calendarBuilders: CalendarBuilders(
//               defaultBuilder: (context, day, focusedDay) {
//                 final date = DateTime(day.year, day.month, day.day);
//                 if (_attendanceRecords.containsKey(date)) {
//                   String status = _attendanceRecords[date]!;
//                   return Center(
//                     child: Container(
//                       width: 35,
//                       height: 35,
//                       decoration: BoxDecoration(
//                         color: _getStatusColor(status).withOpacity(0.2),
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                           color: _getStatusColor(status),
//                           width: 1,
//                         ),
//                       ),
//                       child: Center(
//                         child: Text(
//                           '${day.day}',
//                           style: TextStyle(
//                             color: _getStatusColor(status),
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 }
//                 return null;
//               },
//             ),
//           ),
//           const Divider(height: 30),
//           _buildCalendarLegend(),
//         ],
//       ),
//     );
//   }

//   Widget _buildCalendarLegend() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         _legendItem("Present", Colors.green),
//         _legendItem("Late", Colors.orange),
//         _legendItem("Permission", Colors.blue),
//         _legendItem("Absent", Colors.red),
//       ],
//     );
//   }

//   Widget _legendItem(String label, Color color) {
//     return Row(
//       children: [
//         Container(
//           width: 8,
//           height: 8,
//           decoration: BoxDecoration(color: color, shape: BoxShape.circle),
//         ),
//         const SizedBox(width: 5),
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 10,
//             color: Colors.grey,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }

//   Color _getStatusColor(String status) {
//     switch (status) {
//       case 'Present':
//         return Colors.green;
//       case 'Absent':
//         return Colors.red;
//       case 'Late':
//         return Colors.orange;
//       case 'Permission':
//         return Colors.blue;
//       default:
//         return Colors.grey;
//     }
//   }

//   void _showAttendanceStatus(DateTime date) {
//     final status =
//         _attendanceRecords[DateTime(date.year, date.month, date.day)] ??
//         "No Record";
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: Text(DateFormat('EEEE, MMM d').format(date)),
//         content: Text(
//           "Status: $status",
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: _getStatusColor(status),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Close"),
//           ),
//         ],
//       ),
//     );
//   }

//   // --- EXISTING HELPERS ---
//   Widget _buildSummaryCard(Color color) {
//     return Container(
//       height: 150,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(32),
//         gradient: LinearGradient(colors: [color, color.withBlue(140)]),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   "AVERAGE ATTENDANCE",
//                   style: TextStyle(
//                     color: Colors.white70,
//                     fontSize: 11,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   "Keep it up,\nSophal!",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 22,
//                     fontWeight: FontWeight.w900,
//                     height: 1.1,
//                   ),
//                 ),
//               ],
//             ),
//             GestureDetector(
//               onTap: () => _scrollController.animateTo(
//                 180,
//                 duration: const Duration(milliseconds: 600),
//                 curve: Curves.easeInOut,
//               ),
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   const SizedBox(
//                     width: 70,
//                     height: 70,
//                     child: CircularProgressIndicator(
//                       value: 0.95,
//                       strokeWidth: 8,
//                       backgroundColor: Colors.white12,
//                       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                     ),
//                   ),
//                   const Text(
//                     "95%",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
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

//   Widget _buildSectionHeader(
//     String title,
//     String trailing, {
//     VoidCallback? onTrailingTap,
//   }) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         GestureDetector(
//           onTap: onTrailingTap,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: tealTheme.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Text(
//               trailing,
//               style: TextStyle(
//                 color: tealTheme,
//                 fontSize: 12,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildHorizontalSubjectProgress() {
//     return SizedBox(
//       height: 130,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: subjectsData.length,
//         itemBuilder: (context, index) {
//           final sub = subjectsData[index];
//           return GestureDetector(
//             onTap: () => showSubjectDetail(context, sub, tealTheme),
//             child: Container(
//               width: 140,
//               margin: const EdgeInsets.only(right: 15),
//               padding: const EdgeInsets.all(15),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: Colors.black12),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.book, color: sub["color"]),
//                   const SizedBox(height: 8),
//                   Text(
//                     sub["name"],
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 13,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 10),
//                   LinearProgressIndicator(
//                     value: sub["progress"],
//                     color: sub["color"],
//                     backgroundColor: sub["color"].withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   void showSubjectDetail(
//     BuildContext context,
//     Map<String, dynamic> sub,
//     Color themeColor,
//   ) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//       ),
//       builder: (context) => Padding(
//         padding: const EdgeInsets.all(25),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 40,
//               height: 5,
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               sub["name"],
//               style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             const Divider(),
//             _buildDetailRow("Total Sessions", "${sub["total"]}"),
//             _buildDetailRow(
//               "Present",
//               "${sub["present"]}",
//               color: Colors.green,
//             ),
//             _buildDetailRow("Late", "${sub["late"]}", color: Colors.orange),
//             _buildDetailRow(
//               "Permission",
//               "${sub["permission"]}",
//               color: Colors.blue,
//             ),
//             _buildDetailRow("Absent", "${sub["absent"]}", color: Colors.red),
//             const SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: themeColor,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                 ),
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text(
//                   "Back",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value, {Color? color}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // --- SUBJECT LIST PAGE ---
// class SubjectListPage extends StatefulWidget {
//   final List<Map<String, dynamic>> subjects;
//   final Color themeColor;
//   const SubjectListPage({
//     super.key,
//     required this.subjects,
//     required this.themeColor,
//   });
//   @override
//   State<SubjectListPage> createState() => _SubjectListPageState();
// }

// class _SubjectListPageState extends State<SubjectListPage> {
//   late List<Map<String, dynamic>> filteredSubjects;
//   @override
//   void initState() {
//     super.initState();
//     filteredSubjects = widget.subjects;
//   }

//   void _filterList(String val) {
//     setState(() {
//       filteredSubjects = widget.subjects
//           .where((s) => s["name"].toLowerCase().contains(val.toLowerCase()))
//           .toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFBFDFF),
//       appBar: AppBar(
//         title: const Text(
//           "Subject Progress",
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back_ios_new_rounded,
//             color: Colors.black,
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: TextField(
//               onChanged: _filterList,
//               decoration: InputDecoration(
//                 hintText: "Search subject...",
//                 prefixIcon: const Icon(Icons.search),
//                 filled: true,
//                 fillColor: Colors.white,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(15),
//                   borderSide: const BorderSide(color: Colors.black12),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(15),
//                   borderSide: const BorderSide(color: Colors.black12),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               itemCount: filteredSubjects.length,
//               itemBuilder: (context, index) {
//                 final sub = filteredSubjects[index];
//                 return Card(
//                   margin: const EdgeInsets.only(bottom: 12),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                     side: const BorderSide(color: Colors.black12),
//                   ),
//                   child: ListTile(
//                     leading: CircleAvatar(
//                       backgroundColor: sub["color"].withOpacity(0.1),
//                       child: Icon(Icons.book, color: sub["color"]),
//                     ),
//                     title: Text(
//                       sub["name"],
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     trailing: Text(
//                       "${(sub["progress"] * 100).toInt()}%",
//                       style: TextStyle(
//                         color: sub["color"],
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     onTap: () {
//                       AttendanceDashboardState state =
//                           AttendanceDashboardState();
//                       state.showSubjectDetail(context, sub, widget.themeColor);
//                     },
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class AttendanceDetailPage extends StatelessWidget {
//   final List<Map<String, dynamic>> subjects;
//   final Color themeColor;

//   const AttendanceDetailPage({
//     super.key,
//     required this.subjects,
//     required this.themeColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFBFDFF),
//       appBar: AppBar(
//         title: const Text(
//           "Attendance Analysis",
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back_ios_new_rounded,
//             color: Colors.black,
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Performance by Subject",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),

//             // Large Chart Container
//             Container(
//               height: 350,
//               padding: const EdgeInsets.only(top: 20, right: 20, bottom: 10),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: Colors.black12),
//               ),
//               child: BarChart(
//                 BarChartData(
//                   alignment: BarChartAlignment.spaceAround,
//                   maxY: 100,
//                   barTouchData: BarTouchData(
//                     enabled: true,
//                     touchTooltipData: BarTouchTooltipData(
//                       getTooltipColor: (group) => themeColor,
//                       getTooltipItem: (group, groupIndex, rod, rodIndex) {
//                         return BarTooltipItem(
//                           "${subjects[groupIndex]['name']}\n${rod.toY.toInt()}%",
//                           const TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   titlesData: FlTitlesData(
//                     show: true,
//                     leftTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         reservedSize: 40,
//                         getTitlesWidget: (value, meta) => Text(
//                           "${value.toInt()}%",
//                           style: const TextStyle(
//                             fontSize: 10,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ),
//                     ),
//                     bottomTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: (value, meta) {
//                           int i = value.toInt();
//                           if (i < 0 || i >= subjects.length)
//                             return const Text("");
//                           return SideTitleWidget(
//                             axisSide: meta.axisSide,
//                             child: Text(
//                               subjects[i]['name'].substring(0, 3),
//                               style: const TextStyle(fontSize: 11),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     rightTitles: const AxisTitles(
//                       sideTitles: SideTitles(showTitles: false),
//                     ),
//                     topTitles: const AxisTitles(
//                       sideTitles: SideTitles(showTitles: false),
//                     ),
//                   ),
//                   gridData: FlGridData(
//                     show: true,
//                     drawVerticalLine: false,
//                     getDrawingHorizontalLine: (value) => FlLine(
//                       color: Colors.grey.withOpacity(0.1),
//                       strokeWidth: 1,
//                     ),
//                   ),
//                   borderData: FlBorderData(show: false),
//                   barGroups: subjects.asMap().entries.map((e) {
//                     return BarChartGroupData(
//                       x: e.key,
//                       barRods: [
//                         BarChartRodData(
//                           toY: e.value['progress'] * 100,
//                           color: e.value['color'],
//                           width: 20,
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                       ],
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 30),
//             const Text(
//               "Quick Stats",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 15),

//             // Grid of Stats
//             GridView.count(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               crossAxisCount: 2,
//               mainAxisSpacing: 15,
//               crossAxisSpacing: 15,
//               childAspectRatio: 1.5,
//               children: [
//                 _buildStatCard("Most Present", "Khmer", Colors.green),
//                 _buildStatCard("Needs Attention", "Chemistry", Colors.red),
//                 _buildStatCard("Total Sessions", "328", Colors.blue),
//                 _buildStatCard("Overall Rank", "4th / 45", Colors.orange),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatCard(String label, String value, Color color) {
//     return Container(
//       padding: const EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(color: color.withOpacity(0.2)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             label,
//             style: TextStyle(fontSize: 12, color: color.withOpacity(0.8)),
//           ),
//           const SizedBox(height: 5),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }






import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AttendanceDashboard(),
    ),
  );
}

class AttendanceDashboard extends StatefulWidget {
  const AttendanceDashboard({super.key});

  @override
  State<AttendanceDashboard> createState() => _AttendanceDashboardState();
}

class _AttendanceDashboardState extends State<AttendanceDashboard> {
  int _pageIndex = 0;
  final Color tealTheme = const Color(0xFF0D7C7A);
  final Color scaffoldBg = const Color(0xFFFBFDFF);

  DateTime _focusedDay = DateTime(2024, 4, 1);
  DateTime? _selectedDay;
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> subjectsData = [
    {
      "name": "Khmer",
      "color": Colors.teal,
      "absent": 1,
      "present": 45,
      "late": 2,
      "permission": 1,
      "total": 49,
    },
    {
      "name": "Math",
      "color": Colors.orange,
      "absent": 4,
      "present": 40,
      "late": 3,
      "permission": 0,
      "total": 47,
    },
    {
      "name": "Physics",
      "color": Colors.blue,
      "absent": 2,
      "present": 42,
      "late": 1,
      "permission": 2,
      "total": 47,
    },
    {
      "name": "Chemistry",
      "color": Colors.purple,
      "absent": 6,
      "present": 38,
      "late": 4,
      "permission": 1,
      "total": 49,
    },
    {
      "name": "Biology",
      "color": Colors.green,
      "absent": 1,
      "present": 44,
      "late": 0,
      "permission": 3,
      "total": 48,
    },
    {
      "name": "History",
      "color": Colors.brown,
      "absent": 1,
      "present": 40,
      "late": 1,
      "permission": 2,
      "total": 44,
    },
    {
      "name": "English",
      "color": Colors.pink,
      "absent": 3,
      "present": 39,
      "late": 2,
      "permission": 1,
      "total": 45,
    },
  ];

  double getSubjectProgress(Map<String, dynamic> sub) {
    final total = sub['total'] as int;
    if (total == 0) return 0.0;
    final score =
        (sub['present'] as int) +
        (sub['late'] as int) * 0.5 +
        (sub['permission'] as int) * 0.8;
    return (score / total).clamp(0.0, 1.0);
  }

  final Map<DateTime, String> _attendanceRecords = {
    DateTime(2024, 4, 1): 'Present',
    DateTime(2024, 4, 2): 'Late',
    DateTime(2024, 4, 3): 'Absent',
    DateTime(2024, 4, 4): 'Permission',
    DateTime(2024, 4, 8): 'Present',
    DateTime(2024, 4, 10): 'Late',
  };

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      _buildAttendanceHome(),
      const Center(child: Text("Library", style: TextStyle(fontSize: 32))),
      const Center(child: Text("Messages", style: TextStyle(fontSize: 32))),
      const Center(
        child: Text("Profile Settings", style: TextStyle(fontSize: 32)),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: _pageIndex == 0
          ? AppBar(
              backgroundColor: scaffoldBg,
              elevation: 0,
              title: const Text(
                'My Attendance',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                ),
              ),
              centerTitle: true,
            )
          : null,
      body: IndexedStack(index: _pageIndex, children: _screens),
      bottomNavigationBar: CurvedNavigationBar(
        index: _pageIndex,
        height: 65.0,
        items: const [
          Icon(Icons.dashboard_rounded, size: 28, color: Colors.white),
          Icon(Icons.book_rounded, size: 28, color: Colors.white),
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: 28,
            color: Colors.white,
          ),
          Icon(Icons.person_outline_rounded, size: 28, color: Colors.white),
        ],
        color: tealTheme,
        buttonBackgroundColor: tealTheme,
        backgroundColor: Colors.transparent,
        onTap: (index) => setState(() => _pageIndex = index),
      ),
    );
  }

  Widget _buildAttendanceHome() {
    return SingleChildScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCard(tealTheme),
          const SizedBox(height: 25),
          _buildSectionHeader(
            "Performance Graph",
            "Overview",
            onTrailingTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AttendanceDetailPage(
                    subjects: subjectsData,
                    themeColor: tealTheme,
                    getProgress: getSubjectProgress,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 15),
          _buildBarChart(),
          const SizedBox(height: 30),
          _buildSectionHeader(
            "Academic Calendar",
            DateFormat('MMMM yyyy').format(_focusedDay),
            onTrailingTap: () => _selectCalendarDate(context),
          ),
          const SizedBox(height: 15),
          _buildInteractiveCalendar(),
          const SizedBox(height: 30),
          _buildSectionHeader(
            "Subject Progress",
            "See All",
            onTrailingTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubjectListPage(
                    subjects: subjectsData,
                    themeColor: tealTheme,
                    getProgress: getSubjectProgress,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 15),
          _buildHorizontalSubjectProgress(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    const double maxY = 60.0;

    return Container(
      height: 280,
      padding: const EdgeInsets.fromLTRB(12, 24, 12, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              // Modern replacements (2024–2025+ fl_chart versions)
              getTooltipColor: (group) => Colors.blueGrey.withOpacity(0.92),
              tooltipBorderRadius: BorderRadius.circular(12),

              tooltipPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              tooltipMargin: 16,
              fitInsideHorizontally: true,
              fitInsideVertically: true,

              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final sub = subjectsData[groupIndex];
                return BarTooltipItem(
                  '${sub['name']}\nTotal: ${sub['total']}',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  children: [
                    TextSpan(
                      text: '\nPresent: ${sub['present']}',
                      style: const TextStyle(color: Colors.greenAccent),
                    ),
                    TextSpan(
                      text: '\nLate: ${sub['late']}',
                      style: const TextStyle(color: Colors.orangeAccent),
                    ),
                    TextSpan(
                      text: '\nPermission: ${sub['permission']}',
                      style: const TextStyle(color: Colors.blueAccent),
                    ),
                    TextSpan(
                      text: '\nAbsent: ${sub['absent']}',
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ],
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 38,
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt();
                  if (idx < 0 || idx >= subjectsData.length)
                    return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      subjectsData[idx]['name'].toString().substring(0, 3),
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                getTitlesWidget: (value, meta) => Text(
                  '${value.toInt()}',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 10,
            getDrawingHorizontalLine: (value) =>
                FlLine(color: Colors.grey.withOpacity(0.12), strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          barGroups: subjectsData.asMap().entries.map((entry) {
            final sub = entry.value;
            return BarChartGroupData(
              x: entry.key,
              barsSpace: 4,
              barRods: [
                BarChartRodData(
                  toY: (sub['present'] as int).toDouble(),
                  color: Colors.green.shade400,
                  width: 14,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(6),
                  ),
                ),
                BarChartRodData(
                  toY: (sub['late'] as int).toDouble(),
                  color: Colors.orange.shade400,
                  width: 14,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(6),
                  ),
                ),
                BarChartRodData(
                  toY: (sub['permission'] as int).toDouble(),
                  color: Colors.blue.shade400,
                  width: 14,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(6),
                  ),
                ),
                BarChartRodData(
                  toY: (sub['absent'] as int).toDouble(),
                  color: Colors.red.shade400,
                  width: 14,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(6),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _selectCalendarDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _focusedDay,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDatePickerMode: DatePickerMode.year,
    );
    if (picked != null && picked != _focusedDay)
      setState(() => _focusedDay = picked);
  }

  Widget _buildInteractiveCalendar() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              _showAttendanceStatus(selectedDay);
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final date = DateTime(day.year, day.month, day.day);
                if (_attendanceRecords.containsKey(date)) {
                  final status = _attendanceRecords[date]!;
                  return Center(
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: _getStatusColor(status).withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _getStatusColor(status),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${day.day}',
                          style: TextStyle(
                            color: _getStatusColor(status),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
          ),
          const Divider(height: 30),
          _buildCalendarLegend(),
        ],
      ),
    );
  }

  Widget _buildCalendarLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _legendItem("Present", Colors.green),
        _legendItem("Late", Colors.orange),
        _legendItem("Permission", Colors.blue),
        _legendItem("Absent", Colors.red),
      ],
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Present':
        return Colors.green;
      case 'Absent':
        return Colors.red;
      case 'Late':
        return Colors.orange;
      case 'Permission':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  void _showAttendanceStatus(DateTime date) {
    final key = DateTime(date.year, date.month, date.day);
    final status = _attendanceRecords[key] ?? "No Record";
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(DateFormat('EEEE, MMM d').format(date)),
        content: Text(
          "Status: $status",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _getStatusColor(status),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(Color color) {
    final totalPresent = subjectsData.fold<int>(
      0,
      (sum, s) => sum + (s['present'] as int),
    );
    final totalSessions = subjectsData.fold<int>(
      0,
      (sum, s) => sum + (s['total'] as int),
    );
    final avg = totalSessions > 0 ? totalPresent / totalSessions : 0.0;

    return Container(
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(colors: [color, color.withBlue(140)]),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "AVERAGE ATTENDANCE",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Keep it up,\nSophal!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () => _scrollController.animateTo(
                180,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 70,
                    height: 70,
                    child: CircularProgressIndicator(
                      value: avg.clamp(0.0, 1.0),
                      strokeWidth: 8,
                      backgroundColor: Colors.white12,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    "${(avg * 100).toStringAsFixed(0)}%",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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

  Widget _buildSectionHeader(
    String title,
    String trailing, {
    VoidCallback? onTrailingTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: onTrailingTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: tealTheme.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              trailing,
              style: TextStyle(
                color: tealTheme,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalSubjectProgress() {
    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: subjectsData.length,
        itemBuilder: (context, index) {
          final sub = subjectsData[index];
          final progress = getSubjectProgress(sub);
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubjectDetailPage(
                    subject: sub,
                    themeColor: tealTheme,
                    progress: progress,
                  ),
                ),
              );
            },
            child: Container(
              width: 140,
              margin: const EdgeInsets.only(right: 15),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.book, color: sub["color"]),
                  const SizedBox(height: 8),
                  Text(
                    sub["name"],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: progress,
                    color: sub["color"],
                    backgroundColor: sub["color"].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class SubjectListPage extends StatefulWidget {
  final List<Map<String, dynamic>> subjects;
  final Color themeColor;
  final double Function(Map<String, dynamic>) getProgress;

  const SubjectListPage({
    super.key,
    required this.subjects,
    required this.themeColor,
    required this.getProgress,
  });

  @override
  State<SubjectListPage> createState() => _SubjectListPageState();
}

class _SubjectListPageState extends State<SubjectListPage> {
  late List<Map<String, dynamic>> filteredSubjects;

  @override
  void initState() {
    super.initState();
    filteredSubjects = widget.subjects;
  }

  void _filterList(String val) {
    setState(() {
      filteredSubjects = widget.subjects
          .where(
            (s) =>
                (s["name"] as String).toLowerCase().contains(val.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFDFF),
      appBar: AppBar(
        title: const Text(
          "Subject Progress",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              onChanged: _filterList,
              decoration: InputDecoration(
                hintText: "Search subject...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: filteredSubjects.length,
              itemBuilder: (context, index) {
                final sub = filteredSubjects[index];
                final progress = widget.getProgress(sub);
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: const BorderSide(color: Colors.black12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: sub["color"].withOpacity(0.1),
                      child: Icon(Icons.book, color: sub["color"]),
                    ),
                    title: Text(
                      sub["name"],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "P: ${sub['present']} • A: ${sub['absent']} • T: ${sub['total']}",
                      style: TextStyle(color: Colors.grey[700], fontSize: 12),
                    ),
                    trailing: Text(
                      "${(progress * 100).toInt()}%",
                      style: TextStyle(
                        color: sub["color"],
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubjectDetailPage(
                            subject: sub,
                            themeColor: widget.themeColor,
                            progress: progress,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SubjectDetailPage extends StatelessWidget {
  final Map<String, dynamic> subject;
  final Color themeColor;
  final double progress;

  const SubjectDetailPage({
    super.key,
    required this.subject,
    required this.themeColor,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final name = subject['name'] as String;
    final present = subject['present'] as int;
    final late = subject['late'] as int;
    final permission = subject['permission'] as int;
    final absent = subject['absent'] as int;
    final total = subject['total'] as int;

    return Scaffold(
      backgroundColor: const Color(0xFFFBFDFF),
      appBar: AppBar(
        title: Text(name, style: const TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: themeColor.withOpacity(0.08),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Attendance Summary",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: themeColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildStatRow("Total Sessions", "$total", null),
                    _buildStatRow("Present", "$present", Colors.green),
                    _buildStatRow("Late", "$late", Colors.orange),
                    _buildStatRow("Permission", "$permission", Colors.blue),
                    _buildStatRow("Absent", "$absent", Colors.red),
                    const Divider(height: 32),
                    _buildStatRow(
                      "Attendance Rate",
                      "${(progress * 100).toStringAsFixed(1)}%",
                      themeColor,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Progress",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                backgroundColor: Colors.grey[200],
                color: subject['color'],
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "${(progress * 100).toInt()}%",
                style: TextStyle(
                  color: subject['color'],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color? color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 15, color: Colors.black54),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class AttendanceDetailPage extends StatelessWidget {
  final List<Map<String, dynamic>> subjects;
  final Color themeColor;
  final double Function(Map<String, dynamic>) getProgress;

  const AttendanceDetailPage({
    super.key,
    required this.subjects,
    required this.themeColor,
    required this.getProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFDFF),
      appBar: AppBar(
        title: const Text(
          "Attendance Analysis",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Performance by Subject",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Here you can reuse _buildBarChart() if you want the stacked version in this page too
            Container(
              height: 350,
              padding: const EdgeInsets.only(top: 20, right: 20, bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black12),
              ),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (group) => themeColor.withOpacity(0.9),
                      tooltipBorderRadius: BorderRadius.circular(12),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final sub = subjects[groupIndex];
                        return BarTooltipItem(
                          "${sub['name']}\n${rod.toY.toInt()}%",
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => Text(
                          "${value.toInt()}%",
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          int i = value.toInt();
                          if (i < 0 || i >= subjects.length)
                            return const Text("");
                          return Text(
                            subjects[i]['name'].toString().substring(0, 3),
                            style: const TextStyle(fontSize: 11),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.withOpacity(0.1),
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: subjects.asMap().entries.map((e) {
                    final progress = getProgress(e.value) * 100;
                    return BarChartGroupData(
                      x: e.key,
                      barRods: [
                        BarChartRodData(
                          toY: progress,
                          color: e.value['color'],
                          width: 20,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Quick Stats",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.38,
              children: [
                _buildStatCard(
                  "Most Present",
                  "Khmer",
                  Colors.green,
                  Icons.check_circle_rounded,
                  () => _showDetailDialog(
                    context,
                    "Most Present Subject",
                    "Khmer has the highest attendance rate.\nPresent: 45 / 49 sessions (${(45 / 49 * 100).toStringAsFixed(1)}%)",
                  ),
                ),
                _buildStatCard(
                  "Needs Attention",
                  "Chemistry",
                  Colors.red,
                  Icons.warning_rounded,
                  () => _showDetailDialog(
                    context,
                    "Subject Needing Improvement",
                    "Chemistry has the most absences.\nAbsent: 6 sessions • Attendance: ${(getProgress(subjects[3]) * 100).toStringAsFixed(1)}%",
                  ),
                ),
                _buildStatCard(
                  "Total Sessions",
                  "328",
                  Colors.blue,
                  Icons.calendar_today_rounded,
                  () => _showDetailDialog(
                    context,
                    "Total Academic Sessions",
                    "You have attended or been marked in 328 sessions across all subjects.",
                  ),
                ),
                _buildStatCard(
                  "Overall Rank",
                  "4th / 45",
                  Colors.deepOrange,
                  Icons.emoji_events_rounded,
                  () => _showDetailDialog(
                    context,
                    "Class Rank (Attendance)",
                    "Your current attendance places you 4th out of 45 students.",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    Color color,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withOpacity(0.12), color.withOpacity(0.04)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 22),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: color.withOpacity(0.9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: color.withOpacity(0.95),
                letterSpacing: -0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        content: Text(content, style: const TextStyle(fontSize: 15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}
