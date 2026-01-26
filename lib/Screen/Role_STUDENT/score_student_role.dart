import 'package:flutter/material.dart';

class StudentScoreScreen extends StatelessWidget {
  const StudentScoreScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // Primary Teal Color from your designs
    const Color primaryTeal = Color(0xFF007A7C);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'លទ្ធផលសិក្សា',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Overall Grade Summary Card
            _buildOverallGradeCard(primaryTeal),
            const SizedBox(height: 20),

            // 2. Score Breakdown Section
            const Text(
              'ព័ត៌មានលម្អិតនៃពិន្ទុ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildScoreItem(
              Icons.calendar_today_outlined,
              'ពិន្ទុវត្តមាន',
              'Attendance (10%)',
              '10',
              Colors.blue.shade50,
              Colors.blue,
            ),
            _buildScoreItem(
              Icons.book_outlined,
              'ពិន្ទុកិច្ចការផ្ទះ',
              'Homework (30%)',
              '28',
              Colors.orange.shade50,
              Colors.orange,
            ),
            _buildScoreItem(
              Icons.edit_note_outlined,
              'ពិន្ទុប្រឡង',
              'Exam (60%)',
              '54',
              Colors.purple.shade50,
              Colors.purple,
            ),

            const SizedBox(height: 25),

            // 3. Grade Range Table
            const Text(
              'តារាងកម្រិតនិទ្ទេស',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildGradeTable(),

            const SizedBox(height: 30),

            // 4. Download Report Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.file_download_outlined,
                  color: Colors.white,
                ),
                label: const Text(
                  'ទាញយកព្រឹត្តិបត្រពិន្ទុ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryTeal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(primaryTeal),
    );
  }

  Widget _buildOverallGradeCard(Color primaryColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Column(
                children: [
                  Text(
                    'និទ្ទេសសរុប',
                    style: TextStyle(
                      color: Color(0xFF007A7C),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'A',
                    style: TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF007A7C),
                    ),
                  ),
                  Text(
                    'ល្អប្រសើរ',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 40),
              Icon(
                Icons.school_outlined,
                size: 80,
                color: Colors.grey.shade200,
              ),
            ],
          ),
          const Divider(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ពិន្ទុសរុប (TOTAL SCORE)',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: '92',
                      style: TextStyle(
                        color: Color(0xFF007A7C),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '/100',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: 0.92,
            minHeight: 10,
            backgroundColor: Colors.grey.shade100,
            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            borderRadius: BorderRadius.circular(5),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreItem(
    IconData icon,
    String title,
    String subtitle,
    String score,
    Color bgColor,
    Color iconColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            score,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF007A7C),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Table(
        children: [
          _buildTableRow('A (ល្អប្រសើរ)', '90 - 100', isHeader: true),
          _buildTableRow('B (ល្អណាស់)', '80 - 89'),
          _buildTableRow('C (ល្អ)', '70 - 79'),
          _buildTableRow('D (មធ្យមបង្គួរ)', '60 - 69'),
          _buildTableRow('E (មធ្យម)', '50 - 59'),
          _buildTableRow('F (ធ្លាក់)', 'ក្រោម 50', isLast: true),
        ],
      ),
    );
  }

  TableRow _buildTableRow(
    String grade,
    String range, {
    bool isHeader = false,
    bool isLast = false,
  }) {
    return TableRow(
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            grade,
            style: TextStyle(
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              color: isHeader ? const Color(0xFF007A7C) : Colors.black87,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            range,
            textAlign: TextAlign.right,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav(Color color) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 1, // Highlight 'Results'
      selectedItemColor: color,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'ទំព័រដើម',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'លទ្ធផល'),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined),
          label: 'កាលវិភាគ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: 'សារ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'ប្រវត្តិរូប',
        ),
      ],
    );
  }
}
