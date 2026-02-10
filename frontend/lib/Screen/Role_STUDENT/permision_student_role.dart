import 'package:flutter/material.dart';

class StudentPermissionScreen extends StatefulWidget {
  const StudentPermissionScreen({super.key});

  @override
  State<StudentPermissionScreen> createState() =>
      _StudentPermissionScreenState();
}

class _StudentPermissionScreenState extends State<StudentPermissionScreen> {
  // Theme Color
  final Color primaryTeal = const Color(0xFF007A7C);
  String? selectedLeaveType = 'ឈឺ (Sick Leave)';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.teal.withValues(alpha: 0.1),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Color(0xFF007A7C),
                size: 18,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text(
          'ផ្ញើរសំណើសុំច្បាប់',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Request Form Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('ប្រភេទច្បាប់'),
                  _buildDropdown(),
                  const SizedBox(height: 20),

                  _buildLabel('កាលបរិច្ឆេទ'),
                  _buildDatePicker(),
                  const SizedBox(height: 20),

                  _buildLabel('មូលហេតុ'),
                  _buildReasonField(),
                  const SizedBox(height: 20),

                  // Attachment Button
                  _buildAttachmentButton(),
                  const SizedBox(height: 25),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.send, color: Colors.white),
                      label: const Text(
                        'ផ្ញើសំណើ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
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

            const SizedBox(height: 30),

            // 2. History Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'ប្រវត្តិការសុំច្បាប់',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'មើលទាំងអស់',
                    style: TextStyle(color: primaryTeal),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 3. History List
            _buildHistoryItem(
              title: 'សុំច្បាប់ឈឺ (Sick Leave)',
              date: '១៥ តុលា ២០២៤',
              description: 'ខ្ញុំមានអាការៈគ្រុនក្តៅខ្លាំង...',
              status: 'កំពុងរង់ចាំ',
              statusColor: Colors.orange,
            ),
            const SizedBox(height: 12),
            _buildHistoryItem(
              title: 'ការងារផ្ទាល់ខ្លួន (Personal)',
              date: '១០ តុលា ២០២៤',
              description: 'ចូលរួមកម្មវិធីគ្រួសារ...',
              status: 'បានអនុម័ត',
              statusColor: Colors.green,
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // Helper Widgets
  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    ),
  );

  Widget _buildDropdown() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.black12),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: selectedLeaveType,
        isExpanded: true,
        items: ['ឈឺ (Sick Leave)', 'ផ្ទាល់ខ្លួន (Personal)'].map((
          String value,
        ) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: (newValue) => setState(() => selectedLeaveType = newValue),
      ),
    ),
  );

  Widget _buildDatePicker() => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.black12),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('១៥ តុលា ២០២៤', style: TextStyle(fontSize: 16)),
        Icon(Icons.calendar_today, color: primaryTeal),
      ],
    ),
  );

  Widget _buildReasonField() => TextField(
    maxLines: 4,
    decoration: InputDecoration(
      hintText: 'បញ្ចូលមូលហេតុនៃការសុំច្បាប់...',
      hintStyle: const TextStyle(color: Colors.black26),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.black12),
      ),
    ),
  );

  Widget _buildAttachmentButton() => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 12),
    decoration: BoxDecoration(
      border: Border.all(
        color: primaryTeal.withValues(alpha: 0.3),
        style: BorderStyle.solid,
      ),
      borderRadius: BorderRadius.circular(10),
      color: primaryTeal.withValues(alpha: 0.05),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.attach_file, color: primaryTeal),
        const SizedBox(width: 8),
        Text(
          'ភ្ជាប់ឯកសារបញ្ជាក់',
          style: TextStyle(color: primaryTeal, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );

  Widget _buildHistoryItem({
    required String title,
    required String date,
    required String description,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Text(
            'កាលបរិច្ឆេទ: $date',
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const Divider(height: 20),
          Text(
            description,
            style: const TextStyle(color: Colors.black54),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() => BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    currentIndex: 2,
    selectedItemColor: primaryTeal,
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        label: 'ទំព័រដើម',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.calendar_month_outlined),
        label: 'កាលវិភាគ',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.edit_document),
        label: 'សុំច្បាប់',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        label: 'ប្រវត្តិរូប',
      ),
    ],
  );
}
