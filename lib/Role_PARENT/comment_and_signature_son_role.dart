import 'package:flutter/material.dart';

class ParentSignatureScreen extends StatefulWidget {
  const ParentSignatureScreen({super.key});

  @override
  State<ParentSignatureScreen> createState() => _ParentSignatureScreenState();
}

class _ParentSignatureScreenState extends State<ParentSignatureScreen> {
  final Color primaryTeal = const Color(0xFF007A7C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: primaryTeal, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            const Text(
              'មតិយោបល់ និងចុះហត្ថលេខា', // Comment and Signature
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              'ជំហាន ២ នៃ ២', // Step 2 of 2
              style: TextStyle(color: primaryTeal, fontSize: 12),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: primaryTeal),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Document Preview Summary
            const Text(
              'ទិដ្ឋភាពទូទៅនៃឯកសារ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildDocumentCard(),

            const SizedBox(height: 25),

            // 2. Comment Section
            const Text(
              'មតិយោបល់ជូនគ្រូបង្រៀន',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'សូមបញ្ចូលមតិយោបល់ ឬសំណួរផ្សេងៗ...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // 3. Signature Pad Area
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'ហត្ថលេខា',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'សម្អាត',
                  style: TextStyle(
                    color: primaryTeal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildSignaturePad(),

            const SizedBox(height: 15),

            // 4. Confirmation Checkbox
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check_circle, color: primaryTeal, size: 20),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'តាមរយៈការចុះហត្ថលេខានេះ ខ្ញុំសូមបញ្ជាក់ថាខ្ញុំបានពិនិត្យខ្លឹមសារនៃរបាយការណ៍នេះហើយយល់ព្រមតាមការចុះហត្ថលេខាឌីជីថលនេះមានសុពលភាពស្របច្បាប់។',
                    style: TextStyle(fontSize: 11, color: Colors.blueGrey),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // 5. Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'រង់ចាំការចុះហត្ថលេខា',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Text(
                  'របាយការណ៍វឌ្ឍនភាព ប្រចាំត្រីមាសទី ១',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const Text(
                  'ចេញផ្សាយ៖ ១២ តុលា ២០២៣ • ដោយ អ្នកគ្រូ Henderson',
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
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
          color: primaryTeal.withValues(alpha: 0.2),
          style: BorderStyle.none,
        ), // Custom dashed border needed
      ),
      child: CustomPaint(
        painter: DashedPainter(),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.edit, color: Colors.grey, size: 50),
              SizedBox(height: 10),
              Text(
                'សូមចុះហត្ថលេខានៅទីនេះ',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
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
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.border_color, color: Colors.white, size: 18),
              SizedBox(width: 10),
              Text(
                'បញ្ជូន',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: Colors.grey.shade200),
            ),
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

class DashedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Basic drawing logic for a dashed rectangle border
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
