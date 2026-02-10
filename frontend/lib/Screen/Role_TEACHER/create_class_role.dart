import 'package:flutter/material.dart';

class CreateClassScreen extends StatefulWidget {
  const CreateClassScreen({super.key});

  @override
  State<CreateClassScreen> createState() => _CreateClassScreenState();
}

class _CreateClassScreenState extends State<CreateClassScreen> {
  final Color primaryTeal = const Color(0xFF00B2B2);
  final List<String> days = ['ច', 'អង្គ', 'ព', 'ព្រ', 'សុ', 'សៅ', 'អា'];
  int selectedDayIndex = 0;

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
          'បង្កើតថ្នាក់រៀនថ្មី',
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
            _buildSectionHeader(Icons.school, 'ព័ត៌មានថ្នាក់រៀន'),
            _buildFormCard([
              _buildLabel('ឈ្មោះថ្នាក់'),
              _buildTextField('ឧទាហរណ៍៖ ថ្នាក់ទី ១២អា'),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _buildLabel('កម្រិតថ្នាក់')),
                  const SizedBox(width: 15),
                  Expanded(child: _buildLabel('មុខវិជ្ជា')),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _buildDropdownField('ថ្នាក់ទី ១២')),
                  const SizedBox(width: 15),
                  Expanded(child: _buildTextField('បញ្ចូលមុខវិជ្ជា')),
                ],
              ),
            ]),

            const SizedBox(height: 25),

            // 2. Study Schedule Section
            _buildSectionHeader(Icons.calendar_month, 'កាលវិភាគសិក្សា'),
            _buildFormCard([
              // Day Selector
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
              // Time Pickers
              Row(
                children: [
                  Expanded(child: _buildTimePicker('ចាប់ផ្ដើម', '០៨:០០ ព្រឹក')),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(Icons.arrow_forward, color: Colors.black26),
                  ),
                  Expanded(child: _buildTimePicker('បញ្ចប់', '១០:៣០ ព្រឹក')),
                ],
              ),
            ]),

            const SizedBox(height: 25),

            // 3. Add Students Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionHeader(Icons.person_add, 'បន្ថែមសិស្ស'),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'ស្រេចចិត្ត',
                    style: TextStyle(color: primaryTeal),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildAddOption(Icons.qr_code_scanner, 'អញ្ជើញតាមកូដ'),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildAddOption(Icons.group_add, 'ជ្រើសរើសពីបញ្ជី'),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Create Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                label: const Text(
                  'បង្កើតថ្នាក់',
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
      bottomNavigationBar: _buildBottomNav(),
    );
  }
  // --- Helper Widgets ---
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
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10),
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

  Widget _buildTextField(String hint) => TextField(
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black26),
      filled: true,
      fillColor: const Color(0xFFF8F9FA),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );

  Widget _buildDropdownField(String value) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    decoration: BoxDecoration(
      color: const Color(0xFFF8F9FA),
      borderRadius: BorderRadius.circular(12),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        items: [
          value,
        ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (_) {},
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

  Widget _buildTimePicker(String label, String time) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time, size: 18, color: Colors.grey),
            const SizedBox(width: 8),
            Text(time, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    ],
  );

  Widget _buildAddOption(IconData icon, String label) => Container(
    padding: const EdgeInsets.symmetric(vertical: 20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.black12, style: BorderStyle.solid),
    ),
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: primaryTeal.withValues(alpha: 0.1),
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
  );

  Widget _buildBottomNav() => BottomNavigationBar(
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
