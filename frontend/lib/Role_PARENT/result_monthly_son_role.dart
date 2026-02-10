import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: StudentReportScreen()));

class StudentReportScreen extends StatelessWidget {
  const StudentReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back_ios, color: Color(0xFF007A8C)),
        title: const Text(
          'ព្រឹត្តិបត្រពិន្ទុប្រចាំខែ',
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // Header Section
            Row(
              children: [
                const CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/150?u=alex',
                  ),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Alex Johnson',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'ថ្នាក់ទី ១០ • បន្ទប់ B',
                      style: TextStyle(color: Color(0xFF007A8C), fontSize: 14),
                    ),
                    Text(
                      'កញ្ញា ២០២៣',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 25),

            // Top Summary Cards
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    title: 'ពិន្ទុមធ្យម',
                    value: '87.5%',
                    subtext: '+2.5%',
                    subLabel: 'ធៀបនឹងខែមុន',
                    icon: Icons.star_outline,
                    isTrendUp: true,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildSummaryCard(
                    title: 'វត្តមាន',
                    value: '98%',
                    subtext: '២១/២២ ថ្ងៃ',
                    subLabel: '',
                    icon: Icons.event_available,
                    isTrendUp: null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // Graph Section
            Container(
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
                      const Text(
                        'និន្នាការនៃការសិក្សា',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Text(
                          'កក្កដា - កញ្ញា',
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'វឌ្ឍនភាព ៣ ខែ',
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
                    children: const [
                      Text('កក្កដា'),
                      Text('សីហា'),
                      Text('កញ្ញា'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // Subject List
            const Text(
              'ពិន្ទុតាមមុខវិជ្ជា',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildSubjectTile(
              'គណិតវិទ្យា',
              '92%',
              'A',
              Icons.calculate_outlined,
              Colors.blue,
              true,
            ),
            _buildSubjectTile(
              'អក្សរសាស្ត្រអង់គ្លេស',
              '88%',
              'B+',
              Icons.menu_book,
              Colors.teal,
              null,
            ),
            _buildSubjectTile(
              'រូបវិទ្យា',
              '74%',
              'C',
              Icons.science_outlined,
              Colors.orange,
              false,
            ),
            _buildSubjectTile(
              'ប្រវត្តិវិទ្យា',
              '95%',
              'A+',
              Icons.history_edu,
              Colors.blueGrey,
              true,
            ),

            // Bottom PDF Button
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF007A8C), Color(0xFF005E6B)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.picture_as_pdf, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    'ទាញយករបាយការណ៍ទាំងស្រុង (PDF)',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF007A8C),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'ទំព័រដើម',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'របាយការណ៍',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'វត្តមាន',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'សារ',
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required String subtext,
    required String subLabel,
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
          Icon(icon, color: const Color(0xFF007A8C), size: 28),
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
                  'កម្រិតមូលដ្ឋាន',
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
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF007A8C),
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
