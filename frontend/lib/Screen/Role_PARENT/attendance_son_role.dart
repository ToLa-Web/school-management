import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fl_chart/fl_chart.dart'; // Add this to pubspec.yaml
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tamdansers/Screen/Edit-Profile/student_edit_profile.dart';

class ParentAttendanceMonitor extends StatefulWidget {
  const ParentAttendanceMonitor({super.key});
  @override
  State<ParentAttendanceMonitor> createState() =>
      _ParentAttendanceMonitorState();
}

class _ParentAttendanceMonitorState extends State<ParentAttendanceMonitor> {
  int _pageIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  // Premium Palette
  final Color primaryColor = const Color(0xFF0D3B66);
  final Color backgroundLight = const Color(0xFFF3F6F8);
  final Color tealAccent = const Color(0xFF50E3C2);
  final Color blueAccent = const Color(0xFF4A90E2);
  final Color coralAccent = const Color(0xFFFF6B6B);
  final Color orangeAccent = const Color(0xFFFFB75E);
  final Color purpleAccent = const Color(0xFFB86DFF);

  // Selected month for calendar
  // ignore: unused_field
  final int _selectedMonth = 3; // April
  // ignore: unused_field
  final int _selectedYear = 2024;

  // Selected subject for detail view
  // ignore: unused_field
  String? _selectedSubject;

  // Attendance data for charts
  final List<Map<String, dynamic>> _attendanceData = [
    {"month": "Jan", "present": 92, "absent": 8},
    {"month": "Feb", "present": 88, "absent": 12},
    {"month": "Mar", "present": 94, "absent": 6},
    {"month": "Apr", "present": 95, "absent": 5},
    {"month": "May", "present": 91, "absent": 9},
    {"month": "Jun", "present": 89, "absent": 11},
  ];

  final List<Map<String, dynamic>> subjectsData = [
    {
      "name": "Mathematics",
      "progress": 0.98,
      "color": const Color(0xFFFFB75E),
      "absent": 1,
      "present": 45,
      "late": 2,
      "permission": 1,
      "total": 49,
      "teacher": "Mr. Sok Chea",
      "room": "Room 302",
      "schedule": "Mon/Wed 08:00 AM",
      "grade": "A+",
    },
    {
      "name": "Physics",
      "progress": 0.85,
      "color": const Color(0xFF4A90E2),
      "absent": 4,
      "present": 40,
      "late": 3,
      "permission": 0,
      "total": 47,
      "teacher": "Dr. Emily Watson",
      "room": "Lab 01",
      "schedule": "Tue/Thu 10:00 AM",
      "grade": "B+",
    },
    {
      "name": "Khmer Literature",
      "progress": 0.95,
      "color": const Color(0xFFB86DFF),
      "absent": 1,
      "present": 44,
      "late": 0,
      "permission": 3,
      "total": 48,
      "teacher": "Ms. Sophea",
      "room": "Room 201",
      "schedule": "Mon/Wed 01:30 PM",
      "grade": "A",
    },
  ];

  // Schedule data for current month
  final List<Map<String, dynamic>> _scheduleData = [
    {
      "date": "15",
      "title": "Mathematics Quiz",
      "type": "Quiz",
      "accent": const Color(0xFFFFB75E),
    },
    {
      "date": "18",
      "title": "Physics Lab",
      "type": "Lab",
      "accent": const Color(0xFF4A90E2),
    },
    {
      "date": "22",
      "title": "Khmer Literature",
      "type": "Assignment",
      "accent": const Color(0xFFB86DFF),
    },
    {
      "date": "25",
      "title": "Parent Meeting",
      "type": "Meeting",
      "accent": const Color(0xFF50E3C2),
    },
    {
      "date": "28",
      "title": "Science Fair",
      "type": "Event",
      "accent": const Color(0xFFFF6B6B),
    },
  ];

  late final List<Widget> _screens = [
    _buildMonitorHome(),
    Center(
      child: Text(
        "Homework",
        style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ),
    Center(
      child: Text(
        "Reports",
        style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ),
    const StudentEditProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Bounceable(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: primaryColor,
              size: 16,
            ),
          ),
        ),
        title: Text(
          'Attendance Monitor',
          style: GoogleFonts.outfit(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: IndexedStack(index: _pageIndex, children: _screens),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _pageIndex,
        height: 60.0,
        items: const <Widget>[
          Icon(Icons.analytics_rounded, size: 24, color: Colors.white),
          Icon(
            Icons.assignment_turned_in_rounded,
            size: 24,
            color: Colors.white,
          ),
          Icon(Icons.pie_chart_rounded, size: 24, color: Colors.white),
          Icon(Icons.person_rounded, size: 24, color: Colors.white),
        ],
        color: primaryColor,
        buttonBackgroundColor: blueAccent,
        backgroundColor: backgroundLight,
        animationCurve: Curves.easeInOutBack,
        animationDuration: const Duration(milliseconds: 350),
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
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildChildSummaryHeader(),
          const SizedBox(height: 20),
          _buildSummaryCard(),
          const SizedBox(height: 24),
          _buildSectionTitle('Attendance Analytics', '6 Months'),
          const SizedBox(height: 16),
          _buildAttendanceChart(),
          const SizedBox(height: 24),
          _buildSectionTitle('Monthly Schedule', 'This Month'),
          const SizedBox(height: 16),
          _buildScheduleList(),
          const SizedBox(height: 24),
          _buildSectionTitle('Subject Details', 'View All'),
          const SizedBox(height: 16),
          _buildSubjectList(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, String actionInfo) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          Bounceable(
            onTap: () {
              if (title == 'Monthly Schedule') {
                _showScheduleDetail();
              } else if (title == 'Subject Details') {
                _showAllSubjects();
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: blueAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                actionInfo,
                style: GoogleFonts.inter(
                  color: blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildSummaryHeader() {
    return Bounceable(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: primaryColor.withValues(alpha: 0.1),
                  width: 2,
                ),
              ),
              child: const CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(
                  'https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?w=740',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alex Johnson',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Class 12A • Academic Year 2024',
                    style: GoogleFonts.inter(
                      color: Colors.grey.shade600,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: backgroundLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.swap_horiz_rounded,
                color: primaryColor,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Bounceable(
      onTap: () => _showAttendanceGraph(),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor, primaryColor.withValues(alpha: 0.85)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.2),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'OVERALL ATTENDANCE',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Excellent Rate',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.trending_up_rounded,
                      color: tealAccent,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '+2% from last month',
                      style: GoogleFonts.inter(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
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
                    strokeWidth: 6,
                    backgroundColor: Colors.white.withValues(alpha: 0.15),
                    valueColor: AlwaysStoppedAnimation<Color>(tealAccent),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '95%',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Tap',
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceChart() {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 20,
            getDrawingHorizontalLine: (value) =>
                FlLine(color: const Color(0xFFF3F6F8), strokeWidth: 1),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 20,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index < 0 || index >= _attendanceData.length) {
                    return const Text('');
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      _attendanceData[index]["month"],
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 25,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}%',
                    style: GoogleFonts.inter(
                      fontSize: 8,
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w500,
                    ),
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
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: _attendanceData.asMap().entries.map((e) {
                return FlSpot(e.key.toDouble(), e.value["present"].toDouble());
              }).toList(),
              isCurved: true,
              color: tealAccent,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 3,
                    color: Colors.white,
                    strokeWidth: 2,
                    strokeColor: tealAccent,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: tealAccent.withValues(alpha: 0.1),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              // tooltipBgColor: primaryColor,
              // tooltipRoundedRadius: 8,
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((touchedSpot) {
                  int index = touchedSpot.spotIndex;
                  return LineTooltipItem(
                    "${_attendanceData[index]["month"]}\n${touchedSpot.y.toInt()}%",
                    TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      fontFamily: 'Inter',
                    ),
                  );
                }).toList();
              },
            ),
            handleBuiltInTouches: true,
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleList() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _scheduleData.length,
        itemBuilder: (context, index) {
          final schedule = _scheduleData[index];
          return Bounceable(
            onTap: () => _showScheduleDetail(),
            child: Container(
              width: 100,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: schedule['accent'].withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getScheduleIcon(schedule['type']),
                      color: schedule['accent'],
                      size: 16,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    schedule['date'],
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    schedule['title'],
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getScheduleIcon(String type) {
    switch (type) {
      case 'Quiz':
        return Icons.quiz_rounded;
      case 'Lab':
        return Icons.science_rounded;
      case 'Assignment':
        return Icons.assignment_rounded;
      case 'Meeting':
        return Icons.group_rounded;
      default:
        return Icons.event_rounded;
    }
  }

  Widget _buildSubjectList() {
    return Column(
      children: subjectsData.map((subject) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _SubjectItem(
            title: subject['name'],
            status: "${(subject['progress'] * 100).toInt()}%",
            statusColor: subject['color'],
            icon: _getSubjectIcon(subject['name']),
            color: subject['color'],
            teacher: subject['teacher'],
            room: subject['room'],
            schedule: subject['schedule'],
            grade: subject['grade'],
            onTap: () => _showSubjectDetail(subject),
          ),
        );
      }).toList(),
    );
  }

  IconData _getSubjectIcon(String subject) {
    switch (subject) {
      case 'Mathematics':
        return Icons.calculate_rounded;
      case 'Physics':
        return Icons.bolt_rounded;
      case 'Khmer Literature':
        return Icons.menu_book_rounded;
      default:
        return Icons.school_rounded;
    }
  }

  void _showAttendanceGraph() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'Attendance History',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: tealAccent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: tealAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Present',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 100,
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        // tooltipColor: primaryColor,
                        // tooltipRoundedRadius: 8,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            "${_attendanceData[groupIndex]["month"]}\n${rod.toY.toInt()}%",
                            TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              fontFamily: 'Inter',
                            ),
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 20,
                          getTitlesWidget: (value, meta) {
                            int index = value.toInt();
                            if (index < 0 || index >= _attendanceData.length) {
                              return const Text('');
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                _attendanceData[index]["month"],
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 25,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '${value.toInt()}%',
                              style: GoogleFonts.inter(
                                fontSize: 9,
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.w500,
                              ),
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
                      horizontalInterval: 20,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: const Color(0xFFF3F6F8),
                        strokeWidth: 1,
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: _attendanceData.asMap().entries.map((e) {
                      return BarChartGroupData(
                        x: e.key,
                        barRods: [
                          BarChartRodData(
                            toY: e.value["present"],
                            color: tealAccent,
                            width: 16,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: 100,
                              color: const Color(0xFFF3F6F8),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showScheduleDetail() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'April 2024 Schedule',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _scheduleData.length,
                itemBuilder: (context, index) {
                  final schedule = _scheduleData[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F6F8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: schedule['accent'].withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              schedule['date'],
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: schedule['accent'],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                schedule['title'],
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: primaryColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: schedule['accent'].withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  schedule['type'],
                                  style: GoogleFonts.inter(
                                    color: schedule['accent'],
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSubjectDetail(Map<String, dynamic> subject) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                physics: const BouncingScrollPhysics(),
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: subject['color'].withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          _getSubjectIcon(subject['name']),
                          color: subject['color'],
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              subject['name'],
                              style: GoogleFonts.outfit(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              subject['teacher'],
                              style: GoogleFonts.inter(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F6F8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildInfoChip(
                              Icons.access_time_rounded,
                              subject['schedule'],
                            ),
                            _buildInfoChip(Icons.room_rounded, subject['room']),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(color: Color(0xFFE2E8F0)),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem('Present', '${subject['present']}'),
                            _buildStatItem('Absent', '${subject['absent']}'),
                            _buildStatItem('Late', '${subject['late']}'),
                            _buildStatItem(
                              'Permission',
                              '${subject['permission']}',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Performance Overview',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Current Grade',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              subject['grade'],
                              style: GoogleFonts.outfit(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: subject['color'],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: subject['progress'],
                            minHeight: 8,
                            backgroundColor: const Color(0xFFF3F6F8),
                            color: subject['color'],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "${(subject['progress'] * 100).toInt()}% Completion",
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: subject['color'],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAllSubjects() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'All Subjects',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: subjectsData.length,
                itemBuilder: (context, index) {
                  final subject = subjectsData[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Bounceable(
                      onTap: () {
                        Navigator.pop(context);
                        _showSubjectDetail(subject);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: subject['color'].withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _getSubjectIcon(subject['name']),
                                color: subject['color'],
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    subject['name'],
                                    style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: primaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    subject['teacher'],
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "${(subject['progress'] * 100).toInt()}%",
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: subject['color'],
                                  ),
                                ),
                                Text(
                                  subject['grade'],
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade500),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 11, color: Colors.grey.shade500),
        ),
      ],
    );
  }
}

// --- Helper Components ---

class _SubjectItem extends StatelessWidget {
  final String title, status, teacher, room, schedule, grade;
  final Color statusColor, color;
  final IconData icon;
  final VoidCallback onTap;

  const _SubjectItem({
    required this.title,
    required this.status,
    required this.statusColor,
    required this.icon,
    required this.color,
    required this.teacher,
    required this.room,
    required this.schedule,
    required this.grade,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: const Color(0xFF0D3B66),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 10,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        schedule,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    status,
                    style: GoogleFonts.inter(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    grade,
                    style: GoogleFonts.inter(
                      color: Colors.grey.shade500,
                      fontSize: 10,
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
}
