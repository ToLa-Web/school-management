
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class AdminReportSchool extends StatefulWidget {
  const AdminReportSchool({super.key});

  @override
  State<AdminReportSchool> createState() => _AdminReportSchoolState();
}

class _AdminReportSchoolState extends State<AdminReportSchool> {
  int _pageIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  // Color Constants
  static const Color primaryBlue = Color(0xFF1A1FB1);
  static const Color scaffoldBg = Color(0xFFF5F7FA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBg,
      body: IndexedStack(
        index: _pageIndex,
        children: [
          _buildMainReportContent(), // Index 0: The Dashboard
          const Center(child: Text("History Screen")),
          const Center(child: Text("Download Reports")),
          const Center(child: Text("Report Settings")),
        ],
      ),

      // --- CURVED NAVIGATION BAR ---
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _pageIndex,
        height: 65.0,
        items: const <Widget>[
          Icon(Icons.analytics_rounded, size: 30, color: Colors.white),
          Icon(Icons.history, size: 30, color: Colors.white),
          Icon(Icons.file_download, size: 30, color: Colors.white),
          Icon(Icons.tune, size: 30, color: Colors.white),
        ],
        color: primaryBlue,
        buttonBackgroundColor: primaryBlue,
        backgroundColor: Colors.transparent,
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

  // Refactored Main Content
  Widget _buildMainReportContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // --- HEADER SECTION ---
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 40),
            decoration: const BoxDecoration(
              color: primaryBlue,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(35)),
            ),
            child: Column(
              children: [
                _buildHeaderTopRow(),
                const SizedBox(height: 30),
                Row(
                  children: [
                    _buildCircularStat("៩២%", "អត្រាវត្តមានសរុប", 0.92),
                    const SizedBox(width: 15),
                    _buildGPAStat("៣.៨៥", "មធ្យមភាគពិន្ទុ"),
                  ],
                ),
              ],
            ),
          ),

          // --- REPORTS LIST ---
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _ReportCard(
                  title: "របាយការណ៍ហិរញ្ញវត្ថុ",
                  subtitle: "បង្ហាញស្ថានភាពថ្ងៃនេះ",
                  icon: Icons.account_balance_wallet,
                  iconColor: Colors.green,
                  chartWidget: _buildBarChart(),
                ),
                const SizedBox(height: 15),
                _ReportCard(
                  title: "ស្ថិតិសិក្សាសិស្ស",
                  subtitle: "ឆមាសទី ១",
                  icon: Icons.auto_graph,
                  iconColor: Colors.blue,
                  chartWidget: _buildLineChart(),
                ),
                const SizedBox(height: 15),
                _ReportCard(
                  title: "របាយការណ៍បុគ្គលិក",
                  subtitle: "បុគ្គលិកសរុប៖ ៨០ នាក់",
                  icon: Icons.badge,
                  iconColor: Colors.purple,
                  chartWidget: _buildProgressBar(0.85, "៨៥%"),
                ),
                const SizedBox(height: 15),
                _ReportCard(
                  title: "សកម្មភាពក្រៅម៉ោង",
                  subtitle: "១២ កម្មវិធីដែលសកម្ម",
                  icon: Icons.sports_soccer,
                  iconColor: Colors.orange,
                  chartWidget: _buildActivityIcons(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 100), // Spacing for bottom nav
        ],
      ),
    );
  }

  Widget _buildHeaderTopRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
        ),
        const Text(
          "របាយការណ៍សាលា",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.calendar_month,
            color: Colors.white,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildCircularStat(String val, String label, double progress) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 60,
                  width: 60,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.amber,
                    ),
                  ),
                ),
                Text(
                  val,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGPAStat(String val, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        height: 110,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              val,
              style: const TextStyle(
                color: Colors.amber,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  // --- CHART LOGIC ---

  Widget _buildBarChart() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _bar(20, Colors.green.withValues(alpha: 0.2)),
        _bar(40, Colors.green.withValues(alpha: 0.4)),
        _bar(30, Colors.green.withValues(alpha: 0.6)),
        _bar(60, Colors.green.withValues(alpha: 0.8)),
        _bar(50, Colors.green.withValues(alpha: 0.7)),
        _bar(80, Colors.green),
      ],
    );
  }

  Widget _bar(double height, Color color) {
    return Container(
      width: 30,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildLineChart() {
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: CustomPaint(painter: _LinePainter()),
    );
  }

  Widget _buildProgressBar(double value, String label) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 8,
            backgroundColor: Colors.purple.withValues(alpha: 0.1),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.purple),
          ),
        ),
        const SizedBox(height: 5),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _iconBox(Icons.palette),
        _iconBox(Icons.music_note),
        _iconBox(Icons.groups),
        _iconBox(Icons.science),
      ],
    );
  }

  Widget _iconBox(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 18, color: Colors.grey[600]),
    );
  }
}

// --- SUB-WIDGETS ---

class _ReportCard extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final Color iconColor;
  final Widget chartWidget;

  const _ReportCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.chartWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: iconColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Text(
                "មើលលម្អិត",
                style: TextStyle(
                  color: Color(0xFF1A1FB1),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          chartWidget,
        ],
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    var path = Path();
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.2,
      size.width * 0.5,
      size.height * 0.5,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.8,
      size.width,
      size.height * 0.1,
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
