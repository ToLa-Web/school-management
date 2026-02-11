import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: AttendanceScreen()));

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  // Selection State
  String selectedGrade = 'Grade 12A - Mathematics';
  String selectedDay = '24';

  // Student Data Mockup
  final List<Map<String, String>> students = [
    {'name': 'សុខ តារា', 'eng': 'Sok Dara', 'id': '18623'},
    {'name': 'ចាន់ វិទ្យា', 'eng': 'Chan Vitthyea', 'id': '18624'},
    {'name': 'កែវ បុប្ផា', 'eng': 'Keo Bopha', 'id': '18625'},
  ];


  late Map<String, String> attendanceRecords;

  @override
  void initState() {
    super.initState();
    attendanceRecords = {for (var s in students) s['id']!: 'Present'};
  }

  // Calculate Stats
  int get countPresent =>
      attendanceRecords.values.where((v) => v == 'Present').length;
  int get countAbsent =>
      attendanceRecords.values.where((v) => v == 'Absent').length;
  int get countLate =>
      attendanceRecords.values.where((v) => v == 'Late').length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Attendance Management',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.history, color: Colors.black),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeaderSection(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                final id = student['id']!;
                return StudentAttendanceCard(
                  name: student['name']!,
                  englishName: student['eng']!,
                  id: id,
                  status: attendanceRecords[id]!,
                  onStatusChanged: (newStatus) {
                    setState(() => attendanceRecords[id] = newStatus);
                  },
                );
              },
            ),
          ),
          _buildBottomSummary(),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Grade Selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedGrade,
                isExpanded: true,
                items:
                    [
                          'Grade 12A - Mathematics',
                          'Grade 11B - Physics',
                          'Grade 10C - Biology',
                        ]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: (val) => setState(() => selectedGrade = val!),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Day Picker
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDateItem('23', 'Mon'),
              _buildDateItem('24', 'Tue'),
              _buildDateItem('25', 'Wed'),
              _buildDateItem('26', 'Thu'),
              _buildDateItem('27', 'Fri'),
            ],
          ),
          const SizedBox(height: 16),
          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatBox('Total', '${students.length}', Colors.black),
              _buildStatBox('Present', '$countPresent', Colors.blue),
              _buildStatBox('Absent', '$countAbsent', Colors.red),
              _buildStatBox('Late', '$countLate', Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateItem(String day, String weekday) {
    bool isSelected = selectedDay == day;
    return GestureDetector(
      onTap: () => setState(() => selectedDay = day),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              weekday,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.red,
                fontSize: 13,
              ),
            ),
            Text(
              day,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox(String label, String value, Color color) {
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Present: $countPresent | Absent: $countAbsent | Late: $countLate',
                style: const TextStyle(fontSize: 12),
              ),
              const Text(
                'Ready',
                style: TextStyle(color: Colors.green, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Attendance for $selectedGrade on Day $selectedDay saved!',
                    ),
                    backgroundColor: Colors.blue,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Save Attendance',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StudentAttendanceCard extends StatelessWidget {
  final String name;
  final String englishName;
  final String id;
  final String status;
  final Function(String) onStatusChanged;

  const StudentAttendanceCard({
    super.key,
    required this.name,
    required this.englishName,
    required this.id,
    required this.status,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: NetworkImage(
                    "https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?w=740",
                  ),
                  radius: 25,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        englishName,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'ID : $id',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildToggleBtn('Present', status == 'Present', Colors.blue),
                const SizedBox(width: 8),
                _buildToggleBtn('Absent', status == 'Absent', Colors.red),
                const SizedBox(width: 8),
                _buildToggleBtn('Late', status == 'Late', Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color color = status == 'Present'
        ? Colors.blue
        : (status == 'Absent' ? Colors.red : Colors.orange);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(status, style: TextStyle(color: color, fontSize: 10)),
    );
  }

  Widget _buildToggleBtn(String label, bool active, Color color) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onStatusChanged(label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? color : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: active ? Colors.white : Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
