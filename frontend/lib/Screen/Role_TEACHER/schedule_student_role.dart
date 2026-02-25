import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tamdansers/Screen/Role_TEACHER/schedule_detail_role.dart';
import 'package:tamdansers/services/api_service.dart';
import 'package:tamdansers/services/api_models.dart';

class TeacherScheduleScreen extends StatefulWidget {
  const TeacherScheduleScreen({super.key});

  @override
  State<TeacherScheduleScreen> createState() => _TeacherScheduleScreenState();
}

class _TeacherScheduleScreenState extends State<TeacherScheduleScreen> {
  int _selectedDateIndex = DateTime.now().weekday - 1; // default to today

  // API data
  List<ScheduleDto> _schedules = [];
  bool _isLoading = true;

  // Days of the week (Mon–Sun) for the horizontal selector
  List<Map<String, String>> get _weekDays {
    final now = DateTime.now();
    // Start from Monday of current week
    final monday = now.subtract(Duration(days: now.weekday - 1));
    return List.generate(7, (i) {
      final day = monday.add(Duration(days: i));
      const abbr = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
      return {'day': abbr[i], 'date': day.day.toString()};
    });
  }

  static const List<Color> _accentColors = [
    Color(0xFF4A90E2),
    Color(0xFF50E3C2),
    Color(0xFFFFB75E),
    Color(0xFFB86DFF),
    Color(0xFFFF6B6B),
  ];

  @override
  void initState() {
    super.initState();
    _loadSchedule();
  }

  Future<void> _loadSchedule() async {
    setState(() => _isLoading = true);
    try {
      final api = ApiService();
      final entityId = await api.getEntityId();
      if (entityId != null && entityId.isNotEmpty) {
        final schedules = await api.getTeacherSchedule(entityId);
        if (mounted) setState(() => _schedules = schedules);
      }
    } catch (_) {}
    if (mounted) setState(() => _isLoading = false);
  }

  String get _selectedDayName {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    if (_selectedDateIndex >= 0 && _selectedDateIndex < days.length) {
      return days[_selectedDateIndex];
    }
    return days[0];
  }

  List<ScheduleDto> get _filteredSchedules {
    return _schedules
        .where((s) => s.day.toLowerCase() == _selectedDayName.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F8),
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
          'Teaching Schedule',
          style: GoogleFonts.outfit(
            color: const Color(0xFF0D3B66),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.calendar_month_rounded,
              color: Color(0xFF0D3B66),
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Month and Date Info
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_monthName(DateTime.now().month)} ${DateTime.now().year}',
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0D3B66),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_filteredSchedules.length} Classes Today',
                      style: GoogleFonts.inter(
                        color: Colors.grey.shade500,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF95738).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'This Week',
                    style: GoogleFonts.inter(
                      color: const Color(0xFFF95738),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. Horizontal Date Selector
          _buildModernHorizontalCalendar(),
          const SizedBox(height: 30),

          // 3. Timeline of Classes
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF0D3B66),
                    ),
                  )
                : _filteredSchedules.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.event_available_rounded,
                                size: 48, color: Colors.grey.shade300),
                            const SizedBox(height: 12),
                            Text(
                              'No classes on $_selectedDayName',
                              style: GoogleFonts.outfit(
                                color: Colors.grey.shade400,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: _filteredSchedules.length + 1,
                        itemBuilder: (context, index) {
                          if (index == _filteredSchedules.length) {
                            return const SizedBox(height: 40);
                          }
                          final s = _filteredSchedules[index];
                          final isFirst = index == 0;
                          final isLast = index == _filteredSchedules.length - 1;
                          final accent = _accentColors[index % _accentColors.length];
                          return _buildModernScheduleItem(
                            time: s.time,
                            className: s.classroomName,
                            subject: s.subjectName,
                            room: s.classroomName,
                            isActive: isFirst,
                            accentColor: accent,
                            isLast: isLast,
                            scheduleDto: s,
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const names = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return names[(month - 1).clamp(0, 11)];
  }

  Widget _buildModernHorizontalCalendar() {
    final days = _weekDays; // computed from current Monday

    return SizedBox(
      height: 95,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: days.length,
        itemBuilder: (context, index) {
          bool isSelected = _selectedDateIndex == index;
          return Bounceable(
            onTap: () {
              setState(() => _selectedDateIndex = index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 70,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [Color(0xFF0D3B66), Color(0xFF1E5B94)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isSelected ? null : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isSelected ? Colors.transparent : Colors.grey.shade200,
                  width: 1.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF0D3B66).withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.01),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    days[index]['day']!,
                    style: GoogleFonts.inter(
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.8)
                          : Colors.grey.shade500,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    days[index]['date']!,
                    style: GoogleFonts.outfit(
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF0D3B66),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
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

  Widget _buildModernScheduleItem({
    required String time,
    required String className,
    required String subject,
    required String room,
    required bool isActive,
    required Color accentColor,
    bool isLast = false,
    ScheduleDto? scheduleDto,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left Timeline Graphics
          SizedBox(
            width: 30,
            child: Column(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isActive ? accentColor : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isActive
                          ? accentColor.withValues(alpha: 0.3)
                          : Colors.grey.shade300,
                      width: isActive ? 4 : 2,
                    ),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: accentColor.withValues(alpha: 0.4),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: isActive
                      ? Center(
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      : null,
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: isActive
                          ? accentColor.withValues(alpha: 0.3)
                          : Colors.grey.shade200,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Content Card
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      time,
                      style: GoogleFonts.inter(
                        color: isActive ? accentColor : Colors.grey.shade500,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (isActive)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Ongoing',
                          style: GoogleFonts.inter(
                            color: accentColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Bounceable(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TeacherScheduleDetailScreen(
                          classData: {
                            'title': subject,
                            'time': time,
                            'room': room,
                            'accent': accentColor,
                            'isDone': !isActive,
                            'isCurrent': isActive,
                            'topic': '$subject - Today\'s Lesson',
                            'students': 25,
                            'classroomId': scheduleDto?.classroomId ?? '',
                            'subtitle': '$className • Room $room',
                            'description':
                                'Continue with the current lesson plan for $subject.',
                            'homework':
                                'Review notes and complete assigned exercises.',
                            'materials': <String>[],
                          },
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 30),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isActive
                            ? accentColor.withValues(alpha: 0.5)
                            : Colors.grey.shade100,
                        width: isActive ? 1.5 : 1,
                      ),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: accentColor.withValues(alpha: 0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ]
                          : [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                subject,
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: const Color(0xFF0D3B66),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.people_alt_rounded,
                                    size: 14,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    className,
                                    style: GoogleFonts.inter(
                                      color: Colors.grey.shade500,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F6F8),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Room',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                room,
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF0D3B66),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

  Widget _buildModernBreakDivider() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 30,
            child: Column(
              children: [
                Expanded(
                  child: Container(width: 2, color: Colors.grey.shade200),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(color: Colors.grey.shade300, thickness: 1),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.restaurant_rounded,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Lunch Break',
                          style: GoogleFonts.inter(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Divider(color: Colors.grey.shade300, thickness: 1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
