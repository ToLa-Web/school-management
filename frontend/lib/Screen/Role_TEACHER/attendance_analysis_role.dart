import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tamdansers/services/api_service.dart';
import 'package:tamdansers/services/api_models.dart';
import 'package:tamdansers/widgets/line_graph_component.dart';

class AttendanceAnalysisScreen extends StatefulWidget {
  final String? classroomId;
  final String? classroomName;

  const AttendanceAnalysisScreen({
    super.key,
    this.classroomId,
    this.classroomName,
  });

  @override
  State<AttendanceAnalysisScreen> createState() =>
      _AttendanceAnalysisScreenState();
}

class _AttendanceAnalysisScreenState extends State<AttendanceAnalysisScreen> {
  bool _isLoading = true;
  int _present = 0;
  int _absent  = 0;
  int _late    = 0;
  int _total   = 0;
  String _todayLabel = '';

  @override
  void initState() {
    super.initState();
    _loadTodayAttendance();
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _loadTodayAttendance() async {
    if (widget.classroomId == null || widget.classroomId!.isEmpty) {
      setState(() => _isLoading = false);
      return;
    }
    try {
      final today = DateTime.now();
      _todayLabel = _formatDate(today);
      final List<AttendanceDto> records =
          await ApiService().getClassroomAttendance(widget.classroomId!, _todayLabel);
      int p = 0, a = 0, l = 0;
      for (final r in records) {
        if (r.status == 'Present') {
          p++;
        } else if (r.status == 'Absent') {
          a++;
        } else if (r.status == 'Late') {
          l++;
        }
      }
      if (mounted) {
        setState(() {
          _present   = p;
          _absent    = a;
          _late      = l;
          _total     = records.length;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.classroomName ?? 'Class';
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
          'Attendance Analysis',
          style: GoogleFonts.outfit(
            color: const Color(0xFF0D3B66),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.classroomId != null) ...[
                    Text(
                      "Today's Attendance — $name",
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0D3B66),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _todayLabel,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildTodaySummaryCard(),
                    const SizedBox(height: 32),
                  ],
                  Text(
                    'Attendance Trends',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D3B66),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildLineChartCard(),
                  const SizedBox(height: 48),
                ],
              ),
            ),
    );
  }

  Widget _buildTodaySummaryCard() {
    final total = _total > 0 ? _total : 1;
    final items = [
      {'label': 'Present', 'count': _present, 'ratio': _present / total, 'color': const Color(0xFF50E3C2)},
      {'label': 'Absent',  'count': _absent,  'ratio': _absent  / total, 'color': const Color(0xFFF95738)},
      {'label': 'Late',    'count': _late,    'ratio': _late    / total, 'color': const Color(0xFFFFB75E)},
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Students',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D3B66).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$_total',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0D3B66),
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: items.map((item) {
                return _buildBarItem(
                  item['ratio']! as double,
                  item['color']! as Color,
                  item['label']! as String,
                  item['count']! as int,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarItem(double value, Color color, String label, int count) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '$count',
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 6),
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: 48,
              height: 160,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F6F8),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              width: 48,
              height: (160 * (value > 0 ? value : 0.02)).clamp(4.0, 160.0),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildLineChartCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const RepaintBoundary(
        child: LineGraphComponent(
          maxY: 188,
          dataPoints: [35, 38, 50, 36, 90, 145, 140, 165, 120, 80, 85, 105],
          labels: [
            'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
            'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
          ],
          themeColor: Color(0xFFFF6B6B),
        ),
      ),
    );
  }
}