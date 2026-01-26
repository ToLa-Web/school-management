import 'package:flutter/material.dart';
import 'package:tamdansers/Screen/Role_TEACHER/create_class_role.dart';

void main() => runApp(const MaterialApp(home: ClassManagementScreen()));

class ClassManagementScreen extends StatelessWidget {
  const ClassManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'ការគ្រប់គ្រងថ្នាក់រៀន', // Classroom Management
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: Colors.black),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ElevatedButton.icon(
              onPressed: () {
                // Navigate to Create Class Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateClassScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('បន្ថែមថ្នាក់ថ្មី'), // Add New Class
              style: ElevatedButton.styleFrom(shape: StadiumBorder()),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Filter Tabs (Simplified)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('ទាំងអស់', true),
                _buildFilterChip('ថ្នាក់ទី ៧', false),
                _buildFilterChip('ថ្នាក់ទី ៨', false),
                _buildFilterChip('ថ្នាក់ទី ៩', false),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Class Cards
          const ClassCard(
            grade: 'ថ្នាក់ទី ៧ក (Grade 7A)',
            subject: 'រូបវិទ្យា (Physics)',
            studentCount: 36,

            imageUrl: 'assets/images/grade1.jpg', // Replace with your asset
            accentColor: Colors.teal,
          ),
          const ClassCard(
            grade: 'ថ្នាក់ទី ៨ខ (Grade 8B)',
            subject: 'គណិតវិទ្យា (Math)',
            studentCount: 20,
            imageUrl: 'assets/math_bg.jpg',
            accentColor: Colors.orange,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ទំព័រដើម'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'ថ្នាក់រៀន'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'សារ'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'ព័ត៌មានផ្ទាល់ខ្លួន',
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: Colors.blue,
        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
      ),
    );
  }
}

class ClassCard extends StatelessWidget {
  final String grade;
  final String subject;
  final int studentCount;
  final String imageUrl;
  final Color accentColor;

  const ClassCard({
    super.key,
    required this.grade,
    required this.subject,
    required this.studentCount,
    required this.imageUrl,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: Column(
        children: [
          // Top Header Section
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.8),
              // Use Image.asset or NetworkImage for the background patterns
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  grade,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Info Section
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'មុខវិជ្ជាបង្រៀន',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Text(
                      subject,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.people, size: 16, color: Colors.blue),
                      const SizedBox(width: 4),
                      Text('$studentCount នាក់'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Action Buttons Section
          Row(
            children: [
              _buildActionButton(
                Icons.fact_check_outlined,
                'អវត្តមាន',
                Colors.blue,
              ),
              _buildActionButton(
                Icons.assignment_outlined,
                'កិច្ចការផ្ទះ',
                Colors.orange,
              ),
              _buildActionButton(
                Icons.group_outlined,
                'បញ្ជីឈ្មោះ',
                Colors.purple,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color) {
    return Expanded(
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade100, width: 0.5),
          ),
          child: Column(
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
