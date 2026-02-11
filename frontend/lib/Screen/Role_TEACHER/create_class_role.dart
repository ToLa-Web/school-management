import 'package:flutter/material.dart';

class CreateClassScreen extends StatefulWidget {
  const CreateClassScreen({super.key});

  @override
  State<CreateClassScreen> createState() => _CreateClassScreenState();
}

class _CreateClassScreenState extends State<CreateClassScreen> {
  final Color primaryTeal = const Color(0xFF00B2B2);
  final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  int selectedDayIndex = 0;

  // --- Selection State Variables ---
  String? selectedClassName;
  String? selectedGradeLevel;
  String? selectedSubject;

  // --- Time State Variables ---
  TimeOfDay startTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 10, minute: 30);

  // --- Data Lists ---
  final List<String> classNames = ['Class A', 'Class B', 'Class C', 'Class D'];
  final List<String> gradeLevels = [
    'Grade 7',
    'Grade 8',
    'Grade 9',
    'Grade 10',
    'Grade 11',
    'Grade 12',
  ];
  final List<String> subjects = [
    'Mathematics',
    'Physics',
    'Chemistry',
    'Biology',
    'English',
    'History',
  ];

  // Helper to format TimeOfDay to String
  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return TimeOfDay.fromDateTime(dt).format(context);
  }

  // Function to pick time
  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? startTime : endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          'Create New Class',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Class Information Section
            _buildSectionHeader(Icons.school, 'Class Information'),
            _buildFormCard([
              _buildLabel('Class Name'),
              _buildDropdownSelection(
                hint: 'Select Class Name',
                value: selectedClassName,
                items: classNames,
                onChanged: (val) => setState(() => selectedClassName = val),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _buildLabel('Grade Level')),
                  const SizedBox(width: 15),
                  Expanded(child: _buildLabel('Subject')),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdownSelection(
                      hint: 'Select Grade',
                      value: selectedGradeLevel,
                      items: gradeLevels,
                      onChanged: (val) =>
                          setState(() => selectedGradeLevel = val),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildDropdownSelection(
                      hint: 'Select Subject',
                      value: selectedSubject,
                      items: subjects,
                      onChanged: (val) => setState(() => selectedSubject = val),
                    ),
                  ),
                ],
              ),
            ]),

            const SizedBox(height: 25),

            // 2. Study Schedule Section
            _buildSectionHeader(Icons.calendar_month, 'Study Schedule'),
            _buildFormCard([
              SizedBox(
                height: 50,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: days.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) => _buildDayItem(index),
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: _buildTimePicker(
                      'Start',
                      _formatTime(startTime),
                      () => _selectTime(context, true),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(Icons.arrow_forward, color: Colors.black26),
                  ),
                  Expanded(
                    child: _buildTimePicker(
                      'End',
                      _formatTime(endTime),
                      () => _selectTime(context, false),
                    ),
                  ),
                ],
              ),
            ]),

            const SizedBox(height: 25),

            // 3. Add Students Section
            _buildSectionHeader(Icons.person_add, 'Add Students'),
            Row(
              children: [
                Expanded(
                  child: _buildAddOption(
                    Icons.qr_code_scanner,
                    'Invite via Code',
                    () => _showComingSoonSnackBar("Invite via Code"),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildAddOption(
                    Icons.group_add,
                    'Select from List',
                    () => _showStudentListDialog(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // --- CREATE CLASS BUTTON ---
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: _handleCreateClass,
                icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                label: const Text(
                  'Create Class',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryTeal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- LOGIC HANDLERS ---

  void _handleCreateClass() {
    if (selectedClassName == null ||
        selectedGradeLevel == null ||
        selectedSubject == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all class information!'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Success SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 10),
            Text('$selectedClassName created successfully!'),
          ],
        ),
        backgroundColor: primaryTeal,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );

    // Optional: Return to previous screen
    // Future.delayed(const Duration(seconds: 2), () => Navigator.pop(context));
  }

  void _showComingSoonSnackBar(String feature) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$feature feature coming soon!')));
  }

  void _showStudentListDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Select Students"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: 5,
            itemBuilder: (context, index) => CheckboxListTile(
              activeColor: primaryTeal,
              title: Text("Student ${index + 1}"),
              value: false,
              onChanged: (val) {},
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryTeal),
            onPressed: () => Navigator.pop(context),
            child: const Text("Add", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // --- REUSABLE WIDGET HELPERS ---

  Widget _buildDropdownSelection({
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      hint: Text(
        hint,
        style: const TextStyle(color: Colors.black26, fontSize: 14),
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 15,
        ),
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, color: primaryTeal, size: 28),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    ),
  );

  Widget _buildDayItem(int index) {
    bool isSelected = selectedDayIndex == index;
    return GestureDetector(
      onTap: () => setState(() => selectedDayIndex = index),
      child: Container(
        width: 45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? primaryTeal : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.black12,
          ),
        ),
        child: Text(
          days[index],
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTimePicker(String label, String time, VoidCallback onTap) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 8),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time, size: 18, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    time,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ],
      );

  Widget _buildAddOption(IconData icon, String label, VoidCallback onTap) =>
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black12),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primaryTeal.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: primaryTeal),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ],
          ),
        ),
      );
}
