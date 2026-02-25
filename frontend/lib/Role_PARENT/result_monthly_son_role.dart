import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: StudentReportScreen()));

class StudentReportScreen extends StatefulWidget {
  const StudentReportScreen({super.key});

  @override
  State<StudentReportScreen> createState() => _StudentReportScreenState();
}

class _StudentReportScreenState extends State<StudentReportScreen> {
  int _pageIndex = 1; // Default to Report tab
  final Color primaryTeal = const Color(0xFF007A8C);

  // List of screens for navigation
  late final List<Widget> _screens = [
    const Center(child: Text("Home")),
    _buildReportContent(), // Your original report UI
    const Center(child: Text("Attendance")),
    const Center(child: Text("Messages")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
          _pageIndex ==
              1 // Only show app bar on the report tab
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
                'Monthly Score Report',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              centerTitle: true,
              actions: [
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'download',
                    style: TextStyle(color: Color(0xFF007A8C)),
                  ),
                ),
              ],
            )
          : null,
      body: IndexedStack(index: _pageIndex, children: _screens),
      bottomNavigationBar: CurvedNavigationBar(
        index: _pageIndex,
        height: 60.0,
        items: const <Widget>[
          Icon(Icons.home_outlined, size: 30, color: Colors.white),
          Icon(Icons.analytics, size: 30, color: Colors.white),
          Icon(Icons.calendar_today_outlined, size: 30, color: Colors.white),
          Icon(Icons.chat_bubble_outline, size: 30, color: Colors.white),
        ],
        color: primaryTeal,
        buttonBackgroundColor: primaryTeal,
        backgroundColor: Colors.transparent, // Ensures the curve looks smooth
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

  // --- This is your original UI logic moved into a function ---
  Widget _buildReportContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          _buildHeaderSection(),
          const SizedBox(height: 25),
          _buildTopSummaryCards(),
          const SizedBox(height: 25),
          _buildGraphSection(),
          const SizedBox(height: 25),
          const Text(
            'Subject Scores',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          _buildSubjectList(),
          const SizedBox(height: 20),
          _buildPdfButton(),
          const SizedBox(height: 100), // Space for Nav Bar
        ],
      ),
    );
  }

  // --- Helper Widgets to keep code clean ---

  Widget _buildHeaderSection() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 35,
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=alex'),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Alex Johnson',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              'Grade 10 • Room B',
              style: TextStyle(color: Color(0xFF007A8C), fontSize: 14),
            ),
            Text(
              'Sep 2023',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTopSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            title: 'Average Score',
            value: '87.5%',
            subtext: '+2.5%',
            icon: Icons.star_outline,
            isTrendUp: true,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildSummaryCard(
            title: 'Attendance',
            value: '98%',
            subtext: '21/22 days',
            icon: Icons.event_available,
            isTrendUp: null,
          ),
        ),
      ],
    );
  }

  Widget _buildGraphSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Study Trends', style: TextStyle(color: Colors.grey)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text('Jul - Sep', style: TextStyle(fontSize: 10)),
              ),
            ],
          ),
          const Text(
            '3-Month Progress',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            width: double.infinity,
            child: CustomPaint(painter: WavePainter()),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [Text('Jul'), Text('Aug'), Text('Sep')],
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectList() {
    return Column(
      children: [
        _buildSubjectTile(
          'Mathematics',
          '92%',
          'A',
          Icons.calculate_outlined,
          Colors.blue,
          true,
        ),
        _buildSubjectTile(
          'English',
          '88%',
          'B+',
          Icons.menu_book,
          Colors.teal,
          null,
        ),
        _buildSubjectTile(
          'Physics',
          '74%',
          'C',
          Icons.science_outlined,
          Colors.orange,
          false,
        ),
      ],
    );
  }

  Widget _buildPdfButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryTeal, const Color(0xFF005E6B)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.picture_as_pdf, color: Colors.white),
          SizedBox(width: 10),
          Text(
            'Download Full Report (PDF)',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // --- Helper methods from your original code ---
  Widget _buildSummaryCard({
    required String title,
    required String value,
    required String subtext,
    required IconData icon,
    bool? isTrendUp,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: primaryTeal, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 4),
          Row(
            children: [
              if (isTrendUp != null)
                Icon(Icons.trending_up, color: Colors.green, size: 14),
              Text(
                subtext,
                style: TextStyle(
                  color: isTrendUp == true ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectTile(
    String title,
    String score,
    String grade,
    IconData icon,
    Color color,
    bool? isUp,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
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
                    fontSize: 16,
                  ),
                ),
                const Text(
                  'Baseline Level',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                score,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryTeal,
                ),
              ),
              Row(
                children: [
                  Text(
                    grade,
                    style: TextStyle(fontWeight: FontWeight.bold, color: color),
                  ),
                  if (isUp != null)
                    Icon(
                      isUp ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 14,
                      color: isUp ? Colors.green : Colors.red,
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// WavePainter remains the same
class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = const Color(0xFF007A8C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    var path = Path();
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.1,
      size.width * 0.5,
      size.height * 0.5,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.9,
      size.width,
      size.height * 0.2,
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
