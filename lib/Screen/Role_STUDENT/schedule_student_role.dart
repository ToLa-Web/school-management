import 'package:flutter/material.dart';

class StudentScheduleScreen extends StatelessWidget {
  const StudentScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryTeal = Color(0xFF007A7C);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // leading: const Icon(
        //   Icons.arrow_back_ios,
        //   color: Colors.black,
        //   size: 20,
        // ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'កាលវិភាគសិក្សាប្រចាំឆ្នាំ',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.calendar_month, color: Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Term Switcher (Semester 1 / Semester 2)
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _buildTermButton('ឆមាសទី១', true, primaryTeal),
                  _buildTermButton('ឆមាសទី២', false, primaryTeal),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // 2. Weekly Schedule Title
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'កាលវិភាគប្រចាំសប្តាហ៍',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text('សប្តាហ៍ទី ១២', style: TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 15),

            // 3. Timeline Schedule List
            _buildScheduleItem(
              icon: Icons.grid_view_rounded,
              subject: 'គណិតវិទ្យា (Mathematics)',
              time: 'ថ្ងៃច័ន្ទ 08:00 - 09:30',
              room: 'បន្ទប់ 302',
              primaryColor: primaryTeal,
              isFirst: true,
            ),
            _buildScheduleItem(
              icon: Icons.science_outlined,
              subject: 'វិទ្យាសាស្ត្រ (Science)',
              time: 'ថ្ងៃច័ន្ទ 10:00 - 11:30',
              room: 'មន្ទីរពិសោធន៍',
              primaryColor: primaryTeal,
            ),
            _buildScheduleItem(
              icon: Icons.book_outlined,
              subject: 'អក្សរសាស្ត្រខ្មែរ (Khmer Literature)',
              time: 'ថ្ងៃអង្គារ 08:00 - 09:30',
              room: 'បន្ទប់ 105',
              primaryColor: primaryTeal,
            ),
            _buildScheduleItem(
              icon: Icons.public_outlined,
              subject: 'ភាសាអង់គ្លេស (English)',
              time: 'ថ្ងៃអង្គារ 10:00 - 11:30',
              room: 'បន្ទប់ ២០១',
              primaryColor: primaryTeal,
              isLast: true,
            ),

            const SizedBox(height: 25),

            // 4. Year-end Review Banner
            const Text(
              'ការរំលឹកមេរៀនចុងឆ្នាំ (Year-end Review)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildReviewBanner(primaryTeal),
          ],
        ),
      ),
    );
  }

  Widget _buildTermButton(String text, bool isActive, Color activeColor) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isActive
              ? [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 5)]
              : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? activeColor : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleItem({
    required IconData icon,
    required String subject,
    required String time,
    required String room,
    required Color primaryColor,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        children: [
          // Vertical Timeline Line
          Column(
            children: [
              Container(
                width: 2,
                height: 20,
                color: isFirst ? Colors.transparent : Colors.grey.shade300,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: primaryColor.withAlpha(100),
                    width: 2,
                  ),
                ),
                child: Icon(icon, size: 20, color: primaryColor),
              ),
              Expanded(
                child: Container(
                  width: 2,
                  color: isLast ? Colors.transparent : Colors.grey.shade300,
                ),
              ),
            ],
          ),
          const SizedBox(width: 15),
          // Subject Card
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subject,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              time,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        room,
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewBanner(Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ការត្រៀមប្រឡងឆមាស',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'រំលឹកមេរៀន និងលំហាត់ត្រៀមប្រឡងបញ្ចប់ឆ្នាំ ដើម្បីទទួលបានលទ្ធផលល្អប្រសើរ។',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('មើលមេរៀនរំលឹក'),
                SizedBox(width: 10),
                Icon(Icons.arrow_forward, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
