import 'package:flutter/material.dart';

class ParentAttendanceMonitor extends StatelessWidget {
  const ParentAttendanceMonitor({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryTeal = Color(0xFF007A7C);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'វត្តមានរបស់កូន', // Child's Attendance
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Student Profile Header
            _buildStudentHeader(),

            // 2. Attendance Overview (Circular Progress)
            _buildAttendanceOverview(primaryTeal),

            // 3. Calendar View
            _buildAttendanceCalendar(primaryTeal),

            // 4. Detailed Activity Log
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'កំណត់ចំណាំពីគ្រូ', // Teacher's Notes/Activity
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'មើលទាំងអស់',
                    style: TextStyle(color: primaryTeal, fontSize: 12),
                  ),
                ],
              ),
            ),
            _buildActivityNote(
              date: '12 តុលា',
              time: '08:15 AM',
              status: 'មកយឺត', // Late
              statusColor: Colors.orange,
              note:
                  'សិស្សមកដល់យឺតដោយសារគ្រួសារមានធុរៈចាំបាច់។ បានអនុញ្ញាតឱ្យចូលរៀនធម្មតា។',
            ),
            _buildActivityNote(
              date: '07 តុលា',
              time: 'Full Day',
              status: 'អវត្តមាន', // Absent
              statusColor: Colors.red,
              note: 'អវត្តមានដោយមានច្បាប់ឈប់សម្រាកព្យាបាលជំងឺ (គ្រុនផ្តាសាយ)។',
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(primaryTeal),
    );
  }

  Widget _buildStudentHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 35,
            backgroundImage: NetworkImage('https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?semt=ais_hybrid&w=740&q=80'),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'សុខ ចាន់ដារ៉ា',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'ថ្នាក់ទី ៨A • អត្តលេខ: 12345',
                style: TextStyle(color: Colors.blueGrey.shade400, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceOverview(Color primaryColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'សង្ខេបវត្តមានសរុប',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              Text(
                '+2%',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 150,
                width: 150,
                child: CircularProgressIndicator(
                  value: 0.95,
                  strokeWidth: 15,
                  backgroundColor: Colors.grey.shade100,
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              ),
              const Column(
                children: [
                  Text(
                    'PRESENT',
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                  Text(
                    '180 ថ្ងៃ',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat('វត្តមាន', '180', Colors.green),
              _buildStat('អវត្តមាន', '5', Colors.red),
              _buildStat('យឺត', '3', Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildAttendanceCalendar(Color primaryColor) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.chevron_left, color: Colors.grey),
              const Text(
                'តុលា 2023',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 15),
          // Placeholder for a grid calendar based on image_72b02f.png
          const Text(
            "ច័ន្ទ   អង្គារ   ពុធ   ព្រហ   សុក្រ",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 10),
          // Simplified calendar dots row example
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCalendarDay('5', Colors.white, primaryColor),
              _buildCalendarDay('6', Colors.green, Colors.transparent),
              _buildCalendarDay('7', Colors.red, Colors.transparent),
              _buildCalendarDay('8', Colors.green, Colors.transparent),
              _buildCalendarDay('11', Colors.orange, Colors.transparent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarDay(String day, Color dotColor, Color bg) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
          child: Text(
            day,
            style: TextStyle(
              color: bg == Colors.transparent ? Colors.black : Colors.white,
            ),
          ),
        ),
        if (dotColor != Colors.white)
          Container(
            height: 4,
            width: 4,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
      ],
    );
  }

  Widget _buildActivityNote({
    required String date,
    required String time,
    required String status,
    required Color statusColor,
    required String note,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Text(
                date.split(' ')[0],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                date.split(' ')[1],
                style: const TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ],
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  note,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.blueGrey,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(Color activeColor) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: activeColor,
      currentIndex: 2,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'ទំព័រដើម',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today_outlined),
          label: 'កាលវិភាគ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.check_circle),
          label: 'វត្តមាន',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'ប្រវត្តិរូប',
        ),
      ],
    );
  }
}
