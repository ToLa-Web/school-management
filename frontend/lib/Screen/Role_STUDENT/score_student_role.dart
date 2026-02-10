// import 'package:flutter/material.dart';

// class StudentScoreScreen extends StatelessWidget {
//   const StudentScoreScreen({super.key});
//   @override
//   Widget build(BuildContext context) {
//     // Primary Teal Color from your designs
//     const Color primaryTeal = Color(0xFF007A7C);
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7F9),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'លទ្ធផលសិក្សា',
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 1. Overall Grade Summary Card
//             _buildOverallGradeCard(primaryTeal),
//             const SizedBox(height: 20),

//             // 2. Score Breakdown Section
//             const Text(
//               'ព័ត៌មានលម្អិតនៃពិន្ទុ',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),
//             _buildScoreItem(
//               Icons.calendar_today_outlined,
//               'ពិន្ទុវត្តមាន',
//               'Attendance (10%)',
//               '10',
//               Colors.blue.shade50,
//               Colors.blue,
//             ),
//             _buildScoreItem(
//               Icons.book_outlined,
//               'ពិន្ទុកិច្ចការផ្ទះ',
//               'Homework (30%)',
//               '28',
//               Colors.orange.shade50,
//               Colors.orange,
//             ),
//             _buildScoreItem(
//               Icons.edit_note_outlined,
//               'ពិន្ទុប្រឡង',
//               'Exam (60%)',
//               '54',
//               Colors.purple.shade50,
//               Colors.purple,
//             ),

//             const SizedBox(height: 25),

//             // 3. Grade Range Table
//             const Text(
//               'តារាងកម្រិតនិទ្ទេស',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),
//             _buildGradeTable(),

//             const SizedBox(height: 30),

//             // 4. Download Report Button
//             SizedBox(
//               width: double.infinity,
//               height: 55,
//               child: ElevatedButton.icon(
//                 onPressed: () {},
//                 icon: const Icon(
//                   Icons.file_download_outlined,
//                   color: Colors.white,
//                 ),
//                 label: const Text(
//                   'ទាញយកព្រឹត្តិបត្រពិន្ទុ',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: primaryTeal,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: _buildBottomNav(primaryTeal),
//     );
//   }

//   Widget _buildOverallGradeCard(Color primaryColor) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withAlpha(10),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Column(
//                 children: [
//                   Text(
//                     'និទ្ទេសសរុប',
//                     style: TextStyle(
//                       color: Color(0xFF007A7C),
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     'A',
//                     style: TextStyle(
//                       fontSize: 72,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF007A7C),
//                     ),
//                   ),
//                   Text(
//                     'ល្អប្រសើរ',
//                     style: TextStyle(
//                       color: Colors.green,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(width: 40),
//               Icon(
//                 Icons.school_outlined,
//                 size: 80,
//                 color: Colors.grey.shade200,
//               ),
//             ],
//           ),
//           const Divider(height: 40),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 'ពិន្ទុសរុប (TOTAL SCORE)',
//                 style: TextStyle(
//                   color: Colors.blueGrey,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 12,
//                 ),
//               ),
//               RichText(
//                 text: const TextSpan(
//                   children: [
//                     TextSpan(
//                       text: '92',
//                       style: TextStyle(
//                         color: Color(0xFF007A7C),
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     TextSpan(
//                       text: '/100',
//                       style: TextStyle(color: Colors.grey, fontSize: 14),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           LinearProgressIndicator(
//             value: 0.92,
//             minHeight: 10,
//             backgroundColor: Colors.grey.shade100,
//             valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
//             borderRadius: BorderRadius.circular(5),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildScoreItem(
//     IconData icon,
//     String title,
//     String subtitle,
//     String score,
//     Color bgColor,
//     Color iconColor,
//   ) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: bgColor,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(icon, color: iconColor),
//           ),
//           const SizedBox(width: 15),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   subtitle,
//                   style: const TextStyle(color: Colors.grey, fontSize: 12),
//                 ),
//               ],
//             ),
//           ),
//           Text(
//             score,
//             style: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF007A7C),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildGradeTable() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Table(
//         children: [
//           _buildTableRow('A (ល្អប្រសើរ)', '90 - 100', isHeader: true),
//           _buildTableRow('B (ល្អណាស់)', '80 - 89'),
//           _buildTableRow('C (ល្អ)', '70 - 79'),
//           _buildTableRow('D (មធ្យមបង្គួរ)', '60 - 69'),
//           _buildTableRow('E (មធ្យម)', '50 - 59'),
//           _buildTableRow('F (ធ្លាក់)', 'ក្រោម 50', isLast: true),
//         ],
//       ),
//     );
//   }

//   TableRow _buildTableRow(
//     String grade,
//     String range, {
//     bool isHeader = false,
//     bool isLast = false,
//   }) {
//     return TableRow(
//       decoration: BoxDecoration(
//         border: isLast
//             ? null
//             : Border(bottom: BorderSide(color: Colors.grey.shade100)),
//       ),
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(16),
//           child: Text(
//             grade,
//             style: TextStyle(
//               fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
//               color: isHeader ? const Color(0xFF007A7C) : Colors.black87,
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(16),
//           child: Text(
//             range,
//             textAlign: TextAlign.right,
//             style: const TextStyle(color: Colors.grey),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildBottomNav(Color color) {
//     return BottomNavigationBar(
//       type: BottomNavigationBarType.fixed,
//       currentIndex: 1, // Highlight 'Results'
//       selectedItemColor: color,
//       unselectedItemColor: Colors.grey,
//       items: const [
//         BottomNavigationBarItem(
//           icon: Icon(Icons.home_outlined),
//           label: 'ទំព័រដើម',
//         ),
//         BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'លទ្ធផល'),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.calendar_month_outlined),
//           label: 'កាលវិភាគ',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.chat_bubble_outline),
//           label: 'សារ',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.person_outline),
//           label: 'ប្រវត្តិរូប',
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:tamdansers/contants/app_text_style.dart';

class StudentScoreScreen extends StatelessWidget {
  const StudentScoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildMonthSelector(),
            const SizedBox(height: 20),
            _buildSummaryCard(),
            const SizedBox(height: 25),
            _buildSubjectScoreList(),
            const SizedBox(height: 25),
            _buildPredictionActionCard(),
            const SizedBox(height: 25),
            _buildCalculatorSection(),
            const SizedBox(height: 100), // Space for navigation bar
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.black,
          size: 20,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text("លទ្ធផលប្រចាំខែ", style: AppTextStyle.sectionTitle20),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.share_outlined, color: Colors.black),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildMonthSelector() {
    final months = ["មករា", "កុម្ភៈ", "មីនា", "មេសា"];
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: months.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          bool isSelected = index == 2; // "March" (មីនា) as active in image
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF007A7A) : Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                months[index],
                style: AppTextStyle.body.copyWith(
                  color: isSelected ? Colors.white : Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFF007A7A),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Text(
            "មធ្យមភាគប្រចាំខែ",
            style: AppTextStyle.body.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 5),
          Text(
            "94.50",
            style: AppTextStyle.sectionTitle20.copyWith(
              color: Colors.white,
              fontSize: 45,
              fontWeight: FontWeight.w900,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "ចំណាត់ថ្នាក់លេខ: ០២",
              style: AppTextStyle.body.copyWith(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatDetail("ពិន្ទុសរុប", "472.5"),
              Container(height: 30, width: 1, color: Colors.white24),
              _buildStatDetail("និទ្ទេស", "A"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatDetail(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyle.body.copyWith(
            color: Colors.white70,
            fontSize: 11,
          ),
        ),
        Text(
          value,
          style: AppTextStyle.body.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectScoreList() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.list_alt, size: 20, color: Color(0xFF007A7A)),
              const SizedBox(width: 8),
              Text(
                "ពិន្ទុតាមមុខវិជ្ជា",
                style: AppTextStyle.body.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _subjectTile(
            "គណិតវិទ្យា",
            "98/100",
            "មធ្យមភាគ: 95",
            Colors.orange,
            Icons.functions,
          ),
          _subjectTile(
            "រូបវិទ្យា",
            "92/100",
            "មធ្យមភាគ: 88",
            Colors.blue,
            Icons.science,
          ),
          _subjectTile(
            "អក្សរសាស្ត្រខ្មែរ",
            "89/100",
            "មធ្យមភាគ: 85",
            Colors.purple,
            Icons.translate,
          ),
        ],
      ),
    );
  }

  Widget _subjectTile(
    String name,
    String score,
    String avg,
    Color color,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              name,
              style: AppTextStyle.body.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                score,
                style: AppTextStyle.body.copyWith(
                  color: const Color(0xFF007A7A),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                avg,
                style: AppTextStyle.body.copyWith(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionActionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Text(
            "ព្យាករណ៍ពិន្ទុរបស់អ្នក",
            style: AppTextStyle.sectionTitle20.copyWith(fontSize: 18),
          ),
          Text(
            "គណនាពិន្ទុដែលអ្នករំពឹងទុកសម្រាប់ខែបន្ទាប់",
            style: AppTextStyle.body.copyWith(fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 15),
          ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007A7A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            ),
            icon: const Icon(Icons.calculate, color: Colors.white),
            label: Text(
              "គណនាពិន្ទុសរុប",
              style: AppTextStyle.body.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculatorSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "កម្មវិធីគណនា (Calculator)",
                style: AppTextStyle.body.copyWith(fontWeight: FontWeight.bold),
              ),
              const Icon(Icons.info_outline, size: 18, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 20),
          _calcField("វត្តមាន (Attendance)", "10", "10"),
          _calcField("កិច្ចការផ្ទះ (Homework)", "25", "30"),
          _calcField("ការប្រឡង (Exams)", "55", "60"),
          const Divider(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "លទ្ធផលប៉ាន់ស្មាន:",
                style: AppTextStyle.body.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                "90 / 100 (A)",
                style: AppTextStyle.sectionTitle20.copyWith(
                  color: const Color(0xFF007A7A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _calcField(String label, String value, String max) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyle.body.copyWith(
              fontSize: 12,
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(value, style: AppTextStyle.body),
                Text(
                  "/ $max",
                  style: AppTextStyle.body.copyWith(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
