
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';

// void main() => runApp(
//   const MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: StudentPermissionScreen(),
//   ),
// );

// // --- 1. DATA MODEL ---
// class LeaveRequest {
//   final String type;
//   final String date;
//   final String status;
//   final String reason;
//   final Color statusColor;

//   LeaveRequest({
//     required this.type,
//     required this.date,
//     required this.status,
//     required this.reason,
//     required this.statusColor,
//   });
// }

// // --- 2. MAIN SCREEN ---
// class StudentPermissionScreen extends StatefulWidget {
//   const StudentPermissionScreen({super.key});

//   @override
//   State<StudentPermissionScreen> createState() =>
//       _StudentPermissionScreenState();
// }

// class _StudentPermissionScreenState extends State<StudentPermissionScreen> {
//   int _pageIndex = 0;
//   final Color primaryTeal = const Color(0xFF007A7C);
//   final _formKey = GlobalKey<FormState>();

//   String? selectedLeaveType = 'Sick Leave';
//   DateTime? selectedDate;
//   final TextEditingController _reasonController = TextEditingController();

//   // History List stored in State so it updates when we submit
//   final List<LeaveRequest> historyData = [
//     LeaveRequest(
//       type: 'Sick Leave',
//       date: '12 Feb 2026',
//       status: 'Approved',
//       reason: 'High fever and flu',
//       statusColor: Colors.green,
//     ),
//     LeaveRequest(
//       type: 'Personal',
//       date: '10 Feb 2026',
//       status: 'Pending',
//       reason: 'Family emergency',
//       statusColor: Colors.orange,
//     ),
//   ];

//   // --- Date Picker Logic ---
//   Future<void> _pickDate() async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2030),
//     );
//     if (picked != null) setState(() => selectedDate = picked);
//   }

//   // --- Submit Logic (Real-time update) ---
//   void _submitForm() {
//     if (!_formKey.currentState!.validate()) return;
//     if (selectedDate == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please choose a date first")),
//       );
//       return;
//     }

//     setState(() {
//       // Add the new request to the top of the list
//       historyData.insert(
//         0,
//         LeaveRequest(
//           type: selectedLeaveType!,
//           date: DateFormat('dd MMM yyyy').format(selectedDate!),
//           status: 'Pending',
//           reason: _reasonController.text,
//           statusColor: Colors.orange,
//         ),
//       );
//       // Reset form
//       _reasonController.clear();
//       selectedDate = null;
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         backgroundColor: Colors.green,
//         content: Text("Permission request sent successfully!"),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FA),
//       appBar: _pageIndex == 0 ? _buildAppBar() : null,
//       body: IndexedStack(
//         index: _pageIndex,
//         children: [
//           _buildPermissionFormContent(),
//           const Center(child: Text("Library Screen")),
//           const Center(child: Text("Messages Screen")),
//           const Center(child: Text("Profile Settings")),
//         ],
//       ),
//       bottomNavigationBar: _buildBottomNavBar(),
//     );
//   }

//   Widget _buildPermissionFormContent() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(20.0),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 10,
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildLabel('Leave Type'),
//                   _buildDropdown(),
//                   const SizedBox(height: 20),
//                   _buildLabel('Date'),
//                   _buildDatePickerDisplay(),
//                   const SizedBox(height: 20),
//                   _buildLabel('Reason'),
//                   _buildReasonField(),
//                   const SizedBox(height: 25),
//                   _buildSubmitButton(),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 30),
//             _buildHistorySection(),
//           ],
//         ),
//       ),
//     );
//   }

//   // --- UI Components ---

//   Widget _buildDropdown() => Container(
//     padding: const EdgeInsets.symmetric(horizontal: 12),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(10),
//       border: Border.all(color: Colors.black12),
//     ),
//     child: DropdownButtonHideUnderline(
//       child: DropdownButton<String>(
//         value: selectedLeaveType,
//         isExpanded: true,
//         items: ['Sick Leave', 'Personal Leave', 'Other'].map((val) {
//           return DropdownMenuItem(value: val, child: Text(val));
//         }).toList(),
//         onChanged: (v) => setState(() => selectedLeaveType = v),
//       ),
//     ),
//   );

//   Widget _buildDatePickerDisplay() => InkWell(
//     onTap: _pickDate,
//     child: Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.black12),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             selectedDate == null
//                 ? 'Choose Date'
//                 : DateFormat('dd MMM yyyy').format(selectedDate!),
//             style: TextStyle(
//               color: selectedDate == null ? Colors.grey : Colors.black,
//             ),
//           ),
//           Icon(Icons.calendar_today, color: primaryTeal, size: 20),
//         ],
//       ),
//     ),
//   );

//   Widget _buildReasonField() => TextFormField(
//     controller: _reasonController,
//     maxLines: 3,
//     validator: (v) => (v == null || v.isEmpty) ? "Please enter a reason" : null,
//     decoration: InputDecoration(
//       hintText: 'Why do you need leave?',
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: const BorderSide(color: Colors.black12),
//       ),
//     ),
//   );

//   Widget _buildSubmitButton() => SizedBox(
//     width: double.infinity,
//     height: 55,
//     child: ElevatedButton(
//       onPressed: _submitForm,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: primaryTeal,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//       child: const Text(
//         'Submit Request',
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 16,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     ),
//   );

//   Widget _buildHistorySection() {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text(
//               'Leave History',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => AllHistoryScreen(data: historyData),
//                   ),
//                 );
//               },
//               child: Text(
//                 'View All',
//                 style: TextStyle(
//                   color: primaryTeal,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 10),
//         if (historyData.isEmpty)
//           const Padding(
//             padding: EdgeInsets.all(20.0),
//             child: Text("No requests found."),
//           )
//         else
//           _HistoryCard(item: historyData[0]), // Shows only the most recent one
//       ],
//     );
//   }

//   Widget _buildLabel(String text) => Padding(
//     padding: const EdgeInsets.only(bottom: 8.0),
//     child: Text(
//       text,
//       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//     ),
//   );

//   AppBar _buildAppBar() => AppBar(
//     backgroundColor: Colors.white,
//     elevation: 0,
//     title: const Text(
//       'Permission',
//       style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//     ),
//     centerTitle: true,
//     leading: IconButton(
//       icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
//       onPressed: () {},
//     ),
//   );

//   Widget _buildBottomNavBar() => CurvedNavigationBar(
//     index: _pageIndex,
//     items: const [
//       Icon(Icons.home, color: Colors.white),
//       Icon(Icons.book, color: Colors.white),
//       Icon(Icons.chat, color: Colors.white),
//       Icon(Icons.person, color: Colors.white),
//     ],
//     color: primaryTeal,
//     backgroundColor: const Color(0xFFF8F9FA),
//     onTap: (index) => setState(() => _pageIndex = index),
//   );
// }

// // --- 3. ALL HISTORY SCREEN ---
// class AllHistoryScreen extends StatelessWidget {
//   final List<LeaveRequest> data;
//   const AllHistoryScreen({super.key, required this.data});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FA),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text(
//           "All Leave Requests",
//           style: TextStyle(color: Colors.black),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: ListView.separated(
//         padding: const EdgeInsets.all(20),
//         itemCount: data.length,
//         separatorBuilder: (context, index) => const SizedBox(height: 15),
//         itemBuilder: (context, index) => _HistoryCard(item: data[index]),
//       ),
//     );
//   }
// }

// // --- 4. REUSABLE UI CARD ---
// class _HistoryCard extends StatelessWidget {
//   final LeaveRequest item;
//   const _HistoryCard({required this.item});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(color: Colors.black.withOpacity(0.05)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 item.type,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 10,
//                   vertical: 4,
//                 ),
//                 decoration: BoxDecoration(
//                   color: item.statusColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   item.status,
//                   style: TextStyle(
//                     color: item.statusColor,
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 5),
//           Text(
//             item.date,
//             style: const TextStyle(color: Colors.grey, fontSize: 13),
//           ),
//           const Divider(height: 24),
//           Text(
//             item.reason,
//             style: TextStyle(
//               color: Colors.black.withOpacity(0.7),
//               fontSize: 14,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

void main() => runApp(
  const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: StudentPermissionScreen(),
  ),
);

// --- 1. DATA MODEL ---
class LeaveRequest {
  final String type;
  final String date;
  final String status;
  final String reason;
  final Color statusColor;

  LeaveRequest({
    required this.type,
    required this.date,
    required this.status,
    required this.reason,
    required this.statusColor,
  });
}

// --- 2. MAIN SCREEN ---
class StudentPermissionScreen extends StatefulWidget {
  const StudentPermissionScreen({super.key});

  @override
  State<StudentPermissionScreen> createState() =>
      _StudentPermissionScreenState();
}

class _StudentPermissionScreenState extends State<StudentPermissionScreen> {
  int _pageIndex = 0;
  final Color primaryTeal = const Color(0xFF007A7C);
  final _formKey = GlobalKey<FormState>();

  String? selectedLeaveType = 'Sick Leave';
  DateTime? selectedDate;
  final TextEditingController _reasonController = TextEditingController();

  final List<LeaveRequest> historyData = [
    LeaveRequest(
      type: 'Sick Leave',
      date: '12 Feb 2026',
      status: 'Approved',
      reason: 'High fever and flu. Doctor prescribed 3 days of rest.',
      statusColor: Colors.green,
    ),
    LeaveRequest(
      type: 'Personal',
      date: '10 Feb 2026',
      status: 'Pending',
      reason: 'Family emergency requiring immediate travel.',
      statusColor: Colors.orange,
    ),
  ];

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please choose a date first")),
      );
      return;
    }

    setState(() {
      historyData.insert(
        0,
        LeaveRequest(
          type: selectedLeaveType!,
          date: DateFormat('dd MMM yyyy').format(selectedDate!),
          status: 'Pending',
          reason: _reasonController.text,
          statusColor: Colors.orange,
        ),
      );
      _reasonController.clear();
      selectedDate = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text("Permission request sent successfully!"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _pageIndex == 0 ? _buildAppBar() : null,
      body: IndexedStack(
        index: _pageIndex,
        children: [
          _buildPermissionFormContent(),
          const Center(child: Text("Library Screen")),
          const Center(child: Text("Messages Screen")),
          const Center(child: Text("Profile Settings")),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildPermissionFormContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Leave Type'),
                  _buildDropdown(),
                  const SizedBox(height: 20),
                  _buildLabel('Date'),
                  _buildDatePickerDisplay(),
                  const SizedBox(height: 20),
                  _buildLabel('Reason'),
                  _buildReasonField(),
                  const SizedBox(height: 25),
                  _buildSubmitButton(),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildHistorySection(),
          ],
        ),
      ),
    );
  }

  // UI Components
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
        items: ['Sick Leave', 'Personal Leave', 'Other'].map((val) {
          return DropdownMenuItem(value: val, child: Text(val));
        }).toList(),
        onChanged: (v) => setState(() => selectedLeaveType = v),
      ),
    ),
  );

  Widget _buildDatePickerDisplay() => InkWell(
    onTap: _pickDate,
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            selectedDate == null
                ? 'Choose Date'
                : DateFormat('dd MMM yyyy').format(selectedDate!),
            style: TextStyle(
              color: selectedDate == null ? Colors.grey : Colors.black,
            ),
          ),
          Icon(Icons.calendar_today, color: primaryTeal, size: 20),
        ],
      ),
    ),
  );

  Widget _buildReasonField() => TextFormField(
    controller: _reasonController,
    maxLines: 3,
    validator: (v) => (v == null || v.isEmpty) ? "Please enter a reason" : null,
    decoration: InputDecoration(
      hintText: 'Why do you need leave?',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.black12),
      ),
    ),
  );

  Widget _buildSubmitButton() => SizedBox(
    width: double.infinity,
    height: 55,
    child: ElevatedButton(
      onPressed: _submitForm,
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryTeal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text(
        'Submit Request',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );

  Widget _buildHistorySection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Leave History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllHistoryScreen(data: historyData),
                  ),
                );
              },
              child: Text(
                'View All',
                style: TextStyle(
                  color: primaryTeal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (historyData.isEmpty)
          const Text("No requests found.")
        else
          _HistoryCard(item: historyData[0]),
      ],
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
    ),
  );

  AppBar _buildAppBar() => AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    title: const Text(
      'Permission',
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    ),
    centerTitle: true,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
  );

  Widget _buildBottomNavBar() => CurvedNavigationBar(
    index: _pageIndex,
    items: const [
      Icon(Icons.home, color: Colors.white),
      Icon(Icons.book, color: Colors.white),
      Icon(Icons.chat, color: Colors.white),
      Icon(Icons.person, color: Colors.white),
    ],
    color: primaryTeal,
    backgroundColor: const Color(0xFFF8F9FA),
    onTap: (index) => setState(() => _pageIndex = index),
  );
}

// --- 3. ALL HISTORY SCREEN ---
class AllHistoryScreen extends StatelessWidget {
  final List<LeaveRequest> data;
  const AllHistoryScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "All Leave Requests",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: data.length,
        separatorBuilder: (context, index) => const SizedBox(height: 15),
        itemBuilder: (context, index) => _HistoryCard(item: data[index]),
      ),
    );
  }
}

// --- 4. DETAIL VIEW SCREEN ---
class RequestDetailScreen extends StatelessWidget {
  final LeaveRequest item;
  const RequestDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Permission Details",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.type,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: item.statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.status,
                    style: TextStyle(
                      color: item.statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Date: ${item.date}",
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const Divider(height: 40),
            const Text(
              "Reason for Leave:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              item.reason,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

// --- 5. REUSABLE UI CARD (Now Clickable) ---
class _HistoryCard extends StatelessWidget {
  final LeaveRequest item;
  const _HistoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RequestDetailScreen(item: item),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black.withOpacity(0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.type,
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
                    color: item.statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.status,
                    style: TextStyle(
                      color: item.statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              item.date,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const Divider(height: 24),
            Text(
              item.reason,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Tap to view details",
              style: TextStyle(
                color: Colors.teal,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
