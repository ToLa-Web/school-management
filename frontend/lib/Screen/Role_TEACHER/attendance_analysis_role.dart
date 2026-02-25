import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tamdansers/widgets/line_graph_component.dart';

class AttendanceAnalysisScreen extends StatelessWidget {
  const AttendanceAnalysisScreen({super.key});

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
          'Attendance Analysis',
          style: GoogleFonts.outfit(
            color: const Color(0xFF0D3B66),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance by Subject',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0D3B66),
              ),
            ),
            const SizedBox(height: 24),
            _buildBarChartCard(),
            const SizedBox(height: 32),
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

  Widget _buildBarChartCard() {
    final List<Map<String, dynamic>> subjectData = [
      {'sub': 'Khm', 'val': 0.97, 'color': const Color(0xFF50E3C2)},
      {'sub': 'Mat', 'val': 0.85, 'color': const Color(0xFFFFB75E)},
      {'sub': 'Phy', 'val': 0.92, 'color': const Color(0xFF4A90E2)},
      {'sub': 'Che', 'val': 0.78, 'color': const Color(0xFFB066FE)},
      {'sub': 'Bio', 'val': 0.95, 'color': const Color(0xFFF95738)},
      {'sub': 'His', 'val': 0.95, 'color': const Color(0xFF4A4A4A)},
      {'sub': 'Eng', 'val': 0.88, 'color': const Color(0xFFFF6B6B)},
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
          SizedBox(
            height: 240,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Y-Axis Labels (0% - 100% in 10% steps)
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(11, (index) {
                    int val = 100 - (index * 10);
                    return Text(
                      '$val%',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  }),
                ),
                const SizedBox(width: 12),
                // Bars
                Expanded(
                  child: Stack(
                    children: [
                      // White grid lines (Subtle)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(11, (index) {
                          return Divider(
                            color: Colors.grey.withValues(alpha: 0.05),
                            thickness: 1,
                            height: 1,
                          );
                        }),
                      ),
                      // Actual Bars with Tracks
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: subjectData.map((data) {
                          return _buildBarItem(
                            data['val'],
                            data['color'],
                            data['sub'],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarItem(double value, Color color, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Track background
            Container(
              width: 22,
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F6F8),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            // Colored Value Bar
            Container(
              width: 22,
              height: 200 * value,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
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
      child: const LineGraphComponent(
        maxY: 188, // As per design reference
        dataPoints: [35, 38, 50, 36, 90, 145, 140, 165, 120, 80, 85, 105],
        labels: [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ],
        themeColor: Color(0xFFFF6B6B),
      ),
    );
  }
}
