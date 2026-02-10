import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: AttendanceScreen()));

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

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
          'ការគ្រប់គ្រងវត្តមាន',
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
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                SizedBox(height: 16),
                StudentAttendanceCard(
                  name: 'សុខ តារា',
                  englishName: 'Sok Dara',
                  id: '18623',
                  status: 'វត្តមាន', // Present
                ),
                StudentAttendanceCard(
                  name: 'ចាន់ វិទ្យា',
                  englishName: 'Chan Vitthyea',
                  id: '18624',
                  status: 'អវត្តមាន', // Absent
                ),
                StudentAttendanceCard(
                  name: 'កែវ បុប្ផា',
                  englishName: 'Keo Bopha',
                  id: '18625',
                  status: 'យឺត', // Late
                ),
                StudentAttendanceCard(
                  name: 'កែវ បុប្ផា',
                  englishName: 'Keo Bopha',
                  id: '18625',
                  status: 'យឺត', // Late
                ),
                StudentAttendanceCard(
                  name: 'កែវ បុប្ផា',
                  englishName: 'Keo Bopha',
                  id: '18625',
                  status: 'អវត្តមាន', // Late
                ),
                StudentAttendanceCard(
                  name: 'កែវ បុប្ផា',
                  englishName: 'Keo Bopha',
                  id: '18625',
                  status: 'វត្តមាន', // Late
                ),
                StudentAttendanceCard(
                  name: 'កែវ បុប្ផា',
                  englishName: 'Keo Bopha',
                  id: '18625',
                  status: 'យឺត', // Late
                ),
              ],
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'ថ្នាក់ទី ១២អា - គណិតវិទ្យា',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Icon(Icons.swap_vert, color: Colors.grey),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Horizontal Date Picker (Simulated)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDateItem('២៣', 'ចន្ទ', false),
              _buildDateItem('២៤', 'អង្គារ', true), // Selected
              _buildDateItem('២៥', 'ពុធ', false),
              _buildDateItem('២៦', 'ព្រហ', false),
              _buildDateItem('២៧', 'សុក្រ', false),
            ],
          ),
          const SizedBox(height: 16),
          // Summary Statistics
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatBox('សរុប', '៣២', Colors.black),
              _buildStatBox('វត្តមាន', '២៨', Colors.blue),
              _buildStatBox('អវត្តមាន', '៣', Colors.red),
              _buildStatBox('យឺត', '១', Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateItem(String day, String weekday, bool isSelected) {
    return Container(
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
    );
  }

  Widget _buildStatBox(String label, String value, Color color) {
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: color.withValues(alpha: .1)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: Colors.blue)),
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
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'សរុប: វត្តមាន: ២៨ | អវត្តមាន: ៣ | យឺត: ១',
                style: TextStyle(fontSize: 12),
              ),
              Text(
                'បានរក្សាទុក',
                style: TextStyle(color: Colors.green, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('រក្សាទុកវត្តមាន'), // Save Attendance
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

  const StudentAttendanceCard({
    super.key,
    required this.name,
    required this.englishName,
    required this.id,
    required this.status,
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
                    "https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?semt=ais_hybrid&w=740&q=80",
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
                _buildToggleBtn('វត្តមាន', status == 'វត្តមាន', Colors.blue),
                const SizedBox(width: 8),
                _buildToggleBtn('អវត្តមាន', status == 'អវត្តមាន', Colors.red),
                const SizedBox(width: 8),
                _buildToggleBtn('យឺត', status == 'យឺត', Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color color = status == 'វត្តមាន'
        ? Colors.blue
        : (status == 'អវត្តមាន' ? Colors.red : Colors.orange);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(status, style: TextStyle(color: color, fontSize: 10)),
    );
  }

  Widget _buildToggleBtn(String label, bool active, Color color) {
    return Expanded(
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
    );
  }
}
