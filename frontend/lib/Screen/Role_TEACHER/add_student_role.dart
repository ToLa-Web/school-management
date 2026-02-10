// import 'package:flutter/material.dart';

// class AddStudentScreen extends StatefulWidget {
//   const AddStudentScreen({super.key});

//   @override
//   State<AddStudentScreen> createState() => _AddStudentScreenState();
// }

// class _AddStudentScreenState extends State<AddStudentScreen> {
//   final Color primaryTeal = const Color(0xFF00B2B2);

//   // Example student data
//   final List<Map<String, dynamic>> students = [
//     {'name': 'សុខ វិបុល', 'id': '10293', 'class': '១២អា', 'selected': true},
//     {
//       'name': 'ចាន់ ស្រីមុំ',
//       'id': '10452',
//       'class': '១២ប៊ី',
//       'selected': false,
//     },
//     {'name': 'កែវ រតនា', 'id': '10884', 'class': '១២អា', 'selected': false},
//     {'name': 'លី ម៉ារីណា', 'id': '10521', 'class': '១២ប៊ី', 'selected': false},
//     {'name': 'ហេង វិបុល', 'id': '10119', 'class': '១២អា', 'selected': false},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FA),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios, color: primaryTeal, size: 20),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'បន្ថែមសិស្សទៅក្នុងថ្នាក់',
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           // 1. Search Bar
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: TextField(
//               decoration: InputDecoration(
//                 hintText: 'ឈ្មោះ ឬ លេខសម្គាល់',
//                 prefixIcon: const Icon(Icons.search, color: Colors.grey),
//                 filled: true,
//                 fillColor: Colors.white,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(15),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//           ),

//           // 2. Invite via QR Section
//           _buildInviteCard(),

//           // 3. Student List Header
//           Padding(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 16.0,
//               vertical: 8.0,
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'បញ្ជីឈ្មោះសិស្ស',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 4,
//                   ),
//                   decoration: BoxDecoration(
//                     color: primaryTeal.withValues(alpha: 0.1),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     'ជ្រើសរើសបាន ០៣ នាក់',
//                     style: TextStyle(color: primaryTeal, fontSize: 12),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // 4. Student List
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               itemCount: students.length,
//               itemBuilder: (context, index) {
//                 final student = students[index];
//                 return _buildStudentItem(student, index);
//               },
//             ),
//           ),

//           // 5. Confirm Button
//           _buildConfirmButton(),
//         ],
//       ),
//       bottomNavigationBar: _buildBottomNav(),
//     );
//   }

//   Widget _buildInviteCard() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: primaryTeal.withValues(alpha: 0.1),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(Icons.qr_code_scanner, color: primaryTeal),
//           ),
//           const SizedBox(width: 15),
//           const Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'អញ្ជើញតាមរយៈកូដ',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   'អនុញ្ញាតឱ្យសិស្សចូលរួមដោយដៃ',
//                   style: TextStyle(color: Colors.grey, fontSize: 12),
//                 ),
//               ],
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {},
//             style: ElevatedButton.styleFrom(
//               backgroundColor: primaryTeal,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               elevation: 0,
//             ),
//             child: const Text('អញ្ជើញ', style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStudentItem(Map<String, dynamic> student, int index) {
//     bool isSelected = student['selected'];
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(
//           color: isSelected ? primaryTeal : Colors.transparent,
//           width: 2,
//         ),
//       ),
//       child: ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         leading: const CircleAvatar(
//           radius: 25,
//           backgroundImage: NetworkImage(
//             'https://img.freepik.com/free-vector/mans-face-flat-style_90220-2877.jpg?semt=ais_hybrid&w=740&q=80',
//           ),
//         ),
//         title: Text(
//           student['name'],
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         subtitle: Text(
//           'ID: ${student['id']} • ថ្នាក់ទី ${student['class']}',
//           style: const TextStyle(color: Colors.grey, fontSize: 12),
//         ),
//         trailing: Transform.scale(
//           scale: 1.2,
//           child: Checkbox(
//             value: isSelected,
//             activeColor: primaryTeal,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(4),
//             ),
//             onChanged: (val) {
//               setState(() => students[index]['selected'] = val);
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildConfirmButton() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       color: Colors.white,
//       child: SizedBox(
//         width: double.infinity,
//         height: 55,
//         child: ElevatedButton(
//           onPressed: () {},
//           style: ElevatedButton.styleFrom(
//             backgroundColor: primaryTeal,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(15),
//             ),
//           ),
//           child: const Text(
//             'បញ្ជាក់ការបន្ថែម',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildBottomNav() {
//     return BottomNavigationBar(
//       type: BottomNavigationBarType.fixed,
//       currentIndex: 0,
//       selectedItemColor: primaryTeal,
//       items: const [
//         BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ទំព័រដើម'),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.calendar_month),
//           label: 'កាលវិភាគ',
//         ),
//         BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'សារ'),
//         BottomNavigationBarItem(icon: Icon(Icons.person), label: 'ប្រវត្តិរូប'),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "បន្ថែមសិស្សថ្មី",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text("បោះបង់", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image Section
              Center(
                child: Stack(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(
                        'https://via.placeholder.com/150',
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "ផ្ទុករូបថត",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              _buildSectionTitle(Icons.person_outline, "ព័ត៌មានលម្អិតសិស្ស"),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(child: _buildTextField("នាមខ្លួន", "ចាន់")),
                  const SizedBox(width: 15),
                  Expanded(child: _buildTextField("នាមត្រកូល", "សុខ")),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      "ថ្ងៃខែឆ្នាំកំណើត",
                      "mm/dd/yyyy",
                      icon: Icons.calendar_today,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildDropdownField("ភេទ", [
                      "ជ្រើសរើស",
                      "ប្រុស",
                      "ស្រី",
                    ]),
                  ),
                ],
              ),

              const SizedBox(height: 25),
              _buildSectionTitle(Icons.school_outlined, "ការចាត់តាំងថ្នាក់"),
              const SizedBox(height: 15),
              _buildDropdownField("កម្រិតថ្នាក់", [
                "ជ្រើសរើសថ្នាក់",
                "ថ្នាក់ទី ១០",
                "ថ្នាក់ទី ១១",
                "ថ្នាក់ទី ១២",
              ]),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdownField("ផ្នែក", ["A", "B", "C"]),
                  ),
                  const SizedBox(width: 15),
                  Expanded(child: _buildTextField("លេខរៀង", "001")),
                ],
              ),

              const SizedBox(height: 25),
              _buildSectionTitle(
                Icons.card_membership_outlined,
                "ការចូលប្រើប្រាស់ប្រព័ន្ធ",
              ),
              const SizedBox(height: 15),
              _buildTextField(
                "អ៊ីមែលសិស្ស",
                "student@school.edu",
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                "ពាក្យសម្ងាត់បណ្តោះអាសន្ន",
                "Student123!",
                isPassword: true,
              ),

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "បង្កើតគណនីសិស្ស",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "រក្សាទុកជាសេចក្តីព្រាង",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue, size: 20),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    String hint, {
    IconData? icon,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
        const SizedBox(height: 5),
        TextFormField(
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon != null ? Icon(icon, size: 20) : null,
            suffixIcon: isPassword
                ? const Icon(
                    Icons.visibility_outlined,
                    size: 20,
                    color: Colors.blue,
                  )
                : null,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: items[0],
              isExpanded: true,
              items: items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (_) {},
            ),
          ),
        ),
      ],
    );
  }
}
