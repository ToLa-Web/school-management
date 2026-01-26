import 'package:flutter/material.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final Color primaryTeal = const Color(0xFF00B2B2);

  // Example student data
  final List<Map<String, dynamic>> students = [
    {'name': 'សុខ វិបុល', 'id': '10293', 'class': '១២អា', 'selected': true},
    {
      'name': 'ចាន់ ស្រីមុំ',
      'id': '10452',
      'class': '១២ប៊ី',
      'selected': false,
    },
    {'name': 'កែវ រតនា', 'id': '10884', 'class': '១២អា', 'selected': false},
    {'name': 'លី ម៉ារីណា', 'id': '10521', 'class': '១២ប៊ី', 'selected': false},
    {'name': 'ហេង វិបុល', 'id': '10119', 'class': '១២អា', 'selected': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: primaryTeal, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'បន្ថែមសិស្សទៅក្នុងថ្នាក់',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'ឈ្មោះ ឬ លេខសម្គាល់',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 2. Invite via QR Section
          _buildInviteCard(),

          // 3. Student List Header
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'បញ្ជីឈ្មោះសិស្ស',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: primaryTeal.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'ជ្រើសរើសបាន ០៣ នាក់',
                    style: TextStyle(color: primaryTeal, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          // 4. Student List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return _buildStudentItem(student, index);
              },
            ),
          ),

          // 5. Confirm Button
          _buildConfirmButton(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildInviteCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryTeal.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.qr_code_scanner, color: primaryTeal),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'អញ្ជើញតាមរយៈកូដ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'អនុញ្ញាតឱ្យសិស្សចូលរួមដោយដៃ',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryTeal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: const Text('អញ្ជើញ', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentItem(Map<String, dynamic> student, int index) {
    bool isSelected = student['selected'];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isSelected ? primaryTeal : Colors.transparent,
          width: 2,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: const CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(
            'https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?semt=ais_hybrid&w=740&q=80',
          ),
        ),
        title: Text(
          student['name'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'ID: ${student['id']} • ថ្នាក់ទី ${student['class']}',
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        trailing: Transform.scale(
          scale: 1.2,
          child: Checkbox(
            value: isSelected,
            activeColor: primaryTeal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            onChanged: (val) {
              setState(() => students[index]['selected'] = val);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryTeal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: const Text(
            'បញ្ជាក់ការបន្ថែម',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 0,
      selectedItemColor: primaryTeal,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ទំព័រដើម'),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: 'កាលវិភាគ',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'សារ'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'ប្រវត្តិរូប'),
      ],
    );
  }
}
