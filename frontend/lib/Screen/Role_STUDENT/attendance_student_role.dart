import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tamdansers/services/api_service.dart';

class AttendanceDashboard extends StatefulWidget {
  const AttendanceDashboard({super.key});

  @override
  State<AttendanceDashboard> createState() => _AttendanceDashboardState();
}

class _AttendanceDashboardState extends State<AttendanceDashboard> {
  static const Color primaryColor = Color(0xFF0D3B66);
  static const Color scaffoldBg = Color(0xFFF3F6F8);

  // State for Calendar
  DateTime _focusedDay = DateTime(2024, 4, 1);
  DateTime? _selectedDay;
  final ScrollController _scrollController = ScrollController();
  final ApiService _api = ApiService();

  // Selected period for line chart
  String _selectedPeriod = "Week";

  // Populated dynamically from attendance API (grouped by classroom)
  List<Map<String, dynamic>> subjectsData = [];

  static const List<Color> _classroomColors = [
    Color(0xFF50E3C2),
    Color(0xFFFFB75E),
    Color(0xFF4A90E2),
    Color(0xFFB86DFF),
    Color(0xFFF95738),
    Color(0xFF4A4A4A),
    Color(0xFFFF6B6B),
  ];

  // Weekly attendance data for line chart
  final Map<String, List<Map<String, dynamic>>> _weeklyAttendanceData = {
    "Week": [
      {"day": "Mon", "present": 85, "late": 5, "permission": 3, "absent": 7},
      {"day": "Tue", "present": 88, "late": 4, "permission": 2, "absent": 6},
      {"day": "Wed", "present": 92, "late": 3, "permission": 1, "absent": 4},
      {"day": "Thu", "present": 87, "late": 6, "permission": 2, "absent": 5},
      {"day": "Fri", "present": 90, "late": 4, "permission": 3, "absent": 3},
      {"day": "Sat", "present": 95, "late": 2, "permission": 1, "absent": 2},
    ],
    "Month": [
      {"day": "Week 1", "present": 88, "late": 4, "permission": 2, "absent": 6},
      {"day": "Week 2", "present": 90, "late": 3, "permission": 2, "absent": 5},
      {"day": "Week 3", "present": 85, "late": 5, "permission": 3, "absent": 7},
      {"day": "Week 4", "present": 92, "late": 3, "permission": 1, "absent": 4},
    ],
  };

  final Map<DateTime, String> _attendanceRecords = {
    DateTime(2024, 4, 1): 'Present',
    DateTime(2024, 4, 2): 'Late',
    DateTime(2024, 4, 3): 'Absent',
    DateTime(2024, 4, 4): 'Permission',
    DateTime(2024, 4, 8): 'Present',
    DateTime(2024, 4, 10): 'Late',
  };

  // Computed stats from API attendance
  int _totalPresent = 0;
  int _totalAbsent = 0;
  int _totalLate = 0;

  @override
  void initState() {
    super.initState();
    _loadAttendance();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadAttendance() async {
    try {
      final entityId = await _api.getEntityId();
      if (entityId == null || entityId.isEmpty) {
        return;
      }
      final records = await _api.getStudentAttendanceHistory(entityId);
      final Map<DateTime, String> newRecords = {};
      int present = 0, absent = 0, late = 0;
      // Group by classroom name for the subject-breakdown chart
      final Map<String, Map<String, int>> classBreakdown = {};
      for (final r in records) {
        try {
          final parts = r.date.split('T').first.split('-');
          if (parts.length == 3) {
            final dt = DateTime(
              int.parse(parts[0]),
              int.parse(parts[1]),
              int.parse(parts[2]),
            );
            newRecords[dt] = r.status;
            if (r.status == 'Present') {
              present++;
            } else if (r.status == 'Absent') {
              absent++;
            } else if (r.status == 'Late') {
              late++;
            }
          }
        } catch (_) {}
        // Classroom-level breakdown
        final cName = (r.classroomName?.isNotEmpty == true) ? r.classroomName! : 'Class';
        classBreakdown.putIfAbsent(
          cName, () => {'present': 0, 'absent': 0, 'late': 0, 'permission': 0});
        final bucket = classBreakdown[cName]!;
        if (r.status == 'Present') {
          bucket['present'] = bucket['present']! + 1;
        } else if (r.status == 'Absent') {
          bucket['absent'] = bucket['absent']! + 1;
        } else if (r.status == 'Late') {
          bucket['late'] = bucket['late']! + 1;
        } else if (r.status == 'Permission') {
          bucket['permission'] = bucket['permission']! + 1;
        }
      }
      // Build subjectsData from classroom breakdown (fall back to static list if API empty)
      final List<Map<String, dynamic>> newSubjects = [];
      int colorIdx = 0;
      for (final entry in classBreakdown.entries) {
        final counts = entry.value;
        final p  = counts['present']!;
        final a  = counts['absent']!;
        final l  = counts['late']!;
        final pe = counts['permission']!;
        final total = p + a + l + pe;
        newSubjects.add({
          'name':       entry.key,
          'progress':   total > 0 ? p / total : 0.0,
          'color':      _classroomColors[colorIdx % _classroomColors.length],
          'present':    p,
          'absent':     a,
          'late':       l,
          'permission': pe,
          'total':      total,
        });
        colorIdx++;
      }
      if (mounted) {
        setState(() {
          _attendanceRecords
            ..clear()
            ..addAll(newRecords);
          _totalPresent = present;
          _totalAbsent = absent;
          _totalLate = late;
          if (newSubjects.isNotEmpty) subjectsData = newSubjects;
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF0D3B66),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Attendance',
          style: GoogleFonts.outfit(
            color: const Color(0xFF0D3B66),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _buildModernAttendanceHome(),
    );
  }

  Widget _buildModernAttendanceHome() {
    return SingleChildScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildModernSummaryCard(),
          const SizedBox(height: 25),
          _buildModernSectionHeader(
            "Attendance Trend",
            "Details",
            onTrailingTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AttendanceDetailPage(
                    subjects: subjectsData,
                    themeColor: primaryColor,
                    getProgress: (sub) => sub["progress"],
                    weeklyData: _weeklyAttendanceData,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildModernLineChart(),
          const SizedBox(height: 25),
          _buildModernSectionHeader(
            "Academic Calendar",
            DateFormat('MMMM yyyy').format(_focusedDay),
            onTrailingTap: () => _selectCalendarDate(context),
          ),
          const SizedBox(height: 16),
          _buildModernInteractiveCalendar(),
          const SizedBox(height: 25),
          _buildModernSectionHeader(
            "Subject Progress",
            "See All",
            onTrailingTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubjectListPage(
                    subjects: subjectsData,
                    themeColor: primaryColor,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildModernHorizontalSubjectProgress(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildModernSummaryCard() {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF0D3B66), Color(0xFF1E5B94)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D3B66).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "AVERAGE ATTENDANCE",
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Keep it up,\nSophal!",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Bounceable(
              onTap: () => _scrollController.animateTo(
                200,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 65,
                    height: 65,
                    child: Builder(builder: (context) {
                      final total = _totalPresent + _totalAbsent + _totalLate;
                      final rate = total > 0 ? _totalPresent / total : 0.95;
                      return CircularProgressIndicator(
                        value: rate,
                        strokeWidth: 6,
                        backgroundColor: Colors.white12,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF50E3C2),
                        ),
                      );
                    }),
                  ),
                  Builder(builder: (context) {
                    final total = _totalPresent + _totalAbsent + _totalLate;
                    final rate = total > 0 ? _totalPresent / total : 0.95;
                    return Text(
                      '${(rate * 100).toStringAsFixed(0)}%',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernSectionHeader(
    String title,
    String trailing, {
    VoidCallback? onTrailingTap,
  }) {
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
              color: const Color(0xFF0D3B66),
            ),
          ),
          Bounceable(
            onTap: onTrailingTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF4A90E2).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                trailing,
                style: GoogleFonts.inter(
                  color: const Color(0xFF4A90E2),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Modern Line Chart with clickable points
  Widget _buildModernLineChart() {
    final currentData = _weeklyAttendanceData[_selectedPeriod]!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Period selector
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildPeriodChip("Week"),
              const SizedBox(width: 8),
              _buildPeriodChip("Month"),
            ],
          ),
          const SizedBox(height: 16),

          // Line chart
          RepaintBoundary(
            child: SizedBox(
              height: 200,
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
                      reservedSize: 22,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index < 0 || index >= currentData.length) {
                          return const Text('');
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            currentData[index]["day"],
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
                      reservedSize: 30,
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
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  // Present line
                  LineChartBarData(
                    spots: currentData.asMap().entries.map((e) {
                      return FlSpot(
                        e.key.toDouble(),
                        (e.value["present"] as num).toDouble(),
                      );
                    }).toList(),
                    isCurved: true,
                    color: const Color(0xFF50E3C2),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: const Color(0xFF50E3C2),
                        );
                      },
                    ),
                    belowBarData: BarAreaData(show: false),
                  ),
                  // Late line
                  LineChartBarData(
                    spots: currentData.asMap().entries.map((e) {
                      return FlSpot(
                        e.key.toDouble(),
                        (e.value["late"] as num).toDouble(),
                      );
                    }).toList(),
                    isCurved: true,
                    color: const Color(0xFFFFB75E),
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 3,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: const Color(0xFFFFB75E),
                        );
                      },
                    ),
                    belowBarData: BarAreaData(show: false),
                  ),
                  // Permission line
                  LineChartBarData(
                    spots: currentData.asMap().entries.map((e) {
                      return FlSpot(
                        e.key.toDouble(),
                        (e.value["permission"] as num).toDouble(),
                      );
                    }).toList(),
                    isCurved: true,
                    color: const Color(0xFF4A90E2),
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 3,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: const Color(0xFF4A90E2),
                        );
                      },
                    ),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                      return touchedSpots.map((touchedSpot) {
                        int index = touchedSpot.spotIndex;
                        String type = "";
                        Color tooltipColor = Colors.white;

                        if (touchedSpot.barIndex == 0) {
                          type = "Present";
                          tooltipColor = const Color(0xFF50E3C2);
                        } else if (touchedSpot.barIndex == 1) {
                          type = "Late";
                          tooltipColor = const Color(0xFFFFB75E);
                        } else {
                          type = "Permission";
                          tooltipColor = const Color(0xFF4A90E2);
                        }

                        return LineTooltipItem(
                          "${currentData[index]["day"]}\n$type: ${touchedSpot.y.toInt()}%",
                          TextStyle(
                            color: tooltipColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            fontFamily: 'Inter',
                          ),
                          children: [
                            TextSpan(
                              text: "\nTap for details",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 9,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        );
                      }).toList();
                    },
                  ),
                  handleBuiltInTouches: true,
                  touchCallback:
                      (FlTouchEvent event, LineTouchResponse? response) {
                        if (event is FlTapUpEvent &&
                            response != null &&
                            response.lineBarSpots != null &&
                            response.lineBarSpots!.isNotEmpty) {
                          final spot = response.lineBarSpots!.first;
                          int index = spot.spotIndex;
                          if (index >= 0 && index < currentData.length) {
                            String type = spot.barIndex == 0
                                ? "Present"
                                : spot.barIndex == 1
                                ? "Late"
                                : "Permission";

                            _showAttendanceDetailDialog(
                              context,
                              currentData[index]['day'] ?? '',
                              type,
                              spot.y.toInt(),
                              currentData[index],
                            );
                          }
                        }
                      },
                ),
              ),
            ),
          ),
          ),

          const SizedBox(height: 16),

          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem("Present", const Color(0xFF50E3C2)),
              const SizedBox(width: 16),
              _buildLegendItem("Late", const Color(0xFFFFB75E)),
              const SizedBox(width: 16),
              _buildLegendItem("Permission", const Color(0xFF4A90E2)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodChip(String period) {
    final isSelected = _selectedPeriod == period;
    return Bounceable(
      onTap: () => setState(() => _selectedPeriod = period),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0D3B66) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
          ),
        ),
        child: Text(
          period,
          style: GoogleFonts.inter(
            color: isSelected ? Colors.white : Colors.grey.shade500,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _showAttendanceDetailDialog(
    BuildContext context,
    String day,
    String type,
    int value,
    Map<String, dynamic> data,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "$day - $type",
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0D3B66),
            fontSize: 18,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailStat(
              "Present",
              "${data["present"]}",
              const Color(0xFF50E3C2),
            ),
            const SizedBox(height: 8),
            _buildDetailStat(
              "Late",
              "${data["late"]}",
              const Color(0xFFFFB75E),
            ),
            const SizedBox(height: 8),
            _buildDetailStat(
              "Permission",
              "${data["permission"]}",
              const Color(0xFF4A90E2),
            ),
            const SizedBox(height: 8),
            _buildDetailStat(
              "Absent",
              "${data["absent"]}",
              const Color(0xFFFF6B6B),
            ),
          ],
        ),
        actions: [
          Bounceable(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F6F8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Close",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailStat(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Future<void> _selectCalendarDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _focusedDay,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDatePickerMode: DatePickerMode.year,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0D3B66),
              onPrimary: Colors.white,
              onSurface: Color(0xFF0D3B66),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _focusedDay) {
      setState(() {
        _focusedDay = picked;
      });
    }
  }

  Widget _buildModernInteractiveCalendar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: const Color(0xFF0D3B66),
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade500,
                fontSize: 11,
              ),
              weekendStyle: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFF6B6B),
                fontSize: 11,
              ),
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              _showAttendanceStatus(selectedDay);
            },
            calendarStyle: CalendarStyle(
              defaultTextStyle: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey.shade700,
              ),
              weekendTextStyle: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFFFF6B6B),
              ),
              selectedDecoration: const BoxDecoration(
                color: Color(0xFF0D3B66),
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: const Color(0xFF4A90E2).withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final date = DateTime(day.year, day.month, day.day);
                if (_attendanceRecords.containsKey(date)) {
                  String status = _attendanceRecords[date]!;
                  return Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: _getStatusColor(status).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: GoogleFonts.inter(
                          color: _getStatusColor(status),
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  );
                }
                return SizedBox(
                  width: 32,
                  height: 32,
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: GoogleFonts.inter(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF3F6F8)),
          const SizedBox(height: 12),
          _buildModernCalendarLegend(),
        ],
      ),
    );
  }

  Widget _buildModernCalendarLegend() {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        _legendItem("Present", const Color(0xFF50E3C2)),
        _legendItem("Late", const Color(0xFFFFB75E)),
        _legendItem("Permission", const Color(0xFF4A90E2)),
        _legendItem("Absent", const Color(0xFFFF6B6B)),
      ],
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Present':
        return const Color(0xFF50E3C2);
      case 'Absent':
        return const Color(0xFFFF6B6B);
      case 'Late':
        return const Color(0xFFFFB75E);
      case 'Permission':
        return const Color(0xFF4A90E2);
      default:
        return Colors.grey.shade400;
    }
  }

  void _showAttendanceStatus(DateTime date) {
    final status =
        _attendanceRecords[DateTime(date.year, date.month, date.day)] ??
        "No Record";
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          DateFormat('EEEE, MMM d').format(date),
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0D3B66),
            fontSize: 16,
          ),
        ),
        content: Text(
          "Status: $status",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: _getStatusColor(status),
            fontSize: 14,
          ),
        ),
        actions: [
          Bounceable(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F6F8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Close",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernHorizontalSubjectProgress() {
    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: subjectsData.length,
        itemBuilder: (context, index) {
          final sub = subjectsData[index];
          return Bounceable(
            onTap: () => showSubjectDetail(context, sub, primaryColor),
            child: Container(
              width: 130,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: sub["color"].withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.menu_book_rounded,
                      color: sub["color"],
                      size: 16,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    sub["name"],
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: const Color(0xFF0D3B66),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: sub["progress"],
                      color: sub["color"],
                      backgroundColor: const Color(0xFFF3F6F8),
                      minHeight: 4,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static void showSubjectDetail(
    BuildContext context,
    Map<String, dynamic> sub,
    Color themeColor,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: sub["color"].withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.menu_book_rounded,
                      color: sub["color"],
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      sub["name"],
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0D3B66),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: Color(0xFFF3F6F8)),
              const SizedBox(height: 8),
              _buildCompactDetailRow("Total Sessions", "${sub["total"]}"),
              _buildCompactDetailRow(
                "Present",
                "${sub["present"]}",
                color: const Color(0xFF50E3C2),
              ),
              _buildCompactDetailRow(
                "Late",
                "${sub["late"]}",
                color: const Color(0xFFFFB75E),
              ),
              _buildCompactDetailRow(
                "Permission",
                "${sub["permission"]}",
                color: const Color(0xFF4A90E2),
              ),
              _buildCompactDetailRow(
                "Absent",
                "${sub["absent"]}",
                color: const Color(0xFFFF6B6B),
              ),
              const SizedBox(height: 20),
              Bounceable(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F6F8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      "Close",
                      style: GoogleFonts.outfit(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildCompactDetailRow(
    String label,
    String value, {
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color ?? const Color(0xFF0D3B66),
            ),
          ),
        ],
      ),
    );
  }
}

// --- SUBJECT LIST PAGE ---
class SubjectListPage extends StatefulWidget {
  final List<Map<String, dynamic>> subjects;
  final Color themeColor;
  const SubjectListPage({
    super.key,
    required this.subjects,
    required this.themeColor,
  });
  @override
  State<SubjectListPage> createState() => _SubjectListPageState();
}

class _SubjectListPageState extends State<SubjectListPage> {
  late List<Map<String, dynamic>> filteredSubjects;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredSubjects = widget.subjects;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterList(String val) {
    setState(() {
      filteredSubjects = widget.subjects
          .where((s) => s["name"].toLowerCase().contains(val.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F8),
      appBar: AppBar(
        title: Text(
          "Subject Progress",
          style: GoogleFonts.outfit(
            color: const Color(0xFF0D3B66),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF0D3B66),
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filterList,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF0D3B66),
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: "Search subject...",
                  hintStyle: GoogleFonts.inter(
                    color: Colors.grey.shade400,
                    fontSize: 13,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Colors.grey.shade400,
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              itemCount: filteredSubjects.length,
              itemBuilder: (context, index) {
                final sub = filteredSubjects[index];
                return Bounceable(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubjectDetailScreen(
                          subject: sub,
                          themeColor: widget.themeColor,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
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
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: sub["color"].withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.book_rounded,
                            color: sub["color"],
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sub["name"],
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: const Color(0xFF0D3B66),
                                ),
                              ),
                              const SizedBox(height: 4),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: sub["progress"],
                                  color: sub["color"],
                                  backgroundColor: const Color(0xFFF3F6F8),
                                  minHeight: 4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "${(sub["progress"] * 100).toInt()}%",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            color: sub["color"],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
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

class SubjectDetailScreen extends StatelessWidget {
  final Map<String, dynamic> subject;
  final Color themeColor;

  const SubjectDetailScreen({
    super.key,
    required this.subject,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    int present = subject['present'];
    int absent = subject['absent'];
    int late = subject['late'];
    int permission = subject['permission'];
    int total = subject['total'];
    double progress = subject['progress'];

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F8),
      appBar: AppBar(
        title: Text(
          subject['name'],
          style: GoogleFonts.outfit(
            color: const Color(0xFF0D3B66),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF0D3B66),
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Attendance Summary",
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D3B66),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildStatRow("Total Sessions", "$total", null),
                  _buildStatRow("Present", "$present", const Color(0xFF50E3C2)),
                  _buildStatRow("Late", "$late", const Color(0xFFFFB75E)),
                  _buildStatRow(
                    "Permission",
                    "$permission",
                    const Color(0xFF4A90E2),
                  ),
                  _buildStatRow("Absent", "$absent", const Color(0xFFFF6B6B)),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(color: Color(0xFFF3F6F8)),
                  ),
                  _buildStatRow(
                    "Attendance Rate",
                    "${(progress * 100).toStringAsFixed(1)}%",
                    subject['color'],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Overall Progress",
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D3B66),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                      backgroundColor: const Color(0xFFF3F6F8),
                      color: subject['color'],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "${(progress * 100).toInt()}% Completion",
                      style: GoogleFonts.inter(
                        color: subject['color'],
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
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

  Widget _buildStatRow(String label, String value, Color? color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color ?? const Color(0xFF0D3B66),
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
  final Map<String, List<Map<String, dynamic>>> weeklyData;

  const AttendanceDetailPage({
    super.key,
    required this.subjects,
    required this.themeColor,
    required this.getProgress,
    required this.weeklyData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F8),
      appBar: AppBar(
        title: Text(
          "Attendance Analysis",
          style: GoogleFonts.outfit(
            color: const Color(0xFF0D3B66),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF0D3B66),
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Weekly Trend",
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0D3B66),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 250,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: RepaintBoundary(
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
                        reservedSize: 22,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          if (index < 0 ||
                              index >= weeklyData["Week"]!.length) {
                            return const Text('');
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              weeklyData["Week"]![index]["day"],
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
                        reservedSize: 30,
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
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    // Present line
                    LineChartBarData(
                      spots: weeklyData["Week"]!.asMap().entries.map((e) {
                        return FlSpot(
                          e.key.toDouble(),
                          (e.value["present"] as num).toDouble(),
                        );
                      }).toList(),
                      isCurved: true,
                      color: const Color(0xFF50E3C2),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Colors.white,
                            strokeWidth: 2,
                            strokeColor: const Color(0xFF50E3C2),
                          );
                        },
                      ),
                      belowBarData: BarAreaData(show: false),
                    ),
                    // Late line
                    LineChartBarData(
                      spots: weeklyData["Week"]!.asMap().entries.map((e) {
                        return FlSpot(
                          e.key.toDouble(),
                          (e.value["late"] as num).toDouble(),
                        );
                      }).toList(),
                      isCurved: true,
                      color: const Color(0xFFFFB75E),
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 3,
                            color: Colors.white,
                            strokeWidth: 2,
                            strokeColor: const Color(0xFFFFB75E),
                          );
                        },
                      ),
                      belowBarData: BarAreaData(show: false),
                    ),
                    // Permission line
                    LineChartBarData(
                      spots: weeklyData["Week"]!.asMap().entries.map((e) {
                        return FlSpot(
                          e.key.toDouble(),
                          (e.value["permission"] as num).toDouble(),
                        );
                      }).toList(),
                      isCurved: true,
                      color: const Color(0xFF4A90E2),
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 3,
                            color: Colors.white,
                            strokeWidth: 2,
                            strokeColor: const Color(0xFF4A90E2),
                          );
                        },
                      ),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (List<LineBarSpot> touchedSpots) {
                        return touchedSpots.map((touchedSpot) {
                          int index = touchedSpot.spotIndex;
                          String type = "";
                          Color tooltipColor = Colors.white;

                          if (touchedSpot.barIndex == 0) {
                            type = "Present";
                            tooltipColor = const Color(0xFF50E3C2);
                          } else if (touchedSpot.barIndex == 1) {
                            type = "Late";
                            tooltipColor = const Color(0xFFFFB75E);
                          } else {
                            type = "Permission";
                            tooltipColor = const Color(0xFF4A90E2);
                          }

                          return LineTooltipItem(
                            "${weeklyData["Week"]![index]["day"]}\n$type: ${touchedSpot.y.toInt()}%",
                            TextStyle(
                              color: tooltipColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              fontFamily: 'Inter',
                            ),
                          );
                        }).toList();
                      },
                    ),
                    handleBuiltInTouches: true,
                    touchCallback:
                        (FlTouchEvent event, LineTouchResponse? response) {
                          if (event is FlTapUpEvent &&
                              response != null &&
                              response.lineBarSpots != null &&
                              response.lineBarSpots!.isNotEmpty) {
                            final spot = response.lineBarSpots!.first;
                            int index = spot.spotIndex;
                            if (index >= 0 &&
                                index < weeklyData["Week"]!.length) {
                              final dayData = weeklyData["Week"]![index];
                              String type = spot.barIndex == 0
                                  ? "Present"
                                  : spot.barIndex == 1
                                  ? "Late"
                                  : "Permission";

                              _showAttendanceDetailDialog(
                                context,
                                dayData["day"],
                                type,
                                spot.y.toInt(),
                                dayData,
                              );
                            }
                          }
                        },
                  ),
                ),
              ),
            ),
            ),
            const SizedBox(height: 24),
            Text(
              "Performance by Subject",
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0D3B66),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 250,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final sub = subjects[groupIndex];
                        return BarTooltipItem(
                          "${sub['name']}\n${rod.toY.toInt()}%",
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
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) => Text(
                          "${value.toInt()}%",
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 20,
                        getTitlesWidget: (value, meta) {
                          int i = value.toInt();
                          if (i < 0 || i >= subjects.length) {
                            return const SizedBox();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              subjects[i]['name'].toString().substring(0, 3),
                              style: GoogleFonts.inter(
                                fontSize: 9,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.bold,
                              ),
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
                    getDrawingHorizontalLine: (value) =>
                        FlLine(color: const Color(0xFFF3F6F8), strokeWidth: 1),
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
                          width: 16,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6),
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
            const SizedBox(height: 24),
            Text(
              "Quick Insights",
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0D3B66),
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.2,
              children: [
                _buildCompactStatCard(
                  "Most Present",
                  "Khmer",
                  const Color(0xFF50E3C2),
                  Icons.check_circle_rounded,
                  () => _showInsightDialog(
                    context,
                    "Most Present Subject",
                    "Khmer has the highest attendance rate.\nPresent: 45 / 49 sessions (91.8%)",
                  ),
                ),
                _buildCompactStatCard(
                  "Needs Attention",
                  "Chemistry",
                  const Color(0xFFFF6B6B),
                  Icons.warning_rounded,
                  () => _showInsightDialog(
                    context,
                    "Subject Needing Improvement",
                    "Chemistry has the most absences.\nAbsent: 6 sessions • Attendance: 78%",
                  ),
                ),
                _buildCompactStatCard(
                  "Total Sessions",
                  "328",
                  const Color(0xFF4A90E2),
                  Icons.calendar_month_rounded,
                  () => _showInsightDialog(
                    context,
                    "Total Academic Sessions",
                    "You have attended or been marked in 328 sessions across all subjects.",
                  ),
                ),
                _buildCompactStatCard(
                  "Overall Rank",
                  "4th / 45",
                  const Color(0xFFFFB75E),
                  Icons.emoji_events_rounded,
                  () => _showInsightDialog(
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

  Widget _buildCompactStatCard(
    String label,
    String value,
    Color color,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Bounceable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const Spacer(),
            Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0D3B66),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showAttendanceDetailDialog(
    BuildContext context,
    String day,
    String type,
    int value,
    Map<String, dynamic> data,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "$day - $type",
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0D3B66),
            fontSize: 18,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailStat(
              "Present",
              "${data["present"]}",
              const Color(0xFF50E3C2),
            ),
            const SizedBox(height: 8),
            _detailStat("Late", "${data["late"]}", const Color(0xFFFFB75E)),
            const SizedBox(height: 8),
            _detailStat(
              "Permission",
              "${data["permission"]}",
              const Color(0xFF4A90E2),
            ),
            const SizedBox(height: 8),
            _detailStat("Absent", "${data["absent"]}", const Color(0xFFFF6B6B)),
          ],
        ),
        actions: [
          Bounceable(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F6F8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Close",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailStat(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  void _showInsightDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          title,
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0D3B66),
            fontSize: 16,
          ),
        ),
        content: Text(
          content,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: Colors.grey.shade600,
            height: 1.4,
          ),
        ),
        actions: [
          Bounceable(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F6F8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Close",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0D3B66),
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
