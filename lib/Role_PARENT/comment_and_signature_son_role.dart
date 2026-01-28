import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:tamdansers/Screen/Edit-Profile/student_edit_profile.dart';

class ParentSignatureScreen extends StatefulWidget {
  const ParentSignatureScreen({super.key});

  @override
  State<ParentSignatureScreen> createState() => _ParentSignatureScreenState();
}

class _ParentSignatureScreenState extends State<ParentSignatureScreen> {
  int _pageIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final Color primaryTeal = const Color(0xFF007A7C);

  // List of screens for the navigation
  late final List<Widget> _screens = [
    _buildSignatureFormContent(), // Tab 0: Current Task
    const Center(child: Text("ប្រវត្តិឯកសារ (History)")),
    const Center(child: Text("សារ (Messages)")),
    const StudentEditProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      // App bar only shows on the Signature tab
      appBar: _pageIndex == 0
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: primaryTeal, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
              title: Column(
                children: [
                  const Text(
                    'មតិយោបល់ និងចុះហត្ថលេខា',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'ជំហាន ២ នៃ ២',
                    style: TextStyle(color: primaryTeal, fontSize: 12),
                  ),
                ],
              ),
              centerTitle: true,
            )
          : null,
      body: IndexedStack(index: _pageIndex, children: _screens),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _pageIndex,
        height: 60.0,
        items: const <Widget>[
          Icon(Icons.draw_rounded, size: 30, color: Colors.white),
          Icon(Icons.history_edu_rounded, size: 30, color: Colors.white),
          Icon(Icons.chat_bubble_outline, size: 30, color: Colors.white),
          Icon(Icons.person_outline, size: 30, color: Colors.white),
        ],
        color: primaryTeal,
        buttonBackgroundColor: primaryTeal,
        backgroundColor: const Color(0xFFF8F9FA),
        animationCurve: Curves.easeInOut,
        onTap: (index) => setState(() => _pageIndex = index),
      ),
    );
  }

  // --- Main Content: Signature Form ---
  Widget _buildSignatureFormContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ទិដ្ឋភាពទូទៅនៃឯកសារ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildDocumentCard(),
          const SizedBox(height: 25),
          const Text(
            'មតិយោបល់ជូនគ្រូបង្រៀន',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildCommentField(),
          const SizedBox(height: 25),
          _buildSignatureHeader(),
          const SizedBox(height: 10),
          _buildSignaturePad(),
          const SizedBox(height: 15),
          _buildLegalDisclaimer(),
          const SizedBox(height: 30),
          _buildActionButtons(),
        ],
      ),
    );
  }

  // --- UI Components ---

  Widget _buildDocumentCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.description, color: Colors.blue),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'រង់ចាំការចុះហត្ថលេខា',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'របាយការណ៍វឌ្ឍនភាព ប្រចាំត្រីមាសទី ១',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  'ចេញផ្សាយ៖ ១២ តុលា ២០២៣',
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentField() {
    return TextField(
      maxLines: 4,
      decoration: InputDecoration(
        hintText: 'សូមបញ្ចូលមតិយោបល់ ឬសំណួរផ្សេងៗ...',
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: primaryTeal),
        ),
      ),
    );
  }

  Widget _buildSignatureHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'ហត្ថលេខា',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'សម្អាត',
            style: TextStyle(color: primaryTeal, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildSignaturePad() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.grey.shade300,
          style: BorderStyle.solid,
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.edit, color: Colors.grey, size: 40),
            Text(
              'សូមចុះហត្ថលេខានៅទីនេះ',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegalDisclaimer() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle, color: primaryTeal, size: 20),
        const SizedBox(width: 10),
        const Expanded(
          child: Text(
            'តាមរយៈការចុះហត្ថលេខានេះ ខ្ញុំសូមបញ្ជាក់ថាខ្ញុំបានពិនិត្យខ្លឹមសារនៃរបាយការណ៍នេះហើយ។',
            style: TextStyle(fontSize: 11, color: Colors.blueGrey),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryTeal,
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: const Text(
            'បញ្ជូន',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            minimumSize: const Size(double.infinity, 55),
          ),
          child: const Text(
            'បោះបង់',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
