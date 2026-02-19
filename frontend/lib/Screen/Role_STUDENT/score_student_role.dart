// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:tamdansers/Screen/Edit-Profile/student_edit_profile.dart';
// import 'package:tamdansers/contants/app_text_style.dart';

// class StudentScoreScreen extends StatefulWidget {
//   const StudentScoreScreen({super.key});

//   @override
//   State<StudentScoreScreen> createState() => _StudentScoreScreenState();
// }

// class _StudentScoreScreenState extends State<StudentScoreScreen> {
//   int pageIndex = 0;
//   int selectedMonthIndex = 2; // Default to March
//   final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

//   // 1. Data Structure for Monthly Scores
//   final Map<int, List<Map<String, dynamic>>> monthlyData = {
//     0: [
//       // Jan
//       {
//         "name": "Mathematics",
//         "score": "85",
//         "color": Colors.orange,
//         "icon": Icons.functions,
//       },
//       {
//         "name": "Physics",
//         "score": "80",
//         "color": Colors.blue,
//         "icon": Icons.science,
//       },
//       {
//         "name": "Khmer Literature",
//         "score": "88",
//         "color": Colors.purple,
//         "icon": Icons.translate,
//       },
//       {
//         "name": "English",
//         "score": "90",
//         "color": Colors.red,
//         "icon": Icons.language,
//       },
//       {
//         "name": "Chemistry",
//         "score": "75",
//         "color": Colors.green,
//         "icon": Icons.biotech,
//       },
//       {
//         "name": "History",
//         "score": "82",
//         "color": Colors.brown,
//         "icon": Icons.history_edu,
//       },
//       {
//         "name": "ICT",
//         "score": "95",
//         "color": Colors.teal,
//         "icon": Icons.computer,
//       },
//     ],
//     1: [
//       // Feb
//       {
//         "name": "Mathematics",
//         "score": "92",
//         "color": Colors.orange,
//         "icon": Icons.functions,
//       },
//       {
//         "name": "Physics",
//         "score": "88",
//         "color": Colors.blue,
//         "icon": Icons.science,
//       },
//       {
//         "name": "Khmer Literature",
//         "score": "85",
//         "color": Colors.purple,
//         "icon": Icons.translate,
//       },
//       {
//         "name": "English",
//         "score": "94",
//         "color": Colors.red,
//         "icon": Icons.language,
//       },
//       {
//         "name": "Chemistry",
//         "score": "80",
//         "color": Colors.green,
//         "icon": Icons.biotech,
//       },
//       {
//         "name": "History",
//         "score": "87",
//         "color": Colors.brown,
//         "icon": Icons.history_edu,
//       },
//       {
//         "name": "ICT",
//         "score": "98",
//         "color": Colors.teal,
//         "icon": Icons.computer,
//       },
//     ],
//     2: [
//       // Mar
//       {
//         "name": "Mathematics",
//         "score": "98",
//         "color": Colors.orange,
//         "icon": Icons.functions,
//       },
//       {
//         "name": "Physics",
//         "score": "92",
//         "color": Colors.blue,
//         "icon": Icons.science,
//       },
//       {
//         "name": "Khmer Literature",
//         "score": "89",
//         "color": Colors.purple,
//         "icon": Icons.translate,
//       },
//       {
//         "name": "English",
//         "score": "95",
//         "color": Colors.red,
//         "icon": Icons.language,
//       },
//       {
//         "name": "Chemistry",
//         "score": "88",
//         "color": Colors.green,
//         "icon": Icons.biotech,
//       },
//       {
//         "name": "History",
//         "score": "84",
//         "color": Colors.brown,
//         "icon": Icons.history_edu,
//       },
//       {
//         "name": "ICT",
//         "score": "97",
//         "color": Colors.teal,
//         "icon": Icons.computer,
//       },
//     ],
//     // You can repeat this pattern for months 3-11 (Apr-Dec)
//   };

//   // 2. Calculator Controllers for 7 Subjects
//   final List<TextEditingController> _calcControllers = List.generate(
//     7,
//     (index) => TextEditingController(text: "0"),
//   );
//   double _calculatedAverage = 0.0;

//   final List<String> months = [
//     "Jan",
//     "Feb",
//     "Mar",
//     "Apr",
//     "May",
//     "Jun",
//     "Jul",
//     "Aug",
//     "Sep",
//     "Oct",
//     "Nov",
//     "Dec",
//   ];

//   @override
//   void initState() {
//     super.initState();
//     for (var controller in _calcControllers) {
//       controller.addListener(_updateCalculation);
//     }
//   }

//   void _updateCalculation() {
//     double total = 0;
//     for (var controller in _calcControllers) {
//       total += double.tryParse(controller.text) ?? 0;
//     }
//     setState(() {
//       _calculatedAverage = total / 7;
//     });
//   }

//   // Helper to get current month's average
//   double _getCurrentMonthAvg() {
//     var list = monthlyData[selectedMonthIndex] ?? monthlyData[0]!;
//     double sum = 0;
//     for (var item in list) {
//       sum += double.parse(item['score']);
//     }
//     return sum / 7;
//   }

//   @override
//   Widget build(BuildContext context) {
//     late final List<Widget> _screens = [
//       _buildScoreContent(),
//       Center(child: Text("Library", style: AppTextStyle.sectionTitle20)),
//       Center(child: Text("Messages", style: AppTextStyle.sectionTitle20)),
//       const StudentEditProfileScreen(),
//     ];

//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7F9),
//       appBar: pageIndex == 0 ? _buildAppBar(context) : null,
//       body: IndexedStack(index: pageIndex, children: _screens),
//       bottomNavigationBar: CurvedNavigationBar(
//         key: _bottomNavigationKey,
//         index: pageIndex,
//         height: 60.0,
//         items: const [
//           Icon(Icons.grid_view_rounded, size: 30, color: Colors.white),
//           Icon(Icons.menu_book, size: 30, color: Colors.white),
//           Icon(Icons.chat_bubble, size: 30, color: Colors.white),
//           Icon(Icons.settings, size: 30, color: Colors.white),
//         ],
//         color: const Color(0xFF007A7A),
//         buttonBackgroundColor: const Color(0xFF007A7A),
//         backgroundColor: const Color(0xFFF5F7F9),
//         onTap: (index) => setState(() => pageIndex = index),
//       ),
//     );
//   }

//   Widget _buildScoreContent() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         children: [
//           const SizedBox(height: 10),
//           _buildMonthSelector(),
//           const SizedBox(height: 20),
//           _buildSummaryCard(),
//           const SizedBox(height: 25),
//           _buildSubjectScoreList(),
//           const SizedBox(height: 25),
//           _buildCalculatorSection(),
//           const SizedBox(height: 100),
//         ],
//       ),
//     );
//   }

//   Widget _buildMonthSelector() {
//     return SizedBox(
//       height: 45,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: months.length,
//         itemBuilder: (context, index) {
//           bool isSelected = selectedMonthIndex == index;
//           return GestureDetector(
//             onTap: () => setState(() => selectedMonthIndex = index),
//             child: Container(
//               margin: const EdgeInsets.only(right: 10),
//               padding: const EdgeInsets.symmetric(horizontal: 22),
//               decoration: BoxDecoration(
//                 color: isSelected ? const Color(0xFF007A7A) : Colors.white,
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Center(
//                 child: Text(
//                   months[index],
//                   style: AppTextStyle.body.copyWith(
//                     color: isSelected ? Colors.white : Colors.black54,
//                     fontWeight: isSelected
//                         ? FontWeight.bold
//                         : FontWeight.normal,
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildSummaryCard() {
//     double avg = _getCurrentMonthAvg();
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(25),
//       decoration: BoxDecoration(
//         color: const Color(0xFF007A7A),
//         borderRadius: BorderRadius.circular(30),
//       ),
//       child: Column(
//         children: [
//           Text(
//             "Average for ${months[selectedMonthIndex]}",
//             style: AppTextStyle.body.copyWith(color: Colors.white70),
//           ),
//           Text(
//             avg.toStringAsFixed(2),
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 45,
//               fontWeight: FontWeight.w900,
//             ),
//           ),
//           const SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildStatDetail(
//                 "Grade",
//                 avg >= 90 ? "A" : (avg >= 80 ? "B" : "C"),
//               ),
//               Container(height: 30, width: 1, color: Colors.white24),
//               _buildStatDetail("Status", "Passed"),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSubjectScoreList() {
//     var subjects = monthlyData[selectedMonthIndex] ?? monthlyData[0]!;
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(25),
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               const Icon(Icons.list_alt, size: 20, color: Color(0xFF007A7A)),
//               const SizedBox(width: 8),
//               Text(
//                 "Subject Scores (${months[selectedMonthIndex]})",
//                 style: AppTextStyle.body.copyWith(fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           ...subjects
//               .map(
//                 (s) => _subjectTile(
//                   s['name'],
//                   "${s['score']}/100",
//                   s['color'],
//                   s['icon'],
//                 ),
//               )
//               .toList(),
//         ],
//       ),
//     );
//   }

//   Widget _subjectTile(String name, String score, Color color, IconData icon) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 15),
//       child: Row(
//         children: [
//           CircleAvatar(
//             backgroundColor: color.withOpacity(0.1),
//             child: Icon(icon, color: color, size: 18),
//           ),
//           const SizedBox(width: 15),
//           Expanded(
//             child: Text(
//               name,
//               style: AppTextStyle.body.copyWith(fontWeight: FontWeight.w600),
//             ),
//           ),
//           Text(
//             score,
//             style: const TextStyle(
//               color: Color(0xFF007A7A),
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCalculatorSection() {
//     final List<String> subjectNames = [
//       "Math",
//       "Phys",
//       "Khmer",
//       "Eng",
//       "Chem",
//       "Hist",
//       "ICT",
//     ];
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(25),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "7-Subject Calculator",
//             style: AppTextStyle.body.copyWith(fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 15),
//           // Generate 7 input fields
//           ...List.generate(7, (index) {
//             return _calcInputField(
//               subjectNames[index],
//               _calcControllers[index],
//             );
//           }),
//           const Divider(height: 30),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 "Average Result:",
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 "${_calculatedAverage.toStringAsFixed(2)} / 100",
//                 style: const TextStyle(
//                   color: Color(0xFF007A7A),
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _calcInputField(String label, TextEditingController controller) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(label, style: const TextStyle(fontSize: 13)),
//           ),
//           Expanded(
//             child: TextField(
//               controller: controller,
//               keyboardType: TextInputType.number,
//               textAlign: TextAlign.center,
//               decoration: InputDecoration(
//                 isDense: true,
//                 filled: true,
//                 fillColor: const Color(0xFFF5F7F9),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 10),
//           const Text(
//             "/ 100",
//             style: TextStyle(color: Colors.grey, fontSize: 12),
//           ),
//         ],
//       ),
//     );
//   }

//   PreferredSizeWidget _buildAppBar(BuildContext context) {
//     return AppBar(
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//       leading: IconButton(
//         icon: const Icon(
//           Icons.arrow_back_ios_new,
//           color: Colors.black,
//           size: 20,
//         ),
//         onPressed: () => Navigator.pop(context),
//       ),
//       title: Text("Academic Performance", style: AppTextStyle.sectionTitle20),
//       centerTitle: true,
//     );
//   }

//   Widget _buildStatDetail(String label, String value) {
//     return Column(
//       children: [
//         Text(
//           label,
//           style: const TextStyle(color: Colors.white70, fontSize: 11),
//         ),
//         Text(
//           value,
//           style: const TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
// Note: Ensure these imports match your actual project structure
import 'package:tamdansers/Screen/Edit-Profile/student_edit_profile.dart';
import 'package:tamdansers/contants/app_text_style.dart';

class StudentScoreScreen extends StatefulWidget {
  const StudentScoreScreen({super.key});

  @override
  State<StudentScoreScreen> createState() => _StudentScoreScreenState();
}

class _StudentScoreScreenState extends State<StudentScoreScreen> {
  int pageIndex = 0;
  int selectedMonthIndex = 2; // Default to March
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  // 1. Data Structure for Monthly Scores (7 Subjects)
  final Map<int, List<Map<String, dynamic>>> monthlyData = {
    0: [
      // Jan
      {
        "name": "Mathematics",
        "score": "85",
        "color": Colors.orange,
        "icon": Icons.functions,
      },
      {
        "name": "Physics",
        "score": "80",
        "color": Colors.blue,
        "icon": Icons.science,
      },
      {
        "name": "Khmer Literature",
        "score": "88",
        "color": Colors.purple,
        "icon": Icons.translate,
      },
      {
        "name": "English",
        "score": "90",
        "color": Colors.red,
        "icon": Icons.language,
      },
      {
        "name": "Chemistry",
        "score": "75",
        "color": Colors.green,
        "icon": Icons.biotech,
      },
      {
        "name": "History",
        "score": "82",
        "color": Colors.brown,
        "icon": Icons.history_edu,
      },
      {
        "name": "ICT",
        "score": "95",
        "color": Colors.teal,
        "icon": Icons.computer,
      },
    ],
    1: [
      // Feb
      {
        "name": "Mathematics",
        "score": "92",
        "color": Colors.orange,
        "icon": Icons.functions,
      },
      {
        "name": "Physics",
        "score": "88",
        "color": Colors.blue,
        "icon": Icons.science,
      },
      {
        "name": "Khmer Literature",
        "score": "85",
        "color": Colors.purple,
        "icon": Icons.translate,
      },
      {
        "name": "English",
        "score": "94",
        "color": Colors.red,
        "icon": Icons.language,
      },
      {
        "name": "Chemistry",
        "score": "80",
        "color": Colors.green,
        "icon": Icons.biotech,
      },
      {
        "name": "History",
        "score": "87",
        "color": Colors.brown,
        "icon": Icons.history_edu,
      },
      {
        "name": "ICT",
        "score": "98",
        "color": Colors.teal,
        "icon": Icons.computer,
      },
    ],
    2: [
      // Mar
      {
        "name": "Mathematics",
        "score": "98",
        "color": Colors.orange,
        "icon": Icons.functions,
      },
      {
        "name": "Physics",
        "score": "92",
        "color": Colors.blue,
        "icon": Icons.science,
      },
      {
        "name": "Khmer Literature",
        "score": "89",
        "color": Colors.purple,
        "icon": Icons.translate,
      },
      {
        "name": "English",
        "score": "95",
        "color": Colors.red,
        "icon": Icons.language,
      },
      {
        "name": "Chemistry",
        "score": "88",
        "color": Colors.green,
        "icon": Icons.biotech,
      },
      {
        "name": "History",
        "score": "84",
        "color": Colors.brown,
        "icon": Icons.history_edu,
      },
      {
        "name": "ICT",
        "score": "97",
        "color": Colors.teal,
        "icon": Icons.computer,
      },
    ],
  };

  // 2. Calculator Logic for 7 Subjects
  final List<TextEditingController> _calcControllers = List.generate(
    7,
    (index) => TextEditingController(text: "0"),
  );
  double _calculatedAverage = 0.0;

  final List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];

  @override
  void initState() {
    super.initState();
    for (var controller in _calcControllers) {
      controller.addListener(_updateCalculation);
    }
  }

  void _updateCalculation() {
    double total = 0;
    for (var controller in _calcControllers) {
      total += double.tryParse(controller.text) ?? 0;
    }
    setState(() {
      _calculatedAverage = total / 7;
    });
  }

  double _getCurrentMonthAvg() {
    var list = monthlyData[selectedMonthIndex] ?? monthlyData[0]!;
    double sum = 0;
    for (var item in list) {
      sum += double.parse(item['score']);
    }
    return sum / 7;
  }

  @override
  Widget build(BuildContext context) {
    late final List<Widget> _screens = [
      _buildScoreContent(),
      Center(child: Text("Library", style: AppTextStyle.sectionTitle20)),
      Center(child: Text("Messages", style: AppTextStyle.sectionTitle20)),
      const StudentEditProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: pageIndex == 0 ? _buildAppBar(context) : null,
      body: IndexedStack(index: pageIndex, children: _screens),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: pageIndex,
        height: 60.0,
        items: const [
          Icon(Icons.grid_view_rounded, size: 30, color: Colors.white),
          Icon(Icons.menu_book, size: 30, color: Colors.white),
          Icon(Icons.chat_bubble, size: 30, color: Colors.white),
          Icon(Icons.settings, size: 30, color: Colors.white),
        ],
        color: const Color(0xFF007A7A),
        buttonBackgroundColor: const Color(0xFF007A7A),
        backgroundColor: const Color(0xFFF5F7F9),
        onTap: (index) => setState(() => pageIndex = index),
      ),
    );
  }

  Widget _buildScoreContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 15),
          _buildMonthSelector(),
          const SizedBox(height: 25),
          _buildSummaryCard(),
          const SizedBox(height: 30),
          _buildSubjectScoreList(),
          const SizedBox(height: 30),
          _buildCalculatorSection(),
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildMonthSelector() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: months.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedMonthIndex == index;
          return GestureDetector(
            onTap: () => setState(() => selectedMonthIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF007A7A) : Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF007A7A).withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Center(
                child: Text(
                  months[index],
                  style: AppTextStyle.body.copyWith(
                    color: isSelected ? Colors.white : Colors.blueGrey,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard() {
    double avg = _getCurrentMonthAvg();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF007A7A), Color(0xFF005A5A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF007A7A).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Average for ${months[selectedMonthIndex]}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            avg.toStringAsFixed(2),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 50,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            ),
          ),
          const Text(
            "TOTAL SCORE AVERAGE",
            style: TextStyle(
              color: Colors.white60,
              fontSize: 10,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatDetail(
                "GRADE",
                avg >= 90 ? "A+" : (avg >= 80 ? "B" : "C"),
              ),
              Container(height: 35, width: 1, color: Colors.white12),
              _buildStatDetail("STATUS", "PASSED"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectScoreList() {
    var subjects = monthlyData[selectedMonthIndex] ?? monthlyData[0]!;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Subject Analysis",
                style: AppTextStyle.body.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              const Icon(Icons.insights, size: 20, color: Color(0xFF007A7A)),
            ],
          ),
          const SizedBox(height: 25),
          ...subjects
              .map(
                (s) => _subjectTile(
                  s['name'],
                  "${s['score']}/100",
                  s['color'],
                  s['icon'],
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _subjectTile(String name, String score, Color color, IconData icon) {
    double scoreVal = double.tryParse(score.split('/')[0]) ?? 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: scoreVal / 100,
                    backgroundColor: Colors.grey.withOpacity(0.1),
                    color: color,
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Text(
            score.split('/')[0],
            style: const TextStyle(
              color: Color(0xFF007A7A),
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculatorSection() {
    final List<String> subjectNames = [
      "Math",
      "Physics",
      "Khmer",
      "English",
      "Chem",
      "History",
      "ICT",
    ];
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Score Predictor",
            style: AppTextStyle.body.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          ...List.generate(
            7,
            (index) =>
                _calcInputField(subjectNames[index], _calcControllers[index]),
          ),
          const Divider(height: 40, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "ESTIMATED AVG",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.blueGrey,
                  fontSize: 12,
                ),
              ),
              Text(
                "${_calculatedAverage.toStringAsFixed(2)}%",
                style: const TextStyle(
                  color: Color(0xFF007A7A),
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _calcInputField(String label, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7F9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF007A7A),
              ),
              textAlign: TextAlign.right,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "0",
              ),
            ),
          ),
          const Text(
            " / 100",
            style: TextStyle(color: Colors.grey, fontSize: 11),
          ),
        ],
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
      title: const Text(
        "Academic Performance",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildStatDetail(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}
